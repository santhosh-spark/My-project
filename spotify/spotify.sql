-- Active: 1755452454828@@127.0.0.1@3306@spotify
select * from spotify_tracks;

SELECT *
FROM spotify_tracks
WHERE popularity > 80 and duration_minutes > 4;

select  
CASE 
        WHEN popularity >= 80 THEN 'Very Popular'
        WHEN popularity >= 50 THEN 'Popular'
        ELSE 'Less Popular'
    END AS popularity_range,
count(*) as count
from spotify_tracks
GROUP BY popularity_range
order by count desc;
