
-- Home task 1: Determine the number of challenges given by students
SELECT h.hacker_id, h.name, count(*) as challenges_created
FROM hackers as h
JOIN challenges as c
ON h.hacker_id = c.hacker_id
GROUP BY h.hacker_id, h.name
HAVING (count(c.challenge_id) ) in (
    select max(challenge_creat)
    from (
        select count(*) as challenge_creat
        from challenges
        group by hacker_id
    )x
    ) 
    OR count(c.challenge_id) in (
        select cha
        from (
            select count(*) as cha
            from challenges
            group by hacker_id
        )y
        group by cha
        having count(*) = 1
    )

ORDER BY challenges_created DESC, h.hacker_id ASC


-- Home task 2: Determine the total non-zero score of students who give challenges
select i.id as hacker_id, op.name as name, i.t_t as total_score  
FROM (
select id, SUM(score) as t_t
from (
SELECT h.hacker_id as id, h.challenge_id as c_id, max(h.score) as score
FROM submissions as h
GROUP BY h.hacker_id, h.challenge_id
) x
GROUP BY id
) as i
JOIN hackers as op
ON op.hacker_id = i.id
HAVING i.t_t > 0
ORDER BY total_score DESC, hacker_id ASC