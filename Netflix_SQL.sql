CREATE DATABASE netflix_db;
USE netflix_db;
CREATE TABLE netflix (
    show_id VARCHAR(10),
    type VARCHAR(10),
    title VARCHAR(255),
    director VARCHAR(255),
    cast TEXT,
    country VARCHAR(50),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(50),
    listed_in VARCHAR(255),
    description TEXT
);

SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix_titles.csv'
INTO TABLE netflix
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Alter table netflix modify country varchar (150 );
select * from netflix ;
select count(*) as total from netflix;

/*1.  count the no of movies vs tv shows */

select type , count(*) as total from netflix group by type ;

/* 2. find most common rating for movie category */
SELECT type, rating, count
FROM (
    SELECT 
        type,
        rating,
        COUNT(*) AS count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY type, rating
) t
WHERE ranking = 1;

/* 3. List all movies released in specific year */
select title  , release_year from netflix where release_year = 2020 and type = 'Movie' ;

/* 4. find top 5 companies with most content on netflix  */
SELECT country, COUNT(show_id) AS content
FROM netflix
GROUP BY country
ORDER BY content DESC LIMIT 5;

/*5.  IDENTIFY THE LONGEST MOVIE */
SELECT TITLE , DURATION FROM netflix where type = 
'movie' and  duration = (Select max(duration) from netflix );


/*6. find the content added in last 5 year */

SELECT *
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

/* 7.find all movies / tv show by director 'rajiv chilaka '*/
select * from netflix where director Like '%Rajiv Chilaka%'  ;

/*8. List all tv shows with more then 5 seasons */
select * from netflix;
SELECT title,
       CAST(SUBSTRING_INDEX(duration, ' ', 1) as unsigned)  AS season  
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) as unsigned ) > 5;

/* 9. find all movies that are documentary */

select * from netflix where type= 'Movie' and listed_in like '%Documentaries%' ;
	
    
/*10 .  find all the content without a director */

select * from netflix 
WHERE director IS NULL OR director = '';

/*11 . find how many movie actor 'salman khan ' appeared in last 10 years */

select *  from netflix where cast like '%Salman Khan%' and  release_year > extract(year from current_date() ) -10;

/*Find the top 5 directors with the most Netflix titles.*/
SELECT director, COUNT(*) AS total_titles
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 5;


