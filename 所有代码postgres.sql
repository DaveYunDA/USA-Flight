/*
-- Individual Questions 1 For small dataset By Dawei Yun 500046368
SELECT b.name AS Airlines, COUNT(DISTINCT a.tailnum) AS Number_of_Aircrafts
FROM ontimeflightdata.Aircrafts a
JOIN ontimeflightdata.Flights_small f ON a.tailnum = f.tail_number
JOIN ontimeflightdata.Airlines b ON f.carrier_code = b.carrier_code
GROUP BY b.name
ORDER BY Number_of_Aircrafts DESC
LIMIT 3
*/





/*
-- Individual Questions 1 For medium dataset By Dawei Yun 500046368
SELECT b.name AS Airlines, COUNT(DISTINCT a.tailnum) AS Number_of_Aircrafts
FROM ontimeflightdata.Aircrafts a
JOIN ontimeflightdata.Flights_medium f ON a.tailnum = f.tail_number
JOIN ontimeflightdata.Airlines b ON f.carrier_code = b.carrier_code
GROUP BY b.name
ORDER BY Number_of_Aircrafts DESC
LIMIT 3
*/





/*
-- Question 2 which airline departs late the most using flights_small By Jinpeng Han 500117613
WITH late_departures AS (
    SELECT flights_small.carrier_code, airlines.name
    FROM ontimeflightdata.airlines, ontimeflightdata.flights_small
    WHERE airlines.carrier_code = flights_small.carrier_code
    AND flights_small.actual_departure_time > flights_small.scheduled_depature_time
)
SELECT name, COUNT(*) AS count_of_late_departures
FROM late_departures
GROUP BY name
ORDER BY count_of_late_departures DESC
LIMIT 1;
*/





/*
-- Question 2 which airline departs late the most using flights_medium By Jinpeng Han 500117613
WITH late_departures AS (
    SELECT flights_medium.carrier_code, airlines.name
    FROM ontimeflightdata.airlines, ontimeflightdata.flights_medium
    WHERE airlines.carrier_code = flights_medium.carrier_code
    AND flights_medium.actual_departure_time > flights_medium.scheduled_depature_time
)
SELECT name, COUNT(*) AS count_of_late_departures
FROM late_departures
GROUP BY name
ORDER BY count_of_late_departures DESC
LIMIT 1;
*/




/*
-- GROUP QUESTION 1 FOR SMALL DATASET
-- Transform the time format and JOIN the required TABLE to obtain the required column
WITH carr_delay as (
	SELECT  b.name, a.manufacturer, a.model,
	(to_timestamp(flight_date||' '||actual_arrival_time,'YYYY-MM-DD HH24MI') - 
	to_timestamp(flight_date||' '||scheduled_arrival_time,'YYYY-MM-DD HH24MI'))/60 as delay_arrival,
	(to_timestamp(flight_date||' '||actual_departure_time,'YYYY-MM-DD HH24MI') - 
	to_timestamp(flight_date||' '||scheduled_depature_time,'YYYY-MM-DD HH24MI'))/60 as delay_depature,
	(to_timestamp(flight_date||' '||actual_arrival_time,'YYYY-MM-DD HH24MI') - 
	to_timestamp(flight_date||' '||scheduled_arrival_time,'YYYY-MM-DD HH24MI'))/60 + 
	(to_timestamp(flight_date||' '||actual_departure_time,'YYYY-MM-DD HH24MI') - 
	to_timestamp(flight_date||' '||scheduled_depature_time,'YYYY-MM-DD HH24MI')) /60 as total_delay
	FROM ontimeflightdata.flights_small f
	JOIN ontimeflightdata.aircrafts a ON a.tailnum = f.tail_number
	JOIN ontimeflightdata.airlines b ON b.carrier_code = f.carrier_code
	WHERE scheduled_depature_time IS NOT NULL 
	AND scheduled_arrival_time IS NOT NULL 
	AND actual_departure_time IS NOT NULL 
	AND actual_arrival_time IS NOT NULL 
	AND tail_number IS NOT NULL
	AND actual_departure_time < '2400'
	AND scheduled_depature_time < '2400'
	AND actual_arrival_time < '2400'
	AND scheduled_arrival_time < '2400'
	AND to_timestamp(flight_date||' '||actual_arrival_time,'YYYY-MM-DD HH24MI') > 
	to_timestamp(flight_date||' '||scheduled_arrival_time,'YYYY-MM-DD HH24MI')
	AND to_timestamp(flight_date||' '||actual_departure_time,'YYYY-MM-DD HH24MI') > 
	to_timestamp(flight_date||' '||scheduled_depature_time,'YYYY-MM-DD HH24MI')),
	-- small table of delay for airline
	max_delay_airline as (SELECT name, SUM(total_delay) as total_delay_airline
	FROM carr_delay
	GROUP BY name
	ORDER BY SUM(total_delay) DESC
	LIMIT 1),
	-- small table of delay for aircraft
	max_aircraft_delay as (
		SELECT name, manufacturer, model, SUM(total_delay) as total_delay_min
		FROM carr_delay
		GROUP BY name, manufacturer, model
		ORDER BY SUM(total_delay) DESC
		LIMIT 1)
SELECT a.name as airline_name, 
EXTRACT(epoch FROM a.total_delay_airline) as total_airline_delay, 
b.manufacturer, 
b.model, 
EXTRACT(epoch FROM b.total_delay_min) as cumulative_lateness_of_model,
ROUND(EXTRACT(epoch FROM b.total_delay_min) / 
	  EXTRACT(epoch FROM a.total_delay_airline) * 10) / 10 
	  as percentage_of_total_lateness_for_airline
FROM max_delay_airline a 
JOIN max_aircraft_delay b ON a.name = b.name
*/





