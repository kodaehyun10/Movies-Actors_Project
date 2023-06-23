
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

USE imdb;
Select 'director_mapping' as table_name, count(*) as row_count from director_mapping
Union ALL
Select 'genre' as table_name, count(*) as row_count from genre
Union ALL
Select 'movie' as table_name, count(*) as row_count from movie
Union ALL
Select 'names' as table_name, count(*) as row_count from names
Union ALL
Select 'ratings' as table_name, count(*) as row_count from ratings
Union ALL
Select 'role_mapping' AS table_name, count(*) as row_count from role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT *
FROM imdb.movie
WHERE id IS NULL OR title IS NULL OR year IS NULL OR date_published IS NULL OR duration IS NULL OR country IS NULL OR worlwide_gross_income IS NULL OR languages IS NULL OR production_company IS NULL;



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944		    |
|	2019		|	2001			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 804			|
|	2			|	 640			|
|	3           |    824            |
|	4           |    680            |
|   5           |    625            |
|   6           |    580            |
|   7           |    493            |
|   8           |    678            |
|   9           |    809            |
|   10          |    801            |
|   11          |    625            |
|   12          |    438            |
+---------------+-------------------+ */
-- Type your code below:

SELECT YEAR(date_published) as Year, COUNT(*) as number_of_movies
FROM movie
GROUP BY Year
ORDER BY Year;


SELECT MONTH(date_published) as month_num, COUNT(*) as number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(*) AS Movie_Count 
FROM imdb.movie
WHERE (country='India' OR country='USA' OR country LIKE '%USA%')  AND year = '2019';




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM genre;



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, COUNT(*) AS movie_count
FROM imdb.genre
GROUP BY genre
ORDER BY movie_count DESC;




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(DISTINCT movie_id) as one_genre_movie
FROM genre
WHERE movie_id IN (
  SELECT movie_id
  FROM genre
  GROUP BY movie_id
  HAVING COUNT(DISTINCT genre) = 1);



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, AVG(duration) AS average_duration 
FROM imdb.genre
JOIN imdb.movie ON movie_id = id
GROUP BY genre
ORDER BY average_duration DESC;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	1484			|			1		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT genre, COUNT(*) as movie_count,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
FROM genre
GROUP BY genre
HAVING genre = 'thriller';


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating), MAX(avg_rating), MIN(total_votes), MAX(total_votes), MIN(median_rating), MAX(median_rating) 
FROM imdb.ratings


    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Love in Kilnerry		|		10	    |			1	  |
|	Kirket		        |		10		|			1	  |
|	Gini Helida Kathe	|		9.8		|			3	  |
|	Runam			    |		9.7	    |			4	  |
|   Fan                 |       9.6     |           5     |
|   Android Kunjappan   |       9.6     |           5     |
|    Version 5.25       |               |                 |
|    Yeh Suhaagraat     |       9.5     |           7     |
|     Impossible        |               |                 |
|       Safe            |       9.5     |           7     |
|The Brighton Miracle   |       9.5     |           7     | 
|       Shibu           |       9.4     |           10    | 
+--------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT movie.title, AVG(ratings.avg_rating) as average_rating, 
       RANK() OVER (ORDER BY AVG(ratings.avg_rating) DESC) as movie_rank
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
GROUP BY movie.id
ORDER BY average_rating DESC
LIMIT 10;



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating, COUNT('median ratings') AS movie_count 
FROM imdb.ratings
GROUP BY median_rating;
ORDER BY movie_count DESC;



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| Null	           |		21	       |			1	     |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company, COUNT(*) as movie_count,
       RANK() OVER (ORDER BY COUNT(*) DESC) as prod_company_rank
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
WHERE ratings.avg_rating > 8
GROUP BY production_company
ORDER BY movie_count DESC
LIMIT 1;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, COUNT(genre) AS movie_count
FROM imdb.genre
JOIN imdb.ratings ON imdb.genre.movie_id = imdb.ratings.movie_id
JOIN imdb.movie ON imdb.genre.movie_id = imdb.movie.id
WHERE date_published >= '2017-03-01'
AND date_published < '2017-04-01'
AND total_votes >= 1000
GROUP BY genre
ORDER BY movie_count DESC;



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| The blue Elephant 2|		8.8			|		Crime     |
| The blue Elephant 2|		8.8			|		Horror    |
| The blue Elephant 2|      8.8         |       Mystery   |
| The Brighton Miracle|		9.5	.		|       Drama     |
|  The Irishman      |      8.7         |       Crime     |
|  The Irishman        |    8.7         |       Drama     |
| The Color of Darkness|    9.1         |       Drama     |
| Theeran Adhigaaram Ondru| 8.3         |       Action    |
| Theeran Adhigaaram Ondru| 8.3         |       Crime     |
| Theeran Adhigaaram Ondru| 8.3         |       Thriller  |
| The Mystery of Godliness:|8.5         |       Drama     |
|   The Gambinos          | 8.4         |       Crime     |
|   The Gambinos          | 8.4         |       Drama     |
|   The King and I        | 8.2         |       Drama     |
|   The king and I        | 8.2         |       Romance   |
+---------------+-------------------+---------------------+*/


