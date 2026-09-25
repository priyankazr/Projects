#Employee Attrition
select jobrole, department, educationfield
from practices.employee_attrition;

select jobrole, department
from practices.employee_attrition
where jobrole = 'laboratory technician';

select attrition, count(*) as total_employee
from practices.employee_attrition
group by attrition
order by attrition asc;

#Attrition Employee Percentage
select attrition, count(*) as employee_count, 
count(*) * 100/sum(count(*)) OVER() as AttritionEmployeePercentage
from practices.employee_attrition
group by attrition
order by employee_count DESC;

select *
from practices.employee_attrition;

select attrition, count(*) over(partition by attrition) as attrition_rate, department 
from practices.employee_attrition
order by attrition_rate DESC;

#Highest Attrition Department
select department,count(*) as attrition_quantity
from practices.employee_attrition
where attrition = 'Yes'
group by attrition, department
order by attrition_quantity DESC;

select JobRole, count(*) as attrition_quantity
from practices.employee_attrition
where attrition = 'yes'
group by Jobrole
order by attrition_quantity DESC;

#Attrition Rate Percentage based on Role
select JobRole, round(count(*) * 100/sum(count(*)) over(partition by attrition),2) 
as attrition_rate_percentage
from practices.employee_attrition
where attrition = 'yes'
group by Jobrole, attrition
order by attrition_rate_percentage DESC;

#Attrition rate based on gender
select gender, count(*) as employee_total, round(count(*)*100/sum(count(*)) over(partition by 
attrition),3) as attrition
from practices.employee_attrition
where attrition = 'yes'
group by gender, attrition
order by attrition DESC;

#Attrition based on marital status
select MaritalStatus, count(*) as attrition_rate
from practices.employee_attrition
where attrition = 'yes'
group by MaritalStatus 
order by attrition_rate desc;

#attrition rate based on edu category
select educationcategory, count(*) as attrition_rate
from practices.employee_attrition
where attrition = 'Yes'
group by educationcategory 
order by attrition_rate desc;

#Attrition rate based on age groups
select agegroup, count(*) as employee_total, 
SUM(CASE WHEN Attrition = 'Yes' then 1 else 0 END) as Employee_Left,
round(SUM(case when Attrition = 'Yes' then 1 else 0 END)*100/count(*),2) as attrition_rate
from practices.employee_attrition
group by agegroup
order by attrition_rate DESC;

#distance 
select 
CASE
	WHEN homedistance <= 10 then 'Near'
    WHEN homedistance between 11 and 20 then 'Moderate'
    WHEN homedistance > 20 then 'Far'
END as DistanceCategory,
count(*) as left_employee
from practices.employee_attrition
where attrition = 'yes'
group by DistanceCategory
order by left_employee desc;

#change columnn header
alter table practices.employee_attrition
rename column `DistanceFromHome(Km)` to `HomeDistance`;

#employee attrition level 
select
CASE
	WHEN joblevel = 1 then 'Entry'
    WHEN joblevel = 2 then 'Junior'
    WHEN joblevel = 3 then 'Mid'
    WHEN joblevel = 4 then 'Senior'
    WHEN joblevel = 5 then 'Management'
    END AS job_level_category,
count(*) as employee_total,
sum(CASE WHEN Attrition = 'Yes' then 1 else 0 end) as attrition_amount,
round(sum(CASE WHEN Attrition = 'Yes' then 1 else 0 end)*100/count(*), 2) 
as attrition_rate_percentage
from practices.employee_attrition
group by job_level_category
order by attrition_amount desc;

#income based on gender
select gender, round(avg(monthlyincome),2) as average_income
from practices.employee_attrition
group by gender;

#income based on gender and role
select jobrole, gender, round(avg(monthlyincome),2) as
income_average
from practices.employee_attrition
group by jobrole, gender
order by gender;

#income based on role
select jobrole, round(avg(monthlyincome),2) as avg_salary
from practices.employee_attrition
group by jobrole;

#Jobrole satisfaction based on maritalstatus and salary hike
select jobrole, jobsatiscategory, maritalstatus, 
round(avg(percentsalaryhike) over(partition by jobrole),3) as average_salary_hike, 
performanceclass
from practices.employee_attrition;

select jobrole, department, salaryhikeclassifications
from practices.employee_attrition
order by department;

select attrition, count(*) as employee_total
from practices.employee_attrition
group by attrition;

#overtime
select sum(case when overtime = 'Yes' then 1 else 0 end) as overtime
from practices.employee_attrition;

#education, income, performance rating
select education, round(avg(percentsalaryhike),2) as avg_salary_hike_percent
from practices.employee_attrition
group by education
order by avg_salary_hike_percent desc
;

#education and average performance
select education, round(avg(performancerating),2) as avg_performance_rating
from practices.employee_attrition
group by education
order by avg_performance_rating desc;

#job attrition factors
select round(avg(monthlyincome) over(partition by jobrole),3) as avg_monthly_income, 
round(avg(homedistance) over(partition by jobrole),1) as avg_distance, jobrole, educationfield, round(avg(hourlyrate) over(partition by jobrole),1) as avg_hour_rate
, jobsatiscategory, 
maritalstatus, overtime, salaryhikeclassifications, round(avg(percentsalaryhike) over(partition by jobrole),2) as avg_salary_hike, relationshipsatisfaction, 
round(avg(totalworkingyears) over(partition by jobrole),1) as avg_working_years
from practices.employee_attrition
order by avg_monthly_income DESC;

