use hospital;
--	----------------------------------------------------------------easy--------------------------------------------------------------
--	1. Show first name, last name, and gender of patients whose gender is 'M'---
select first_name,last_name,gender from patients where gender='M';

--	2.Show first name and last name of patients who does not have allergies. (null)

select first_name,last_name from patients where allergies is  Null;

--	3.Show first name of patients that start with the letter 'C'
select first_name from patients where first_name LIKE 'C%';

--	4.Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
select first_name, last_name from patients where weight between 100 and 120;

/*-5.Update the patients table for the allergies column. If the patients allergies is null then replace it with 'NKA'---------*/
	
update patients set allergies = 'NKA' where allergies is null;

--	6. show first name and last name concatinated into one column to show their full name.
select 
concat(first_name,' ',last_name) as full_name
from patients;

--	7. Show first name, last name, and the full province name of each patient. Example: 'Ontario' instead of 'ON'
SELECT
first_name,
last_name,
province_name
FROM patients
join province_names on province_names.province_id = patients.province_id;

--	8.Show how many patients have a birth_date with 2010 as the birth year.
select
count(*) as Total_patients
from patients
where year(birth_date) =2010;


--	9.Show the first_name, last_name, and height of the patient with the greatest height.

select
first_name,
last_name,
max(height)
from patients;


--	10. Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
select
*
from patients
where patient_id in (1,45,534,879,1000);

--	11. Show the total number of admissions
SELECT COUNT(*) AS total_admissions
FROM admissions;

--	12. Show all the columns from admissions where the patient was admitted and discharged on the same day.
select
*
from admissions 
where admission_date = discharge_date;
--	13. Show the patient id and the total number of admissions for patient_id 579.
SELECT
  patient_id,
  COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579;

--	14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
select
distinct (city) as unique_cities
from patients
where province_id ='NS';


--	15.Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70
select
first_name,
last_name,
birth_date
from patients
where height > 160 and weight > 70;

--	16.Write a query to find list of patients first_name, last_name, and allergies where allergies are not null and are from the city of Hamilton.
SELECT
  first_name,
  last_name,
  allergies
FROM patients
WHERE
  city = 'Hamilton'
  and allergies is not null;
  
--	-------------------------------------------------------------------Medium-------------------------------------------------------
--	1. Show unique birth years from patients and order them by ascending.-----------

select
distinct year(birth_date) as birth_year
from patients
order by birth_year asc;

--	2.Show unique first names from the patients table which only occurs once in the list.
/* For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.*/

select first_name from patients
group by 1
having count(first_name) =1;

--	3.Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select
patient_id,
first_name
from patients
where first_name like 's____%s';
--	4.Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table.
SELECT
  x.patient_id,
  first_name,
  last_name
FROM patients x
  JOIN admissions y ON y.patient_id = x.patient_id
WHERE diagnosis = 'Dementia';

/* 5. Display every patients first_name. Order the list by the length of each name and then by alphabetically.*/
select first_name
from patients
order by len(first_name),
first_name;

--	6.Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
SELECT 
  (SELECT count(*) FROM patients WHERE gender='M') AS male_count, 
  (SELECT count(*) FROM patients WHERE gender='F') AS female_count;

/* --	7.Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.*/

SELECT
  first_name,
  last_name,
  allergies
FROM patients
WHERE
  allergies IN ('Penicillin', 'Morphine')
ORDER BY
  allergies,
  first_name,
  last_name;

--	8.Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
SELECT
  patient_id,
  diagnosis
FROM admissions
GROUP BY
  patient_id,
  diagnosis
HAVING COUNT(*) > 1;

/*--	9.Show the city and the total number of patients in the city.Order from most to least patients and then by city name ascending.*/
SELECT
  city,
  COUNT(*) AS num_patients
FROM patients
GROUP BY city
ORDER BY num_patients DESC, city asc;

--	10.Show first name, last name and role of every person that is either patient or doctor.The roles are either "Patient" or "Doctor"
SELECT first_name, last_name, 'Patient' as role FROM patients
    union all
