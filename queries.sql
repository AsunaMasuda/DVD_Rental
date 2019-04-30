/* Query for Q1 on the slide (Question 3 of Question Set #1 on Udacity)*/
SELECT category_name,
       standard_quartile,
       COUNT(*)
FROM(SELECT c.name category_name,
            NTILE (4) OVER (ORDER BY f.rental_duration) AS standard_quartile
     FROM film f
     JOIN film_category fc
       ON f.film_id = fc.film_id
     JOIN category c
       ON c.category_id = fc.category_id) t1
WHERE category_name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY category_name, standard_quartile
ORDER BY 1,2,3 DESC

/* Query for Q2 on the slide (Question 1 of Question Set #2 on Udacity)*/
SELECT DATE_PART('month', r.rental_date) Rental_month,
       DATE_PART('year', r.rental_date) Rental_year,
       s.store_id Store_ID,
       COUNT(*) Count_rentals
FROM staff s
JOIN rental r
  ON s.staff_id = r.staff_id
GROUP BY Rental_month, Rental_year, Store_ID
ORDER BY Rental_month, Rental_year, Store_ID;

/* Query for Q3 on the slide (Question 2 of Question Set #2 on Udacity)*/
SELECT t1.pay_month pay_month,
       t1.full_name full_name,
       t1.pay_countpermon_month pay_countpermon_month,
       t1.amount_month amount_month
FROM (SELECT DATE_TRUNC('month', p.payment_date) pay_month,
       CONCAT(c.first_name, ' ', c.last_name) full_name,
       COUNT(c.customer_id) pay_countpermon_month,
       SUM(p.amount) amount_month
FROM payment p
JOIN customer c
  ON c.customer_id = p.customer_id
WHERE p.payment_date BETWEEN '2007-01-01' AND '2008-01-01'
GROUP BY 1,2
ORDER BY 2,1) t1
JOIN (SELECT DATE_TRUNC('year', p.payment_date) pay_year,
       CONCAT(c.first_name, ' ', c.last_name) full_name,
       COUNT(c.customer_id) pay_countpermon_year,
       SUM(p.amount) amount_year
FROM payment p
JOIN customer c
  ON c.customer_id = p.customer_id
WHERE p.payment_date BETWEEN '2007-01-01' AND '2008-01-01'
GROUP BY 1,2
ORDER BY 4 DESC
LIMIT 10) t2
ON t1.full_name = t2.full_name;

/* Query for Q4 on the slide (Question 3 of Question Set #2 on Udacity)*/
SELECT t1.pay_month pay_month,
       t1.full_name full_name,
       t1.amount_month amount_month,
       amount_month - LAG(t1.amount_month) OVER (ORDER BY t1.full_name, t1.pay_month) AS Difference
FROM(SELECT DATE_TRUNC('month', p.payment_date) pay_month,
       CONCAT(c.first_name, ' ', c.last_name) full_name,
       COUNT(c.customer_id) pay_countpermon_month,
       SUM(p.amount) amount_month
FROM payment p
JOIN customer c
  ON c.customer_id = p.customer_id
WHERE p.payment_date BETWEEN '2007-01-01' AND '2008-01-01'
GROUP BY 1,2
ORDER BY 2,1) t1
JOIN (SELECT DATE_TRUNC('year', p.payment_date) pay_year,
       CONCAT(c.first_name, ' ', c.last_name) full_name,
       COUNT(c.customer_id) pay_countpermon_year,
       SUM(p.amount) amount_year
FROM payment p
JOIN customer c
  ON c.customer_id = p.customer_id
WHERE p.payment_date BETWEEN '2007-01-01' AND '2008-01-01'
GROUP BY 1,2
ORDER BY 4 DESC
LIMIT 10) t2
ON t1.full_name = t2.full_name
ORDER BY 2;
