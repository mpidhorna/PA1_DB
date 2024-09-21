USE practical_assignment_1

CREATE TABLE programs (
id int AUTO_INCREMENT PRIMARY KEY,
name varchar(100),
specialization varchar(100)
);

CREATE TABLE professors (
id int AUTO_INCREMENT PRIMARY KEY,
first_name varchar(50),
last_name varchar(100),
email varchar(100) UNIQUE
);

CREATE TABLE electives (
id int AUTO_INCREMENT PRIMARY KEY,
name varchar(100),
program_id int,
professor_id int,
FOREIGN KEY (program_id) REFERENCES programs(id),
FOREIGN KEY (professor_id) REFERENCES professors(id)
);

CREATE TABLE students (
id int AUTO_INCREMENT PRIMARY KEY,
first_name varchar(50),
last_name varchar(100),
email varchar(100) UNIQUE,
elective_id int,
FOREIGN KEY (elective_id) REFERENCES electives(id)
);

CREATE TABLE grades (
student_id int,
elective_id int,
grade float,
FOREIGN KEY (student_id) REFERENCES students(id),
FOREIGN KEY (elective_id) REFERENCES electives(id),
CHECK (grade BETWEEN 60 AND 100)
);

-- created tables` structure

WITH students_with_electives AS (
	SELECT concat(s.first_name, ' ', s.last_name) AS student, 
	s.email AS student_email, 
	e.name AS elective,
	p.name AS program, 
	p2.email AS professor_email, 
	g.grade AS grade
	FROM students s 
	JOIN electives e ON s.elective_id = e.id
	JOIN programs p ON e.program_id = p.id
	JOIN professors p2 ON e.professor_id = p2.id
	JOIN grades g ON g.student_id = s.id
)

	
SELECT elective AS name, round(avg(grade), 2) AS average_grade, count(student) AS students_enrolled
FROM students_with_electives
GROUP BY name
HAVING average_grade > (SELECT avg(grade) FROM students_with_electives)

UNION

SELECT program AS name, round(avg(grade), 2) AS average_grade, count(student) AS students_enrolled
FROM students_with_electives
GROUP BY name
HAVING average_grade > (SELECT avg(grade) FROM students_with_electives)
ORDER BY students_enrolled DESC

-- selected electives and programs where students got higher grades than average grade
