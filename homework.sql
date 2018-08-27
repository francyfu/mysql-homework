use sakila;
select * from actor;

#1a. Display the first and last names of all actors from the table `actor`.

select first_name, last_name from actor;


# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
alter table actor
add column Actor_Name Varchar(30);
UPDATE actor 
SET Actor_Name = CONCAT(UPPER(first_name), ' ', UPPER(last_name));

#CREATE TRIGGER insert_trigger
#BEFORE INSERT ON actor
#FOR EACH ROW
#SET new.Actor_Name = CONCAT(new.(first_name), ' ', new.(last_name));

-- CREATE TRIGGER update_trigger
-- BEFORE UPDATE ON actor
-- FOR EACH ROW
-- SET new.Actor_Name = CONCAT(new.UPPER(first_name), ' ', new.UPPER(last_name));

DROP TRIGGER insert_trigger;
#DROP TRIGGER update_trigger; 

select * from actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name , last_name from actor
where first_name = "Joe";

#2b. Find all actors whose last name contain the letters `GEN`:
select * from actor 
where last_name LIKE '%GEN%'; 

# 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select * from actor 
where last_name LIKE '%LI%'
ORDER BY last_name ASC, first_name ASC;

# 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select * from country;

select country_id, country from country
where country = "Afghanistan" or country = "Bangladesh" or country = "China";

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

alter table actor
add column description BLOB(30);
select * from actor;

select * from actor;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor
DROP COLUMN description;

#4a. List the last names of actors, as well as how many actors have that last name.

select last_name, count(last_name) from actor group by last_name;

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name) from actor 
group by last_name
having count(last_name)>=2
order by count(last_name) ASC;

#4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `OUCHO WILLIAMS`. Write a query to fix the record.

UPDATE actor
SET first_name = "HARPO", Actor_Name = "HARPO WILLIAMS"
WHERE actor_id = 172;

select * from actor
where actor_id = 172;

#4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor
set first_name = "GROUCHO", Actor_Name = "GROUCHO WILLIAMS"
where first_name = "HARPO";

select * from actor
where first_name = "HARPO";

#5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

#6a. use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

select * from staff;
select * from address;
select first_name, last_name, address from staff s
join address a
where s.address_id = a.address_id;
#6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select * from staff;
select * from payment;

select staff_id, amount from payment 
group by staff_id;

select p.staff_id, first_name, last_name, sum(amount) from staff s
JOIN payment p
where s.staff_id = p.staff_id
group by p.staff_id;

#SELECT p.staff_id, s.first_name, s.last_name, SUM(p.amount)
#FROM payment p, staff s 
#where s.staff_id = p.staff_id
#GROUP BY p.staff_id;



#6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.-------??????????
select * from film_actor;
select * from film;

select ANY_VALUE(film.film_id), count(ANY_VALUE(film_actor.actor_id)) from film_actor
inner join film
on film_actor.film_id = film.film_id
group by film.film_id;

select * from film_actor
inner join film
on film_actor.film_id = film.film_id
;

#6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select * from inventory;
select * from film;

select count(inventory_id) from inventory
where film_id 
in (
select film_id from film
where title = "Hunchback Impossible");

#6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select * from payment;
select * from customer;


select p.customer_id, first_name, last_name, sum(amount) from payment p
join customer c
on c.customer_id = p.customer_id
group by p.customer_id
order by last_name asc;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

select * from film;
select * from language;

select title, language_id from film 
where title like "K%" OR title like "Q%"
and language_id= "1";

# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select * from film;
select * from film_actor;
select * from actor;

select Actor_Name from actor
where actor_id
in (
select actor_id from film_actor
where film_id 
in (
select film_id from film 
where title = "Alone Trip"
)
);

#  7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select * from customer;
select * from customer_email;
select * from address;
select * from city;
select * from country;

select customer_id, first_name, last_name, email from customer
where address_id
in (
select address_id from address
where city_id 
in (
select city_id from city
where country_id
in (
select country_id from country
where country = "Canada"
)
)
);

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select * from category;
select * from film_category;
select * from film;


select film_id, title from film
where film_id
in (
select film_id from film_category
where category_id
in (
select category_id from category
where name = "Family")
);

# 7e. Display the most frequently rented movies in descending order.
select * from film;
select * from inventory;
select * from rental;
select * from payment;

select f.film_id, f.title, count(r.rental_id) 
from rental r, film f, inventory i
where r.inventory_id = i.inventory_id and i.film_id = f.film_id 
group by r.inventory_id
order by count(rental_id) DESC
LIMIT 1;

#  7f. Write a query to display how much business, in dollars, each store brought in.alter

select * from store;
select * from payment;
select * from staff;
select * from rental;

#select sto.store_id, sum(p.amount)
#from payment p, store sto, staff sta, rental r
#where p.rental_id = r.rental_id and r.staff_id = sta.staff_id and sta.store_id = sto.store_id
#group by sto.store_id;


select sto.store_id, sum(p.amount)
from payment p, store sto, staff sta
where p.staff_id = sta.staff_id and sta.store_id = sto.store_id
group by sto.store_id;


#7g. Write a query to display for each store its store ID, city, and country.

select * from store;
select * from payment;
select * from staff;
select * from city;

select * from store;
select * from address;
select * from city;
select * from country;



select s.store_id, ci.city, co.country
from country co, city ci, address a, store s
where co.country_id = ci.country_id and ci.city_id = a.city_id and a.address_id = s.address_id;



# 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select * from category;
select * from film_category;
select * from inventory;
select * from payment;
select * from rental;


select SUM(p.amount) AS 'Gross Revenue',  c.name
FROM category c, film_category fc, inventory i, payment p, rental r
where c.category_id =fc.category_id and fc.film_id = i.film_id  and i.inventory_id = r.inventory_id and r.rental_id = p.rental_id 
GROUP BY fc.category_id
ORDER BY SUM(amount) DESC
LIMIT 5;


#* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.


CREATE VIEW TOP5_Genres_GrossRevenue AS SELECT 
SUM(p.amount) AS 'Gross Revenue',  c.name
FROM category c, film_category fc, inventory i, payment p, rental r
where c.category_id =fc.category_id and fc.film_id = i.film_id  and i.inventory_id = r.inventory_id and r.rental_id = p.rental_id 
GROUP BY fc.category_id
ORDER BY SUM(amount) DESC
LIMIT 5;

#8b. How would you display the view that you created in 8a?
SHOW CREATE VIEW TOP5_Genres_GrossRevenue;
#8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view TOP5_Genres_GrossRevenue;









