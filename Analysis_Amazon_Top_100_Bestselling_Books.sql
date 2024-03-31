/** Understanding data **/

SELECT * FROM 100_book_review.books
LIMIT 5;

SELECT * FROM 100_book_review.reviews
LIMIT 5;

/**Rating Distribution**/
/** Average, highest, and lowest books rating **/

SELECT 
	ROUND(AVG(rating),2) as avg_rating,
    MAX(rating) as max_rating,
    MIN(rating) as min_rating
FROM 100_book_review.books;

/** Books with highest rating **/

SELECT 
	`Rank`,
	`book title`
FROM 100_book_review.books
WHERE rating = (SELECT
				MAX(rating)
                FROM 100_book_review.books);

/** Books with lowest rating **/

SELECT 
	`Rank`,
	`book title`
FROM 100_book_review.books
WHERE rating = (SELECT
				MIN(rating)
                FROM 100_book_review.books);
                
/** Genre Analysis **/
/** Count maximum amount of genre in one book **/

SELECT MAX(LENGTH(genre) - LENGTH(REPLACE(genre,",","")) + 1) as genre_cnt_perbook
FROM 100_book_review.books;

/** eigth is found as the most genres in one book **/
/** Create table to split the genres **/

CREATE TABLE 100_book_review.split_genre
AS
SELECT
	`Rank`,
    `book title`,
    `book price`,
    `rating`,
    `author`,
    `year of publication`,
	SUBSTRING_INDEX(genre, ',',1) as genre_1,
    IF(
		LENGTH(genre) - LENGTH(REPLACE(genre,",","")) + 1 >= 2,
		SUBSTRING_INDEX(SUBSTRING_INDEX(genre, ',',2),',',-1), 
        ""
	) as genre_2,
    IF(
		LENGTH(genre) - LENGTH(REPLACE(genre,",","")) + 1 >= 3,
		SUBSTRING_INDEX(SUBSTRING_INDEX(genre, ',',3),',',-1), 
        ""
	) as genre_3,
    IF(
		LENGTH(genre) - LENGTH(REPLACE(genre,",","")) + 1 >= 4,
		SUBSTRING_INDEX(SUBSTRING_INDEX(genre, ',',4),',',-1), 
        ""
	) as genre_4,
    IF(
		LENGTH(genre) - LENGTH(REPLACE(genre,",","")) + 1 >= 5,
		SUBSTRING_INDEX(SUBSTRING_INDEX(genre, ',',5),',',-1), 
        ""
	) as genre_5,
    IF(
		LENGTH(genre) - LENGTH(REPLACE(genre,",","")) + 1 >= 6,
		SUBSTRING_INDEX(SUBSTRING_INDEX(genre, ',',6),',',-1), 
        ""
	) as genre_6,
    IF(
		LENGTH(genre) - LENGTH(REPLACE(genre,",","")) + 1 >= 7,
		SUBSTRING_INDEX(SUBSTRING_INDEX(genre, ',',7),',',-1), 
        ""
	) as genre_7,
    IF(
		LENGTH(genre) - LENGTH(REPLACE(genre,",","")) + 1 >= 8,
		SUBSTRING_INDEX(SUBSTRING_INDEX(genre, ',',8),',',-1), 
        ""
	) as genre_8
FROM 100_book_review.books;

/** Check table split_genre **/

SELECT * FROM 100_book_review.split_genre;

/** Create temporary table to list all genre **/

CREATE TEMPORARY TABLE list_genre AS
SELECT
	distinct TRIM(all_genre) as genre_list,
	COUNT(*) as genre_count
FROM
(
	(SELECT genre_1 as all_genre FROM 100_book_review.split_genre)
	UNION ALL
	(SELECT genre_2 as all_genre FROM 100_book_review.split_genre)
    UNION ALL
	(SELECT genre_3 as all_genre FROM 100_book_review.split_genre)
    UNION ALL
	(SELECT genre_4 as all_genre FROM 100_book_review.split_genre)
    UNION ALL
	(SELECT genre_5 as all_genre FROM 100_book_review.split_genre)
	UNION ALL
	(SELECT genre_6 as all_genre FROM 100_book_review.split_genre)
    UNION ALL
	(SELECT genre_7 as all_genre FROM 100_book_review.split_genre)
    UNION ALL
	(SELECT genre_8 as all_genre FROM 100_book_review.split_genre)
) as genres
WHERE all_genre != ""
GROUP BY genre_list
ORDER BY genre_count DESC;

/** Check table list_genre **/

SELECT * FROM list_genre;

/** Average rating of each genre **/

SELECT 
	l.genre_list as rated_genre,
    ROUND(AVG(rating),2) as avg_genre_rating
FROM 100_book_review.split_genre as s
RIGHT JOIN list_genre as l ON l.genre_list = s.genre_1
GROUP BY rated_genre
ORDER BY avg_genre_rating DESC;

/** Count books each author **/

SELECT 
	author,
    COUNT(*) as num_of_books
FROM 100_book_review.books
GROUP BY author
ORDER BY num_of_books DESC;

/** Average book price by each author **/

SELECT 
	author,
    AVG(`book price`) as avg_book_price
FROM 100_book_review.books
GROUP BY author
ORDER BY avg_book_price DESC;

/** Count of books each publisher **/

SELECT
	`year of publication`,
    COUNT(*) as num_of_books
FROM 100_book_review.books
GROUP BY `year of publication`
ORDER BY `year of publication`;

/** Count of review for each book **/

SELECT
	TRIM(`book name`) as title,
    COUNT(*) as review_count
FROM 100_book_review.reviews
GROUP BY title
ORDER BY review_count DESC;