select first_name, last_name, 'Doctor' from doctors;

--	11. Show all allergies ordered by popularity. Remove 'NKA' and NULL values from query.
SELECT
  allergies,
  COUNT(*) AS total_diagnosis
FROM patients
WHERE
  allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis DESC;

--	12.Show all patients first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE
  YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;
/*--13. We want to display each patients full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
EX: SMITH,jane */
SELECT
  CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS new_name_format
FROM patients
ORDER BY first_name DESC;
--	14.Show the province_id(s), sum of height; where the total sum of its patients height is greater than or equal to 7,000.
SELECT
  province_id,
  SUM(height) AS sum_height
FROM patients
GROUP BY province_id
HAVING sum_height >= 7000;
--	15 how the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
SELECT
  (MAX(weight) - MIN(weight)) AS weight_delta
FROM patients
WHERE last_name = 'Maroni';
--	16. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
SELECT
  DAY(admission_date) AS day_number,
  COUNT(*) AS number_of_admissions
FROM admissions
GROUP BY day_number
ORDER BY number_of_admissions DESC;
--	17.Show all columns for patient_id 542s most recent admission_date.
SELECT *
FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING
  admission_date = MAX(admission_date);
/* --	18.Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.*/

SELECT
  patient_id,
  attending_doctor_id,
  diagnosis
FROM admissions
WHERE
  (
    attending_doctor_id IN (1, 5, 19)
    AND patient_id % 2 != 0
  )
  OR 
  (
    attending_doctor_id LIKE '%2%'
    AND len(patient_id) = 3
  );
--	19.Show first_name, last_name, and the total number of admissions attended for each doctor.Every admission has been attended by a doctor.
SELECT
  first_name,
  last_name,
  count(*) as admissions_total
from admissions a
  join doctors ph on ph.doctor_id = a.attending_doctor_id
group by attending_doctor_id;
--	20.For each doctor, display their id, full name, and the first and last admission date they attended.
select
  doctor_id,
  first_name || ' ' || last_name as full_name,
  min(admission_date) as first_admission_date,
  max(admission_date) as last_admission_date
from admissions a
  join doctors ph on a.attending_doctor_id = ph.doctor_id
group by doctor_id;
--	21.For each doctor, display their id, full name, and the first and last admission date they attended.
select
  doctor_id,
  first_name || ' ' || last_name as full_name,
  min(admission_date) as first_admission_date,
  max(admission_date) as last_admission_date
from admissions a
  join doctors ph on a.attending_doctor_id = ph.doctor_id
group by doctor_id;
--	22.Display the total amount of patients for each province. Order by descending.
SELECT
  province_name,
  COUNT(*) as patient_count
FROM patients pa
  join province_names pr on pr.province_id = pa.province_id
group by pr.province_id
order by patient_count desc;
--	23.For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
SELECT
  CONCAT(patients.first_name, ' ', patients.last_name) as patient_name,
  diagnosis,
  CONCAT(doctors.first_name,' ',doctors.last_name) as doctor_name
FROM patients
  JOIN admissions ON admissions.patient_id = patients.patient_id
  JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id;
  
/*--	24.display the first name, last name and number of duplicate patients based on their first name and last name.
Ex: A patient with an identical name can be considered a duplicate.*/
select
  first_name,
  last_name,
  count(*) as num_of_duplicates
from patients
group by
  first_name,
  last_name
having count(*) > 1;

/*--25.Display patient's full name, height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals,
birth_date,gender non abbreviated.
Convert CM to feet by dividing by 30.48.Convert KG to pounds by multiplying by 2.205.*/
select
    concat(first_name, ' ', last_name) AS 'patient_name', 
    ROUND(height / 30.48, 1) as 'height "Feet"', 
    ROUND(weight * 2.205, 0) AS 'weight "Pounds"', birth_date,
CASE
	WHEN gender = 'M' THEN 'MALE' 
  ELSE 'FEMALE' 
