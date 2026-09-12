CREATE DATABASE Data_Access;
USE Data_Access;

CREATE TABLE companies (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255),
    duration INT,
    profile VARCHAR(255),
    stipend INT,
    work_from_home BOOLEAN,
    PRIMARY KEY (id)
);

desc companies;