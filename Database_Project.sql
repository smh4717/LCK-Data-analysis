# LCK 2020 Spring

# 데이터
USE sqldb;sqldb

# 롤밴 데이터 테이블 생성
DROP TABLE if EXISTS lol2020springben;
CREATE TABLE lol2020springben
AS
SELECT id, Blue, BB1, BR1 FROM lol2020spring
UNION ALL
SELECT id, Blue, BB2, BR2 FROM lol2020spring
UNION ALL
SELECT id, Blue, BB3, BR3 FROM lol2020spring
UNION ALL
SELECT id, Blue, BB4, BR4 FROM lol2020spring
UNION ALL
SELECT id, Blue, BB5, BR5 FROM lol2020spring;

# 1 블루팀 T1 밴 챔피언, 밴 개수
SELECT
Blue AS '블루팀',
BB1 AS '챔피언',
COUNT(id) AS '밴 횟수'
FROM lol2020springben
WHERE Blue = 'T1'
GROUP BY BB1
ORDER BY COUNT(id) DESC, BB1 ASC;

# 2 LCK 밴 챔피언 순
SELECT
BB1 AS '챔피언',
COUNT(id) AS '픽 횟수'
FROM lol2020springben
GROUP BY BB1
ORDER BY COUNT(id) DESC, BB1 ASC;

# 롤픽 데이터
DROP TABLE if EXISTS lol2020springpick;
CREATE TABLE lol2020springpick
AS
SELECT id, Blue, BP1, BR1 FROM lol2020spring
UNION ALL
SELECT id, Blue, TRIM(SUBSTRING_INDEX(BP2_3, ',', 1)), BR2 FROM lol2020spring
UNION ALL
SELECT id, Blue, TRIM(SUBSTRING_INDEX(BP2_3, ',', -1)), BR3 FROM lol2020spring
UNION ALL
SELECT id, Blue, TRIM(SUBSTRING_INDEX(BP4_5, ',', 1)), BR4 FROM lol2020spring
UNION ALL
SELECT id, Blue, TRIM(SUBSTRING_INDEX(BP4_5, ',', -1)), BR5 FROM lol2020spring;

# 3 블루팀 T1 픽 챔피언, 라인, 픽 개수
SELECT
Blue AS '블루팀',
BP1 AS '챔피언',
BR1 AS '라인',
COUNT(id) AS '픽 횟수'
FROM lol2020springpick
WHERE Blue = 'T1'
GROUP BY BP1, BR1
ORDER BY COUNT(id) DESC;

# 4 LCK 픽 챔피언 순
SELECT
BP1 AS '챔피언',
COUNT(id) AS '픽 횟수'
FROM lol2020springpick
GROUP BY BP1
ORDER BY COUNT(id) DESC, BP1 ASC;

#시즌별 승률 데이터 생성
DROP TABLE if EXISTS lol2020springrate;
CREATE TABLE lol2020springrate
AS
SELECT
Blue,
SUM(if(Winner = '1', Winner, 0)) AS '승',
SUM(if(Winner = '2', Winner, 0))/2  AS '패',
ROUND((SUM(if(Winner = '1', Winner, 0)))/(COUNT(id)),2) AS '2020 봄 승률'
FROM lol2020spring
GROUP BY Blue
ORDER BY SUM(if(Winner = '1', Winner, 0)) DESC;

DROP TABLE if EXISTS lol2020summerrate;
CREATE TABLE lol2020summerrate
AS
SELECT
Blue,
SUM(if(Winner = '1', Winner, 0)) AS '승',
SUM(if(Winner = '2', Winner, 0))/2  AS '패',
ROUND((SUM(if(Winner = '1', Winner, 0)))/(COUNT(id)),2) AS '2020 여름 승률'
FROM lol2020summer
GROUP BY Blue
ORDER BY SUM(if(Winner = '1', Winner, 0)) DESC;

DROP TABLE if EXISTS lol2021springrate;
CREATE TABLE lol2021springrate
AS
SELECT
Blue,
SUM(if(Winner = '1', Winner, 0)) AS '승',
SUM(if(Winner = '2', Winner, 0))/2  AS '패',
ROUND((SUM(if(Winner = '1', Winner, 0)))/(COUNT(id)),2) AS '2021 봄 승률'
FROM lol2021spring
GROUP BY Blue
ORDER BY SUM(if(Winner = '1', Winner, 0)) DESC;

# 5 블루팀 시즌별 승률
SELECT *
FROM lol2020springrate a
LEFT OUTER JOIN lol2020summerrate b
ON a.Blue = b.Blue
LEFT OUTER JOIN lol2021springrate c
ON b.Blue = c.Blue
UNION
SELECT *
FROM lol2020springrate a
LEFT OUTER JOIN lol2020summerrate b
ON a.Blue = b.Blue
RIGHT OUTER JOIN lol2021springrate c
ON b.Blue = c.Blue
UNION
SELECT *
FROM lol2020springrate a
RIGHT OUTER JOIN lol2020summerrate b
ON a.Blue = b.Blue
LEFT OUTER JOIN lol2021springrate c
ON b.Blue = c.Blue;