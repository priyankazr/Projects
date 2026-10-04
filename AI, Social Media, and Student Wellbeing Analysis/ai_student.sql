select *
from practices.ai_student;

ALTER TABLE practices.ai_student
rename column `ï»¿Student_ID` to `Student_ID`;

#DATA CLEANING
SELECT Student_ID,
count(*) as duplicate_data
from practices.ai_student
group by Student_ID
having duplicate_data > 1;

select *
from practices.ai_student;

#checking null data
select count(*) as total_rows,
sum(case when student_id is null then 1 else 0 end) as missing_studentID,
sum(case when age is null then 1 else 0 end) as missing_age,
sum(case when gender is null then 1 else 0 end) as missing_gender,
sum(case when education_level is null then 1 else 0 end) as missing_education,
sum(case when Daily_Social_Media_Hours is null then 1 else 0 end) as missing_Daily_Social_Media_Hours,
sum(case when Daily_AI_Tool_Usage_Hours is null then 1 else 0 end) as missing_Daily_AI_Tool_Usage_Hours,
sum(case when sleep_hours is null then 1 else 0 end) as missing_sleephours,
sum(case when physical_activity_hours is null then 1 else 0 end) as missing_activity,
sum(case when mental_health_score is null then 1 else 0 end) as missing_mental,
sum(case when physical_health_score is null then 1 else 0 end) as missing_health
from practices.ai_student
group by Student_ID;

#checking unique value

select distinct Student_ID, count(*) as student_total
from practices.ai_student
group by student_id
having student_total > 1;

select *
from practices.ai_student;
