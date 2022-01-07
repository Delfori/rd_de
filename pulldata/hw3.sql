--1 вывести количество фильмов в каждой категории, отсортировать по убыванию
select category, count(*)
from film_list
group by category
order by count(*) desc;

--2 вывести 10 актеров, чьи фильмы большего всего арендовали, отсортировать по убыванию
select concat(actor.first_name,' ',actor.last_name) as Actor, sum(a.flm_cnt) as films_rented 
from film_actor fa
left join
actor on actor.actor_id = fa.actor_id 
left join
	(select i.film_id as filmid, count(*) as flm_cnt from rental r
	left join inventory i on i.inventory_id = r.inventory_id
	group by i.film_id) a on a.filmid = fa.film_id
group by Actor
order by films_rented desc
limit 10;

--3 вывести категорию фильмов, на которую потратили больше всего денег
select *
from sales_by_film_category
limit 1;

--4 вывести названия фильмов, которых нет в inventory. Написать запрос без использования оператора IN.
select f.*
from film f
left join inventory i
	on f.film_id = i.film_id 
where i.film_id is null


--5 вывести топ 3 актеров, которые больше всего появлялись в фильмах в категории “Children”. 
--  Если у нескольких актеров одинаковое кол-во фильмов, вывести всех.
select concat(a.first_name,' ',a.last_name), count(f.*)
from film f
	join film_actor fa ON fa.film_id = f.film_id
	join film_category fc on fa.film_id = f.film_id
	join actor a on a.actor_id = fa.actor_id 
	where fc.category_id = 3
group by concat(a.first_name,' ',a.last_name)
order by count(*) desc
limit 3;

--6 вывести города с количеством активных и неактивных клиентов (активный — customer.active = 1). 
--  Отсортировать по количеству неактивных клиентов по убыванию.

select c2.city, c.active, count(customer_id)
from customer c
	join address a on c.address_id = a.address_id
	join city c2 on c2.city_id = a.city_id
group by c2.city, c.active
order by c.active asc, count(customer_id) desc 

--7 вывести категорию фильмов, у которой самое большое кол-во часов суммарной аренды в городах (customer.address_id в этом city), и которые начинаются на букву “a”. 
-- То же самое сделать для городов в которых есть символ “-”. Написать все в одном запросе.

select c.name, sum(r.return_date - r.rental_date) as RentalTime
from rental r
	join inventory i on i.inventory_id = r.inventory_id
	join film f on i.film_id = f.film_id
	join film_category fc on fc.film_id = f.film_id 
	join category c on c.category_id = fc.category_id
	join customer cust on cust.customer_id = r.customer_id
	join address a on a.address_id = cust.address_id
	join city on city.city_id = a.city_id
	where city.city ilike 'a%' or city.city ilike '%-%'
group by c.name


