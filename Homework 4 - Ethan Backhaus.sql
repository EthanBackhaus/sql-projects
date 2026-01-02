--Ethan Backhaus Homework 4

--Question 1 = simple query
select playerid, teamid, to_char(sum(salary), '$999,999,999') as total_salary
from roster_t
group by playerid, teamid
having count(season) >= 10 and Avg(salary) >= 10000000
order by sum(salary)/count(season) desc
fetch first 3 rows only
;

--Question 2 = simple query
select
count(distinct country) as num_countries,
min(height) as min_height,
round(avg(height), 2) as avg_height,
max(height) as max_height,
round(min((SYSDATE - birth) / 365)) as youngest_player_alive
from PLAYER_T
where
hof = '1' and
death is null;

--Question 3 = join query
select son.LastName || ', ' || son.FirstName as son_name, college_t.College, son.Games as son_games,
father.Games as father_games, father.LastName || ', ' || father.FirstName as father_name
from PLAYER_T son
join PLAYER_T father on son.FatherID = father.PlayerID
left join COLLEGE_T on son.PlayerID = college_t.PlayerID
where son.Games >= 2 * father.Games
order by son.Games desc;

--Question 4 = compound query
select distinct t.TeamID, t.Team, t.League
from TEAM_T t
join ROSTER_T r on t.TeamID = r.TeamID
join PLAYER_T p on r.PlayerID = p.PlayerID
where p.FatherID is not null

minus

select distinct t.TeamID, t.Team, t.League
from TEAM_T t
join ROSTER_T r on t.TeamID = r.TeamID
join PLAYER_T p on r.PlayerID = p.PlayerID
where p.HOF = 1;

--Question 5 = subquery
select p.FirstName, p.LastName, p.Points, p.Games
from PLAYER_T p
where p.PlayerID in (
select PlayerID
from POSITION_T
where Position not in ('Point Guard', 'Shooting Guard')
group by PlayerID
having count(distinct Position) >= 2)
and p.PlayerID not in (
select PlayerID
from POSITION_T
where Position in ('Point Guard', 'Shooting Guard'));