-- Type your code below:


SELECT movie.title, ratings.avg_rating, genre.genre
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
JOIN genre ON movie.id = genre.movie_id
WHERE movie.title LIKE 'The%'
  AND ratings.avg_rating > 8
GROUP BY movie.title, ratings.avg_rating, genre.genre;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(median_rating) AS movie_count 
FROM imdb.movie
JOIN imdb.ratings ON imdb.movie.id = imdb.ratings.movie_id
WHERE median_rating = 8 AND (date_published >='2018-04-01' AND date_published <= '2019-04-01');





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT
    SUM(IF(movie.country = 'Germany', ratings.total_votes, 0)) as german_votes,
    SUM(IF(movie.country = 'Italy', ratings.total_votes, 0)) as italian_votes
FROM movie
JOIN ratings ON movie.id = ratings.movie_id;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT *
FROM imdb.names
WHERE id IS NULL OR name IS NULL OR height IS NULL OR date_of_birth IS NULL OR known_for_movies IS NULL;



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|Michael Powell	|		1			|
|Emeric Pressburger|	1	.		|
|Ramesh Varma	|		1	    	|
+---------------+-------------------+ */
-- Type your code below:

SELECT names.name as director_name, COUNT(*) as movie_count
FROM movie
JOIN director_mapping ON movie.id = director_mapping.movie_id
JOIN ratings ON movie.id = ratings.movie_id
JOIN (
    SELECT movie_id
    FROM genre
    WHERE movie_id IN (
        SELECT movie_id
        FROM ratings
        WHERE avg_rating > 8
    )
    GROUP BY movie_id
    ORDER BY COUNT(*) DESC
    LIMIT 3
) AS top_movies ON top_movies.movie_id = movie.id
JOIN names ON director_mapping.name_id = names.id
WHERE ratings.avg_rating > 8
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT name
FROM imdb.ratings
JOIN imdb.role_mapping ON imdb.ratings.movie_id = imdb.role_mapping.movie_id
JOIN imdb.names ON imdb.role_mapping.name_id = imdb.names.id
WHERE median_rating>=8 
GROUP BY name 
LIMIT 2;



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| Marvel Studios	|   2656967		    |		1	  		  |
|Twentieth Century Fox|	2411163 		|		2    		  |
|Warner Bros.       |	2396057		    |		3   		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT movie.production_company as production_company, SUM(ratings.total_votes) AS vote_count, RANK() OVER (ORDER BY SUM(ratings.total_votes) DESC) as prod_comp_rank
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
GROUP BY production_company
ORDER BY vote_count DESC
LIMIT 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
  name,
  total_votes,
  movie_count,
  avg_rating,
  RANK() OVER (ORDER BY avg_rating DESC) AS ranking
