--Show the number of lessons given per month during a specified year. 
SELECT date_trunc('month', start_time) AS MONTH,
	COUNT(id) AS COUNT,
	COUNT(group_lesson_id) AS grouplesson,
	COUNT(individual_lesson_id) AS individuallesson,
	COUNT(ensemble_id) AS ensemble
FROM class_type
WHERE EXTRACT (YEAR FROM start_time) = 2021
GROUP BY date_trunc ('month', start_time);

--Retrieve the average number of lessons per month during the entire year.
SELECT DATE_TRUNC('year',start_time) AS  year,
    (COUNT(id)/12::float) AS avgLessonPerMonth, 
	(COUNT(group_lesson_id)/12::float) AS avgGroupLessonPerMonth,
	(COUNT(ensemble_id)/12::float) AS avgEnsemblePerMonth,
	(COUNT(individual_lesson_id)/12::float) AS avgIndividualLessonPerMonth
FROM class_type
GROUP BY DATE_TRUNC('year',start_time);

--List all instructors who has given more than a specific number of lessons during the current month. 
--Sum all lessons, independent of type, and sort the result by the number of given lessons.
SELECT class_type.instructor_id AS instructor,
	COUNT(id) AS nbrOfLessons
FROM class_type
WHERE date_trunc('month', start_time) = date_trunc('month', now())
GROUP BY instructor_id
HAVING COUNT(id) > 1
ORDER BY nbrOfLessons desc

--List all ensembles held during the next week, sorted by music genre and weekday. 
--For each ensemble tell whether it's full booked, has 1-2 seats left or has more seats left.
SELECT start_time, end_time, type_of_instrument_or_genre,ensemble.minimum_nbr, 
ensemble.maximum_nbr, ensemble.id,
(CASE 
	WHEN Spots_left = 0 THEN 'The class is full'
	WHEN Spots_left = 1 THEN 'There is one spot left for this class'
	WHEN Spots_left = 2 THEN 'There are two spots left for this class'
	WHEN Spots_left > 2 THEN 'There is space left for this class'
END) AS spot_message
FROM class_type
JOIN ensemble
ON ensemble_id=ensemble.id

WHERE start_time > '2022-01-20' AND start_time < '2022-01-27' 
ORDER BY type_of_instrument_or_genre, start_time ASC