END AS 'gender_type'
from patients;
--	26.Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)
SELECT
  patients.patient_id,
  first_name,
  last_name
from patients
where patients.patient_id not in (
    select admissions.patient_id
    from admissions
  );
  
--	-------------------------------------------------------------------Hard-----------------------------------------------------------------
/* 1.Show all of the patients grouped into weight groups.Show the total amount of patients in each weight group.
Order the list by the weight group decending.

For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.*/
SELECT
  COUNT(*) AS patients_in_group,
  FLOOR(weight / 10) * 10 AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

/* -- 2.Show patient_id, weight, height, isObese from the patients table.Display isObese as a boolean 0 or 1.Obese is defined as weight(kg)/(height(m)2) >= 30.
weight is in units kg.height is in units cm.*/
SELECT patient_id, weight, height, 
  (CASE 
      WHEN weight/(POWER(height/100.0,2)) >= 30 THEN
          1
      ELSE
          0
      END) AS isObese
FROM patients;

/*--	3.Show patient_id, first_name, last_name, and attending doctor's specialty.
Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'
Check patients, admissions, and doctors tables for required information.*/

SELECT
  p.patient_id,
  p.first_name AS patient_first_name,
  p.last_name AS patient_last_name,
  ph.specialty AS attending_doctor_specialty
FROM patients p
  JOIN admissions a ON a.patient_id = p.patient_id
  JOIN doctors ph ON ph.doctor_id = a.attending_doctor_id
WHERE
  ph.first_name = 'Lisa' and
  a.diagnosis = 'Epilepsy';
/* --	4.All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
The password must be the following, in order:
1. patient_id
2. the numerical length of patient's last_name
3. year of patient's birth_date*/

SELECT
  DISTINCT P.patient_id,
  CONCAT(
    P.patient_id,
    LEN(last_name),
    YEAR(birth_date)
  ) AS temp_password
FROM patients P
  JOIN admissions A ON A.patient_id = P.patient_id;

/* --	5.Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.
Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.*/

SELECT 
CASE WHEN patient_id % 2 = 0 Then 
    'Yes'
ELSE 
    'No' 
END as has_insurance,
SUM(CASE WHEN patient_id % 2 = 0 Then 
    10
ELSE 
    50 
END) as cost_after_insurance
FROM admissions 
GROUP BY has_insurance;

--	6 Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name
SELECT pr.province_name
FROM patients AS pa
  JOIN province_names AS pr ON pa.province_id = pr.province_id
GROUP BY pr.province_name
HAVING
  COUNT( CASE WHEN gender = 'M' THEN 1 END) > COUNT( CASE WHEN gender = 'F' THEN 1 END);
/* --	7.We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
- First_name contains an 'r' after the first two letters.
- Identifies their gender as 'F'
- Born in February, May, or December
- Their weight would be between 60kg and 80kg
- Their patient_id is an odd number
- They are from the city 'Kingston'*/

SELECT *
FROM patients
WHERE
  first_name LIKE '__r%'
  AND gender = 'F'
  AND MONTH(birth_date) IN (2, 5, 12)
  AND weight BETWEEN 60 AND 80
  AND patient_id % 2 = 1
  AND city = 'Kingston';
--	8 Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.
SELECT CONCAT(
    ROUND(
      (
        SELECT COUNT(*)
        FROM patients
        WHERE gender = 'M'
      ) / CAST(COUNT(*) as float),
      4
    ) * 100,
    '%'
  ) as percent_of_male_patients
FROM patients;
--	9.For each day display the total amount of admissions on that day. Display the amount changed from the previous date.
SELECT
 admission_date,
 count(admission_date) as admission_day,
 count(admission_date) - LAG(count(admission_date)) OVER(ORDER BY admission_date) AS admission_count_change 
FROM admissions
 group by admission_date;
 
--	10.Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.
select province_name
from province_names
order by
  (case when province_name = 'Ontario' then 0 else 1 end),
  province_name;






