/*
-- GROUP QUESTION 1 FOR Medium DATASET
-- Transform the time format and JOIN the required TABLE to obtain the required column
WITH carr_delay as (
	SELECT  b.name, a.manufacturer, a.model,
	(to_timestamp(flight_date||' '||actual_arrival_time,'YYYY-MM-DD HH24MI') - 
	to_timestamp(flight_date||' '||scheduled_arrival_time,'YYYY-MM-DD HH24MI'))/60 as delay_arrival,
	(to_timestamp(flight_date||' '||actual_departure_time,'YYYY-MM-DD HH24MI') - 
	to_timestamp(flight_date||' '||scheduled_depature_time,'YYYY-MM-DD HH24MI'))/60 as delay_depature,
	(to_timestamp(flight_date||' '||actual_arrival_time,'YYYY-MM-DD HH24MI') - 
	to_timestamp(flight_date||' '||scheduled_arrival_time,'YYYY-MM-DD HH24MI'))/60 + 
	(to_timestamp(flight_date||' '||actual_departure_time,'YYYY-MM-DD HH24MI') - 
	to_timestamp(flight_date||' '||scheduled_depature_time,'YYYY-MM-DD HH24MI')) /60 as total_delay
	FROM ontimeflightdata.flights_medium f
	JOIN ontimeflightdata.aircrafts a ON a.tailnum = f.tail_number
	JOIN ontimeflightdata.airlines b ON b.carrier_code = f.carrier_code
	WHERE scheduled_depature_time IS NOT NULL 
	AND scheduled_arrival_time IS NOT NULL 
	AND actual_departure_time IS NOT NULL 
	AND actual_arrival_time IS NOT NULL 
	AND tail_number IS NOT NULL
	AND actual_departure_time < '2400'
	AND scheduled_depature_time < '2400'
	AND actual_arrival_time < '2400'
	AND scheduled_arrival_time < '2400'
	AND to_timestamp(flight_date||' '||actual_arrival_time,'YYYY-MM-DD HH24MI') > 
	to_timestamp(flight_date||' '||scheduled_arrival_time,'YYYY-MM-DD HH24MI')
	AND to_timestamp(flight_date||' '||actual_departure_time,'YYYY-MM-DD HH24MI') > 
	to_timestamp(flight_date||' '||scheduled_depature_time,'YYYY-MM-DD HH24MI')),
	-- small table of delay for airline
	max_delay_airline as (SELECT name, SUM(total_delay) as total_delay_airline
	FROM carr_delay
	GROUP BY name
	ORDER BY SUM(total_delay) DESC
	LIMIT 1),
	-- small table of delay for aircraft
	max_aircraft_delay as (
		SELECT name, manufacturer, model, SUM(total_delay) as total_delay_min
		FROM carr_delay
		GROUP BY name, manufacturer, model
		ORDER BY SUM(total_delay) DESC
		LIMIT 1)


SELECT a.name as airline_name, 
EXTRACT(epoch FROM a.total_delay_airline) as total_airline_delay, 
b.manufacturer, 
b.model, 
EXTRACT(epoch FROM b.total_delay_min) as cumulative_lateness_of_model,
ROUND(EXTRACT(epoch FROM b.total_delay_min) / 
	  EXTRACT(epoch FROM a.total_delay_airline) * 10) / 10 
	  as percentage_of_total_lateness_for_airline
FROM max_delay_airline a 
JOIN max_aircraft_delay b ON a.name = b.name
*/





