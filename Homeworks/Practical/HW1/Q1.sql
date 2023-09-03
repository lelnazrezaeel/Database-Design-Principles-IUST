use Northwind

--1)
select Phone from dbo.Suppliers where ContactName like 'S%'

--2)
select FirstName, LastName from dbo.Employees where ReportsTo>3

--3)
select LastName, HireDate from dbo.Employees where Title!='Sales Representative'

--4)
select Address, ContactName from dbo.Customers as c where c.CustomerID in (
select c.CustomerID from [Order Details] as o full join Orders as ord on o.OrderID = ord.OrderID
full join Customers as cust on cust.CustomerID = ord.CustomerID group by cust.CustomerID
having SUM(o.UnitPrice*o.Quantity)>6000)

--5)
select SUM(Quantity) from dbo.[Order Details] as o full join Orders as ord on o.OrderID = ord.OrderID where ord.ShipCountry='France' 