-- Training script by Wojciech Skwierawski for Volue

--This script should not be executed as a whole
RAISERROR ('Oooopsie. This file should not be executed this way ;).',20,-1) with log

---------------------------------------- NEW DATABASE
-- CREATE DATABASE <database name>
-- DROP DATABASE <database name>
-- USE <database name>

create database MyNewDatabase
use MyNewDatabase
use AdventureWorks2019
drop database MyNewDatabase
--Will not work if this database is open somewhere else

-- [Ex. 1.1]
-- Create a new database called 'SQL_training2'

---------------------------------------- CREATING TABLES
--CREATE TABLE <table name> (
--    <column name> <column type>,
--    <column2 name> <column2 type>,
--    <column3 name> <column3 type>,
--   .... <more columns>
--);

-- ALL DATATYPES 
-- https://www.w3schools.com/sql/sql_datatypes.asp#:~:text=SQL%20Server%20Data%20Types

create table Animal (
	AnimalID uniqueidentifier NOT NULL,
	Name varchar(40) NOT NULL,
	Age int NOT NULL,
	IsFlying bit NULL,
	Birthdate datetime2
)

-- [Ex. 2.1]
-- Create a new table 'Employee' in the new database
-- that will store person's GUID ID, first name, last name, age, status if it is a permanent employee (IsPermanent),
-- start date of contract and hourly rate

-- [Ex. 2.2]
-- Add 2 new employess to Your new table


---------------------------------------- ALTERING TABLES

--ALTER TABLE <table name>
--ADD <column name> <column type>;

alter table Animal 
	add	IsSwimming bit

alter table Animal 
	drop column	Birthdate 

alter table Animal 
	alter column Name varchar(40) NULL

-- [Ex. 3.1]
-- Add column to Your new table Employee with person's title in the company

-- [Ex. 3.2]
-- Delete hourly rate column from table Employee

-- [Ex. 3.3]
-- Change the column ContractStartDate from datetime2 to ContractStartDateTicks bigint
-- To do this You need to perform 3 operations
-- 1. Add new column
-- 2. update that column values (use method from below. The method is complicated and long. Do not care if You do not understand it now ;])
-- 3. Delete old column

-- (method) DATEDIFF_BIG( microsecond, '00010101', @DateTime ) * 10 + ( DATEPART( NANOSECOND, @DateTime ) % 1000 ) / 100;

---------------------------------------- ALTERING TABLES

--DROP TABLE <table name>

drop table Animal

-- [Ex. 4.1]
-- Drop Your new table Employee