/*
-- GROUP QUESTION 2 For small dataset
-- Change time format
WITH timetable as (SELECT 
		to_timestamp(flight_date||' '||actual_arrival_time,'YYYY-MM-DD HH24MI') - 
		to_timestamp(flight_date||' '||actual_departure_time,'YYYY-MM-DD HH24MI') as flight_sec,
		a.airport,
		a.iata,
		f.carrier_code,
		b.name
		FROM ontimeflightdata.flights_small f 
		JOIN ontimeflightdata.airports a ON f.destination = a.iata 
		JOIN ontimeflightdata.airlines b ON f.carrier_code = b.carrier_code
		WHERE actual_departure_time IS NOT NULL 
		AND actual_arrival_time IS NOT NULL 
		AND actual_departure_time < '2400' 
		AND actual_arrival_time < '2400'
		AND to_timestamp(flight_date||' '||actual_arrival_time,'YYYY-MM-DD HH24MI') >
		to_timestamp(flight_date||' '||actual_departure_time,'YYYY-MM-DD HH24MI')),
	-- avg second
	avg_time as (SELECT AVG(flight_sec) as avg_time FROM timetable),
	-- airline with most arrivals and number of flight arrivals of that airline
	company as (
		SELECT airport as airport_name, name,
		COUNT(name) as number_of_longflight_arrivals_of_airline,
		max(flight_sec)
		FROM avg_time, timetable
		WHERE flight_sec > avg_time
		GROUP BY airport_name, name),
	-- ariport with longest flight arrivals
	airport as (
		SELECT iata as airport_code, 
		airport as airport_name, 
		COUNT(flight_sec) as number_of_longflight_arrivals, 
		ROUND(AVG(EXTRACT(epoch FROM flight_sec)) / 60 * 10) / 10 as average_longflight_duration
		FROM avg_time, timetable
		WHERE flight_sec > avg_time
		GROUP BY airport, iata
		ORDER BY AVG(flight_sec) DESC),
	-- max number of flight for longflight of a airport
	max_flight_airline as (
		SELECT airport_name, 
		MAX(number_of_longflight_arrivals_of_airline) as max_number_of_flight
		FROM company
		GROUP BY airport_name)

SELECT a.airport_code, 
a.airport_name, 
a.number_of_longflight_arrivals, 
a.average_longflight_duration, 
c.name as airline_name_with_most_longflight_arrivals,
c.number_of_longflight_arrivals_of_airline
FROM airport a 
JOIN company c ON a.airport_name = c.airport_name
JOIN max_flight_airline m ON c.airport_name = m.airport_name
WHERE c.number_of_longflight_arrivals_of_airline = max_number_of_flight
ORDER BY average_longflight_duration DESC
LIMIT 5
*/



/*
-- GROUP QUESTION 2 For Medium dataset
-- Change time format
WITH timetable as (SELECT 
		to_timestamp(flight_date||' '||actual_arrival_time,'YYYY-MM-DD HH24MI') - 
		to_timestamp(flight_date||' '||actual_departure_time,'YYYY-MM-DD HH24MI') as flight_sec,
		a.airport,
		a.iata,
		f.carrier_code,
		b.name
		FROM ontimeflightdata.flights_medium f 
		JOIN ontimeflightdata.airports a ON f.destination = a.iata 
		JOIN ontimeflightdata.airlines b ON f.carrier_code = b.carrier_code
		WHERE actual_departure_time IS NOT NULL 
		AND actual_arrival_time IS NOT NULL 
		AND actual_departure_time < '2400' 
		AND actual_arrival_time < '2400'
		AND to_timestamp(flight_date||' '||actual_arrival_time,'YYYY-MM-DD HH24MI') >
		to_timestamp(flight_date||' '||actual_departure_time,'YYYY-MM-DD HH24MI')),
	-- avg second
	avg_time as (SELECT AVG(flight_sec) as avg_time FROM timetable),
	-- airline with most arrivals and number of flight arrivals of that airline
	company as (
		SELECT airport as airport_name, name,
		COUNT(name) as number_of_longflight_arrivals_of_airline,
		max(flight_sec)
		FROM avg_time, timetable
		WHERE flight_sec > avg_time
		GROUP BY airport_name, name),
	-- ariport with longest flight arrivals
	airport as (
		SELECT iata as airport_code, 
		airport as airport_name, 
		COUNT(flight_sec) as number_of_longflight_arrivals, 
		ROUND(AVG(EXTRACT(epoch FROM flight_sec)) / 60 * 10) / 10 as average_longflight_duration
		FROM avg_time, timetable
		WHERE flight_sec > avg_time
		GROUP BY airport, iata
		ORDER BY AVG(flight_sec) DESC),
	-- max number of flight for longflight of a airport
	max_flight_airline as (
		SELECT airport_name, 
		MAX(number_of_longflight_arrivals_of_airline) as max_number_of_flight
		FROM company
		GROUP BY airport_name)

SELECT a.airport_code, 
a.airport_name, 
a.number_of_longflight_arrivals, 
a.average_longflight_duration, 
c.name as airline_name_with_most_longflight_arrivals,
c.number_of_longflight_arrivals_of_airline
FROM airport a 
JOIN company c ON a.airport_name = c.airport_name
JOIN max_flight_airline m ON c.airport_name = m.airport_name
WHERE c.number_of_longflight_arrivals_of_airline = max_number_of_flight
ORDER BY average_longflight_duration DESC
LIMIT 5
*/