FROM (
  SELECT
    imdb.names.name AS name,
    MAX(imdb.ratings.total_votes) AS total_votes,
    COUNT(imdb.names.name) AS movie_count,
    AVG(imdb.ratings.avg_rating) AS avg_rating
  FROM
    imdb.movie
    JOIN imdb.ratings ON imdb.movie.id = imdb.ratings.movie_id
    JOIN imdb.role_mapping ON imdb.ratings.movie_id = imdb.role_mapping.movie_id
    JOIN imdb.names ON imdb.role_mapping.name_id = imdb.names.id
  WHERE
    imdb.movie.country = 'India'
  GROUP BY
    imdb.names.name
  HAVING
    COUNT(imdb.names.name) >= 5
) AS actor_ratings;



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Shraddha Srinath|	26498	    |	       4		  |	   8.47561    		 |		1	       |
|	Anupama Kumar   |	1220		|	       3		  |	   8.03623	    	 |		2	       |
|	Regina Cassandra|	4810    	|	       4		  |	   7.74640	    	 |		3	       |
|	Taapsee Pannu   |  18895        |          5          |    7.70008           |      4          |
|	Aparajita Adhya |	1416|	    |		.  3          |    7.62832           |      5
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT names.name as actress_name, 
       SUM(ratings.total_votes) as total_votes,
       COUNT(DISTINCT movie.id) as movie_count,
       (SUM(ratings.avg_rating * ratings.total_votes) / SUM(ratings.total_votes)) as actress_avg_rating,
       RANK() OVER (ORDER BY (SUM(ratings.avg_rating * ratings.total_votes) / SUM(ratings.total_votes)) DESC, SUM(ratings.total_votes) DESC) as actress_rank
FROM names
JOIN role_mapping ON names.id = role_mapping.name_id
JOIN movie ON role_mapping.movie_id = movie.id
JOIN ratings ON movie.id = ratings.movie_id
WHERE role_mapping.category = 'actress'
      AND movie.country = 'India'
GROUP BY actress_name
HAVING COUNT(DISTINCT movie.id) >= 3
ORDER BY actress_rank
LIMIT 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title, avg_rating,
  CASE
    WHEN avg_rating > 8 THEN 'Superhit movies'
    WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
    WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
    ELSE 'Flop movies'
  END AS category
