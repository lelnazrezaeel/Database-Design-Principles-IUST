use [Refah bank]

--1)
select * from dbo.final where Cars_Count < (select AVG(CAST(Cars_Count as float)) from dbo.final)

--2)
select Id, Gender from final where (Sood97 >= Sood96 and Sood96 >= Sood95)

--3)
select SenfName from final where CHARINDEX(N'ن', SenfName) <> 0

--4)
select Daramad_Total_Rials from final where (DATEDIFF(year, CAST(BirthDate as date), GETDATE())=50) and ProvinceName=N'تهران' 
order by Daramad_Total_Rials desc

--5)
select Id from final where (Gender = N'مرد' and CAST(Bardasht97 as bigint) >= 30000000) 