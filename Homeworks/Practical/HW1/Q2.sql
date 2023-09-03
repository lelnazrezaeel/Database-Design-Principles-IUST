use pubs

--1)
select title, type from titles where price>17 and price<21 and type!='mod_cook'

--2)
select au_id, phone, au_fname + au_lname as Full_Name from authors where city='Oakland'

--3)
select fname + lname as Full_Name from employee where hire_date = (select MIN(hire_date) from employee)

--4)
select title, pubdate from dbo.titles where (DATEDIFF(YEAR, pubdate, '2022-05-19 00:00:00.000') > 30)

--5)
select au_fname + au_lname as Full_Name, address, Count_Of_Titles from authors as a join ( 
select a.au_id, COUNT(s.title_id) as Count_Of_Titles from authors as a left join titleauthor as t on a.au_id=t.au_id 
left join sales as s on t.title_id=s.title_id group by a.au_id ) as c on a.au_id=c.au_id;