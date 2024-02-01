drop table ticket_detail cascade constraints; 
drop table ticket cascade constraints; 
drop table topic cascade constraints;
drop table support cascade constraints; 
drop table client cascade constraints; 

create table client 
(clid int, 
clname varchar(50),
clemail varchar(50),
primary key(clid));

insert into client values
(1, 'Ella','ella@gmail.com');

insert into client values
(2, 'Eric','eric@gmail.com');

insert into client values
(3, 'Olivia','olivia@gmail.com');

create table support 
(sid int, 
sname varchar(50),
semail varchar(50),
primary key (sid));

insert into support 
values(1,'Nancy','nancy@gmail.com');

insert into support 
values(2,'Ethan','ethan@gmail.com');

insert into support 
values(3,'Grace','grace@gmail.com');

insert into support 
values(4,'John','john@gmail.com');

create table topic 
(tid int, 
tname varchar(50),
ptid int, 
primary key (tid),
foreign key (ptid) references topic);

insert into topic 
values(1,'computing technology',null);

insert into topic 
values(2,'network connection',1);

insert into topic 
values(3, 'software',1);

insert into topic 
values(8, 'microsoft',3);

insert into topic 
values(4,'email',1);

insert into topic 
values(5,'academic',null);

insert into topic 
values(6, 'advising',5);

insert into topic 
values(7, 'registration',5);

create table ticket 
(tkid int, 
clid int, 
tid int, 
sid int, 
tktime timestamp,
rstime timestamp, 
status int, 
description varchar(100),
primary key (tkid),
foreign key (clid) references client, 
foreign key (tid) references topic, 
foreign key (sid) references support);

-- microsoft issue submitted by Ella, assigned 
insert into ticket values 
(1,1, 8, 1,timestamp '2022-10-1 10:05:00.00', null, 1,'I have trouble installing office on my office computer');

-- registration issue by Ella, resolved
insert into ticket values 
(2,1, 7,1, timestamp '2022-10-2 12:05:00.00', timestamp '2022-10-3 8:00:00.00', 1, 
'I have trouble access the registration page');

-- email issue by Eric, initialized  
insert into ticket values 
(3,2, 4,null, timestamp '2022-10-3 15:05:00.00', null,1, 'I forgot my email password');

-- network issue by Olivia, ongoing
insert into ticket values 
(4,3, 2,2, timestamp '2022-10-6 09:05:00.00',null, 1, 'I have connection issue at home');

insert into ticket values 
(5,3, 3, null, timestamp '2022-10-10 09:05:00.00',null, 1, 'I cannot log into blackboard');

create table ticket_detail 
(tdid int, 
tkid int, 
sid int, 
tdtime timestamp, 
content varchar(100),
primary key(tdid),
foreign key(tkid) references ticket,
foreign key(sid) references support);

--- ticket 1 assigned  
insert into ticket_detail 
values(1,1,1,timestamp '2022-10-1 11:05:00.00','ticket assigned to support staff');

-- ticket 1 
insert into ticket_detail 
values(2,1,1,timestamp '2022-10-1 11:10:00.00','instructions sent to client');

-- ticket 2 assigned
insert into ticket_detail 
values(3, 2, 1, timestamp '2022-10-2 14:00:00.00', 
'ticket assigned to support staff');

-- ticket 2  resolved. 
insert into ticket_detail 
values(4, 2, 1, timestamp '2022-10-3 8:00:00.00', 
'permission changed to allow client access registration page');

-- ticket 4, assigned. 
insert into ticket_detail 
values(5, 4, 2, timestamp '2022-10-6 10:00:00.00', 
'ticket assigned to support staff');

-- ticket 3, assigned. 
insert into ticket_detail 
values(6, 3, 3, timestamp '2022-10-3 16:05:00.00', 
'ticket assigned to support staff');

commit;

-- hw3 task 1

select s.sname
from support s, ticket t
where s.sid = t.sid and t.clid = 1 and t.tid = 8 and trunc(t.tktime) = date '2022-10-01'
group by s.sname;



--hw3 task 2

select s.sname, count(td.tkid)
from support s, ticket_detail td
where s.sid = td.sid 
group by s.sname;


--hw3 task 3

select clname
from client
where clid in (
    select clid
    from ticket
    group by clid
    having count (*) >= 2);


--hw3 task 4

select tname
from topic t
where ptid = tid and tname = 'computing technology'
group by tname;


--hw3 task 5

update ticket
set status = 2
where exists (
    select 1
    from ticket_detail td
    where ticket.tkid = td.tkid and td.content = 'ticket assigned to support staff');

select * from ticket;
