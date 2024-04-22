-- -----------------------------------------------------------------------------------------------------------
-- ------------------------------------- Collecting our data -------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------

-- first off, before importing our data we should create a database to load our data into 

CREATE DATABASE PROJECT;
-- To work with this database

USE PROJECT;

-- create a table that will contain our CSV File

ALTER TABLE calls;

CREATE TABLE calls (
    ID CHAR(50),
    cust_name CHAR(50),
    Sentiment CHAR(20),
    csat_score INT,
    call_timestamp CHAR(10),
    reason CHAR(20),
    city CHAR(20),
    state CHAR(20),
    channel CHAR(20),
    response_time CHAR(20),
    call_duration_minutes INT,
    call_center CHAR(20)
);

-- Looking at our data
SELECT 
    *
FROM
    calls
LIMIT 10;

-- ------------------------------------------- Cleaning the Data ----------------------------------
-- Converting the call_timestamp from a string to a date

SET SQL_SAFE_UPDATES = 0 ;
UPDATE calls 
SET 
    call_timestamp = STR_TO_DATE(call_timestamp, "%m/%d/%Y");
SET SQL_SAFE_UPDATES = 1;
SELECT 
    *
FROM
    calls
LIMIT 10;

-- Setting the Zeros to null
UPDATE calls 
SET 
    csat_score = NULL
WHERE
    csat_score = 0;
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM calls2 LIMIT 10;

-- ---------------------------------------- Exploring our Data --------------------------------------------------

-- Looking at the shape of our dataset

SELECT 
    COUNT(*) AS rows_num
FROM
    calls;

SELECT 
    COUNT(*) AS cols_num
FROM
    information_schema.columns
WHERE
    table_name = 'calls';

-- -----------------------Checking the Distinct Values of Several columns----------------------------------------

SELECT DISTINCT
    sentiment
FROM
    calls; 
    
SELECT DISTINCT
    reason
FROM
    calls;

SELECT DISTINCT
    Channel
FROM
    calls;
    
SELECT DISTINCT
    response_time
FROM
    calls;
    
-- ---------------------------- Finding the count and percentage total of each distinct value ----------------------------------------------

SELECT sentiment, COUNT(*), ROUND((COUNT(*)/(SELECT COUNT(*) FROM calls))*100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT reason, COUNT(*), ROUND((COUNT(*)/(SELECT COUNT(*) FROM calls))*100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT channel, COUNT(*), ROUND((COUNT(*)/(SELECT COUNT(*) FROM calls))*100,1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT response_time, COUNT(*), ROUND((COUNT(*)/(SELECT COUNT(*) FROM calls))*100, 1) AS Pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT call_center, COUNT(*), ROUND((COUNT(*)/(SELECT COUNT(*) FROM calls))*100, 1) AS Pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT state, COUNT(*) FROM calls GROUP BY 1 ORDER BY 2 DESC;

-- Lets explore the Distribution of Calls among different Columns

-- The count and Percentage from Total of each of the distinct values in the data:

SELECT sentiment, COUNT(*), ROUND((COUNT(*)/(SELECT COUNT(*) FROM calls))*100, 1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT reason, COUNT(*), ROUND((COUNT(*)/(SELECT COUNT(*) FROM calls))*100, 1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;

-- Looking at the day with the most calls
SELECT DAYNAME(call_timestamp) as Day_of_call, COUNT(*) num_of_calls FROM calls GROUP BY 1 ORDER BY 2 DESC;

-- Aggregations
SELECT MIN(csat_score) AS min_score, MAX(csat_score) AS max_score, ROUND(AVG(csat_score), 1) AS avg_score
FROM calls WHERE csat_score !=0; 

SELECT MIN(call_timestamp) AS earliest_date, MAX(call_timestamp) AS most_recent FROM calls;

SELECT call_center, response_time, COUNT(*) AS COUNT
FROM calls GROUP BY 1,2 ORDER BY 1,3 DESC;

SELECT MIN(call_duration_minutes) AS min_call_duration, MAX(call_duration_minutes) AS max_call_duration, AVG(call_duration_minutes) AS avg_call_duration FROM calls;

SELECT call_center, response_time, COUNT(*) AS COUNT 
FROM calls GROUP BY 1,2 ORDER BY 1,3 DESC;

SELECT call_center, AVG(call_duration_minutes) FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT channel, AVG(call_duration_minutes) FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT state, COUNT(*) FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT state, reason, COUNT(*) FROM calls GROUP BY 1,2 ORDER BY 1,2,3 DESC;

SELECT state, sentiment, COUNT(*) FROM calls GROUP BY 1,2 ORDER BY 1,3 DESC;

SELECT state, AVG(csat_score) as avg_csat_score FROM calls WHERE csat_score != 0 GROUP BY 1 ORDER BY 2 DESC;

SELECT sentiment, AVG(call_duration_minutes) FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT call_timestamp, MAX(call_duration_minutes) OVER(PARTITION BY call_timestamp) AS max_Call_duration FROM calls GROUP BY 1 ORDER BY 2 DESC;