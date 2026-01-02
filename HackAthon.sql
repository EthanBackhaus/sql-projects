--Ethan Backhaus, Lance Regher, Vivian Lin, Sebastian Cochran, Lucas Jensen


--Question 1 = Compound Query
select distinct constructors.constructorid, constructors.name, constructors.nationality
from constructors
where constructors.constructorid in (
select distinct results.constructorid
from results
join drivers on results.driverid = drivers.driverid
where drivers.dateofbirth < TO_DATE('1970-01-01', 'YYYY-MM-DD')

intersect

select distinct results.constructorid
from results
join drivers on results.driverid = drivers.driverid
where drivers.dateofbirth > TO_DATE('1990-01-01', 'YYYY-MM-DD')
)
;
--Question 2 = Case Query
SELECT sub.CircuitID, sub.Circuit_Name, sub.Country,round(sub.AvgTimInSeconds) as AVGTIMEINSECONDS,
CASE 
WHEN sub.AvgTimInSeconds > 120 THEN 'SLOW'
WHEN sub.AvgTimInSeconds BETWEEN 90 AND 120 THEN 'MEDIUM'
ELSE 'FAST'
END AS Classification
FROM (
SELECT C.CircuitID, C.Name AS Circuit_Name, C.Country,
AVG(R.Milliseconds / R.Laps) / 1000 AS AvgTimInSeconds
FROM RESULTS R
JOIN RACES RA ON R.RaceID = RA.RaceID
JOIN CIRCUITS C ON RA.CircuitID = C.CircuitID
WHERE R.PositionOrder = 1
GROUP BY C.CircuitID, C.Name, C.Country
) sub
ORDER BY sub.AvgTimInSeconds DESC;

--Question 3 = Join Query
SELECT d.lastname || ', ' || d.firstname AS Driver_Name, 
dn.DNum AS Number IS NULL, 
d.code, 
COUNT(r.Rank) AS Fastest_Laps 
FROM Results r 
JOIN Drivers d ON r.DriverID = d.DriverID 
LEFT JOIN DriverNum dn ON d.DriverID = dn.DriverID 
WHERE r.Rank = 1 
GROUP BY d.DriverID, d.lastname, d.firstname, dn.DNum, d.code 
HAVING COUNT(r.Rank) > 15 
ORDER BY Fastest_Laps DESC; 

--Question 4 = Subquery
Select R.RaceYear, Count(CS.RaceID), CS.ConstructorID, C.Name, Sum(CS.Points), Sum(CS.Wins) 
From RACES R  
Join Constructor_Standings CS On R.RaceID = CS.RaceID  
Join Constructors C on CS.ConstructorID = C.ConstructorID 
Group By R.RaceYear, CS.ConstructorID, C.Name 
Having C.Name = (Select Distinct C.Name, Max(CS.Points) 
From Constructors C  
Join Constructor_Standings CS On C.ConstructorID = CS.ConstructorID  
Join Races R On CS.RaceID = R.RaceID 
Where RaceRound = 10 
); 


--Question 5 = Simple Query
SELECT country, COUNT(*) AS circuit_count, TO_CHAR(ROUND(AVG(alt))) || ' m' AS avg_altitude
FROM circuits
WHERE alt IS NOT NULL
GROUP BY country
HAVING COUNT(*) >= 3 AND AVG(alt) >= 200
ORDER BY AVG(alt) DESC
FETCH FIRST 1 ROWS ONLY;





