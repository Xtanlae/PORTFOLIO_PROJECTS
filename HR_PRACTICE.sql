-- Create a join table
SELECT * FROM portfoliodb.absenteeism_at_work abs 
LEFT JOIN portfoliodb.compensation comp 
ON abs.ID = comp.ID
LEFT JOIN portfoliodb.reasons r 
ON abs.`Reason for absence` = r.Number;

-- SLECTING THE HEALTHIEST WORKERS
SELECT * FROM absenteeism_at_work
WHERE `Social drinker` = 0 AND `Social smoker` = 0 AND `Body mass index` between 18.5 AND 24.9
AND `Absenteeism time in hours` < (select avg(`Absenteeism time in hours`) from `absenteeism_at_work`)

-- COMPENSATION RATE INCREASE FOR NON-SMOKERS WITH ALLOCATED BUDGET OF $983,221
-- To check working hours per year = 5 days * 8 hrs daily * 52 weeks in a year = 2080
-- Aggregated working hours for all non smokers = 2080 x 686 = 1,426,880hours
-- Now sharing budeget allocation by working hours = 983,221/1426880 hrs = 0.69 increase/hour
-- Each employee gets 2080 * 0.69  = $1,435.2 yearly
SELECT count(*) as Nonsmokers from `absenteeism_at_work` where `Social smoker` = 0

-- Clearing up query and removing duplicate columns
SELECT abs.ID,
       r.Reason,
       abs.`Month of absence`,
       abs.`Body mass index` AS BMI,
       CASE 
           WHEN abs.`Body mass index` < 18.5 THEN 'Underweight'
           WHEN abs.`Body mass index` BETWEEN 18.5 AND 24.9 THEN 'Normal_weight'
           WHEN abs.`Body mass index` BETWEEN 25 AND 29.9 THEN 'Overweight'
           WHEN abs.`Body mass index` >= 30 THEN 'Obese'
           ELSE 'Not_classified'
       END AS BMI_CLASSIFICATIONS,
       CASE 
           WHEN abs.Seasons IN (12, 1, 2) THEN 'WINTER'
           WHEN abs.Seasons IN (3, 4, 5) THEN 'SPRING'
           WHEN abs.Seasons IN (6, 7, 8) THEN 'SUMMER'
           WHEN abs.Seasons IN (9, 10, 11) THEN 'AUTUMN'
           ELSE 'UNKNOWN'
       END AS SEASON_NAMES,
`Transportation expense`, 
`Distance from Residence to Work`,
Son,
Education,
`Disciplinary failure`,
`Distance from Residence to Work`,
`Day of the week`,
`Absenteeism time in hours`,
`Work load Average/day`,
`Social drinker`,
`Social smoker`,
Age
FROM portfoliodb.absenteeism_at_work abs 
LEFT JOIN portfoliodb.compensation comp ON abs.ID = comp.ID
LEFT JOIN portfoliodb.reasons r ON abs.`Reason for absence` = r.Number;



