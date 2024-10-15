CREATE SCHEMA IF NOT EXISTS hashchecker;

USE hashchecker;

CREATE TABLE IF NOT EXISTS users (
    id       INT PRIMARY KEY AUTO_INCREMENT,
    email    TEXT,
    password TEXT
);

CREATE TABLE IF NOT EXISTS records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    userID INT,
    hashcode TEXT,
    title TEXT,
    file_size INT
);

INSERT INTO users (email, password)
VALUES ('sashaprylutskyy@gmail.com', 'f59409f2f0f6ebb99d61f38fd86d651526414a3554249d7a902783fae68bac9c');

INSERT INTO users (email, password)
VALUES ('shurako@gmail.com', 'e878d87f0ea16cee88053091630f52e48b3b7b40f03d2f69071977a30f9fe4f8');