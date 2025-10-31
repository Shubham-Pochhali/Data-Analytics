-- select * from employee order by birthdate asc limit 1;
/* select count(*) as c, billing_country from invoice
group by billing_country order by c desc */
-- select distinct total from invoice order by total desc limit 3
/* select billing_city , sum(total) from invoice 
group by billing_city order by sum(total) desc limit 3 */
/*select c.customer_id, first_name,last_name, sum(total) from customer as c inner join 
invoice as i on c.customer_id=i.customer_id  group by c.customer_id
order by sum(total) desc limit 1;*/
/*
select distinct first_name, last_name, email from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in (
select track_id from track join genre on track.genre_id=genre.genre_id
where genre.name like 'Rock'
) order by email;
*/
/*
select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from track join album on album.album_id=track.album_id
join artist on album.artist_id=artist.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;
*/
/*
select name, milliseconds from track where milliseconds >
  (select avg(milliseconds) as avg_track_length from track)
order by milliseconds desc;
*/

/*
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;
*/

/*
WITH RECURSIVE
	sales_per_country AS(
		SELECT COUNT(*) AS purchases_per_genre, customer.country, genre.name, genre.genre_id
		FROM invoice_line
		JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
		JOIN customer ON customer.customer_id = invoice.customer_id
		JOIN track ON track.track_id = invoice_line.track_id
		JOIN genre ON genre.genre_id = track.genre_id
		GROUP BY 2,3,4
		ORDER BY 2
	),
	max_genre_per_country AS (SELECT MAX(purchases_per_genre) AS max_genre_number, country
		FROM sales_per_country
		GROUP BY 2
		ORDER BY 2)

SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;
*/




with customer_with_country as (
  select customer.customer_id, first_name, last_name, billing_country,sum(total)
  as total_spending,
  row_number() over (partition by billing_country order by sum(total) desc) as rowno
  from invoice join customer on customer.customer_id=invoice.customer_id
  group by 1,2,3,4
  order by 4 asc, 5 desc)
 select billing_Country, first_name, last_name, total_spending from customer_with_country where rowno<=1