FROM imdb.genre
JOIN imdb.ratings ON imdb.genre.movie_id = imdb.ratings.movie_id
JOIN imdb.movie ON imdb.genre.movie_id = imdb.movie.id
ORDER BY avg_rating DESC;




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	Action		|	112.8829		|	  112.8829	       |	112.88290000 	 |
|	Adventure	|	101.8714		|	  101.8714   .	   |	101.87140000	 |
|	Comedy      |   102.6227        |     102.6227         |    102.62270000     |
|	Crime		|	107.0517	    |	  107.0517		   |    107.05170000     |
|	Drama       |   106.7746        |     106.7746         |    106.77460000     |
|	Family      |   100.9669        |     100.9669         |    100.96690000     |
|	Fantasy     |   105.1404        |     105.1404         |    105.14040000     |
|    Horror     |   92.7243         |     92.7243          |    92.72430000      |
|   Mystery     |   101.8000        |     101.8000         |    101.80000000     |
|   Others      |   100.1600        |     100.1600         |    100.16000000     |
|    Romance    |   109.5342        |     109.5342         |    109.53420000     |
|    Sci-fi     |   97.9413         |      97.9413         |    97.94130000      |
|    Thriller   |	101.5761 	    |	  101.5761         |    101.57610000     |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre.genre as genre,
       AVG(movie.duration) as avg_duration,
       SUM(AVG(movie.duration)) OVER (PARTITION BY genre.genre ORDER BY genre.genre, AVG(movie.duration)) as running_total_duration,
       AVG(AVG(movie.duration)) OVER (PARTITION BY genre.genre ORDER BY genre.genre, AVG(movie.duration) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as moving_avg_duration
FROM movie
JOIN genre ON movie.id = genre.movie_id
GROUP BY genre.genre
ORDER BY genre.genre, avg_duration;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

SELECT genre, year, title, worlwide_gross_income, movie_rank
FROM (
    SELECT imdb.genre.genre AS genre, year, title, worlwide_gross_income,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
    FROM imdb.movie
    JOIN imdb.genre ON imdb.movie.id = imdb.genre.movie_id
    WHERE imdb.genre.genre IN ('Drama', 'Comedy', 'Thriller')
) subquery
WHERE movie_rank <= 5
ORDER BY year, movie_rank;





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| NULL		        |		139			|		1	  		  |
| Star Cinema		|		7			|		2   		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company, COUNT(*) as movie_count,
       RANK() OVER (ORDER BY COUNT(*) DESC) as prod_comp_rank
FROM movie
WHERE id IN (
    SELECT movie_id
    FROM ratings
    WHERE median_rating >= 8
)
GROUP BY production_company
ORDER BY movie_count DESC
LIMIT 2;






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
names.name AS actress_name, ratings.total_votes AS total_votes, COUNT(*) AS movie_count, ratings.avg_rating as actress_avg_rating, 
RANK() OVER (ORDER BY COUNT(*) DESC) AS actress_rank
FROM imdb.genre
  JOIN imdb.movie ON genre.movie_id = movie.id
  JOIN imdb.role_mapping ON genre.movie_id = role_mapping.movie_id
  JOIN imdb.ratings ON genre.movie_id = imdb.ratings.movie_id
  JOIN imdb.names ON role_mapping.name_id = names.id
WHERE role_mapping.category = 'actress' AND imdb.ratings.avg_rating > 8 AND genre.genre = 'drama'
GROUP BY names.name, ratings.total_votes, ratings.avg_rating
ORDER BY movie_count DESC
LIMIT 3;




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
 director_id, director_name, number_of_movies, avg_inter_movie_days, avg_rating, total_votes, min_rating, max_rating, total_duration
'nm1777967', 'A.L. Vijay',       '5', '0.0000', '5.42000', '1754',  '3.7', '6.9', '613'
'nm2096009', 'Andrew Jones',     '5', '0.0000', '3.02000', '1989',  '2.7', '3.2', '432'
'nm0831321', 'Chris Stokes',     '4', '0.0000', '4.32500', '3664',  '4.0', '4.6', '352'
'nm2691863', 'Justin Price',     '4', '0.0000', '4.50000', '5343',  '3.0', '5.8', '346'
'nm0425364', 'Jesse V. Johnson', '4', '0.0000', '5.45000', '14778', '4.2', '6.5', '383'
'nm0001752', 'Steven Soderbergh','4', '0.0000', '6.47500', '171684','6.2', '7.0', '401'
'nm0814469', 'Sion Sono',        '4', '0.0000', '6.02500', '2972',  '5.4', '6.4', '502'
'nm6356309', 'Özgür Bakar',      '4', '0.0000', '3.75000', '1092',  '3.1', '4.9', '374'
'nm0515005', 'Sam Liu',          '4', '0.0000', '6.22500', '28557', '5.8', '6.7', '312'
-------------------------------------------------------------------------------------------*/
-- Type you code below:

SELECT director_mapping.name_id as director_id,
       names.name as director_name,
       COUNT(*) as number_of_movies,
       AVG(DATEDIFF(movie.date_published, COALESCE(prev_movie.date_published, movie.date_published))) as avg_inter_movie_days,
       AVG(ratings.avg_rating) as avg_rating,
       SUM(ratings.total_votes) as total_votes,
       MIN(ratings.avg_rating) as min_rating,
       MAX(ratings.avg_rating) as max_rating,
       SUM(movie.duration) as total_duration
FROM director_mapping
JOIN names ON director_mapping.name_id = names.id
JOIN movie ON director_mapping.movie_id = movie.id
JOIN ratings ON director_mapping.movie_id = ratings.movie_id
LEFT JOIN movie as prev_movie ON prev_movie.id = (
    SELECT MAX(id)
    FROM movie
    WHERE id < movie.id
)
GROUP BY director_id, director_name
ORDER BY number_of_movies desc
LIMIT 9;






