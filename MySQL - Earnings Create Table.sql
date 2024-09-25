CREATE DATABASE earnings;

CREATE TABLE earnings (
    year INT,
    gender VARCHAR(50),
    job VARCHAR(50),
    salary FLOAT
);

select count(*) from earnings;
-- checking if all data was imported