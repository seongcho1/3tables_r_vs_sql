/*
https://www.jdoodle.com/execute-sql-online/
https://sqliteonline.com/ 
*/

--0. 테이블 생성
drop table if exists exam;
create table exam(id int, student_id int, sub_id int, score int);
insert into exam values(1, 1, 1, 90);
insert into exam values(2, 2, 1, 88);
insert into exam values(3, 3, 3, 99);
insert into exam values(4, 1, 2, 91);
insert into exam values(5, 2, 2, 99);
insert into exam values(6, 3, 1, 100);
insert into exam values(7, 1, 1, 88);
insert into exam values(8, 2, 1, 86);
insert into exam values(9, 1, 3, 99);
drop table if exists student;
create table student(student_id int, name varchar(255));
insert into student values(1, "조");
insert into student values(2, "오");
insert into student values(3, "이");
drop table if exists subject;
create table subject(sub_id int, name varchar(255));
insert into subject values(1, "ft_printf");
insert into subject values(2, "minishell");
insert into subject values(3, "minirt");
/*
select * from exam;
select * from student;
select * from subject;
*/

--1. ‘2회 이상의 시험을 본’ 학생의 과목별 평균을 구하시오. 출력 형태는 이름, 과목명, 평균점수

--1.1 sub query를 이용한 로직 생성
select 
	student_id as '학생id', 
	sub_id as '과목id', 
	avg(score) as '평균점수'
from exam
where student_id in (
    select e2.student_id 
    from exam e2 
    group by e2.student_id 
    having count(e2.student_id) >= 2)
group by student_id, sub_id

--1.2 출력을 위한 조인
select 
	stu.name as '이름', 
	sub.name as '과목명', 
	avg(e.score) as '평균점수'
from exam e
join student stu
  on e.student_id = stu.student_id
join subject sub
  on e.sub_id = sub.sub_id
where e.student_id in (
    select e2.student_id 
    from exam e2 
    group by e2.student_id 
    having count(e2.student_id) >= 2)
group by e.student_id, e.sub_id

--2. ‘과목별로 2회 이상의 시험을 본’ 학생의 과목별 평균을 구하시오. 출력 형태는 이름, 과목명, 평균점수

--2.1 sub query를 이용한 로직 생성
select 
	student_id as '학생id', 
	sub_id as '과목id', 
	avg(score) as '평균점수'
from exam
where (student_id, sub_id) in (
    select e2.student_id, e2.sub_id
    from exam e2 
    group by e2.student_id, e2.sub_id 
    having count(e2.sub_id) >= 2)
group by student_id, sub_id

--2.2 출력을 위한 조인
select 
	stu.name as '이름', 
	sub.name as '과목명', 
	avg(e.score) as '평균점수'
from exam e
join student stu
  on e.student_id = stu.student_id
join subject sub
  on e.sub_id = sub.sub_id
where (e.student_id, e.sub_id) in (
    select e2.student_id, e2.sub_id
    from exam e2 
    group by e2.student_id, e2.sub_id 
    having count(e2.sub_id) >= 2)
group by e.student_id, e.sub_id

--2.3 중복 조건 쿼리 간결화
select 
	stu.name as '이름', 
	sub.name as '과목명', 
	avg(e.score) as '평균점수'
from exam e
join student stu
  on e.student_id = stu.student_id
join subject sub
  on e.sub_id = sub.sub_id
group by e.student_id, e.sub_id
having count(e.sub_id) >= 2

--https://lornajane.net/posts/2012/sql-joins-with-on-or-using