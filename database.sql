drop table Politics cascade;
drop table Ship cascade;
drop table Base;
drop table System cascade;
drop table Fraction cascade;
drop type state_ship;
drop table Resourc; 
drop table Planet cascade;
drop table Users cascade;
drop table User_Fraction;
drop table State cascade;
drop table Type cascade;
drop table Groups cascade;
drop table Group_member;
drop table Task;
drop table Group_authority;
drop table Messages;
drop table Chat cascade;
drop table Chat_User;
drop table Voting cascade;
drop table Results cascade;
drop table Vote;
drop table Battle;
drop type type_Resources cascade;
drop type weather_type;
drop type name_group;

create type state_ship as enum('на ремонте','боевая готовность','создается','уничтожен','атакует','держит оборону');
create type type_Resources as enum('бензак','вода','газ','железо');
create type weather_type AS enum('холодная', 'горячая','нормальная');
create type name_group as enum('игрок');


create table Politics(
id integer Primary Key,
name_politics text
);

create table Fraction(
ID integer PRIMARY KEY,
name_Fraction varchar(15) not null,
id_politics integer not null REFERENCES Politics(id) on delete set null
);

create table System(
ID integer PRIMARY KEY,
name_System varchar(15)
);

create table Users(
ID integer PRIMARY KEY,
Game_name text,
login text,
password text,
level integer
);

create table Base(
ID integer PRIMARY KEY,
name_Base text,
ID_user integer REFERENCES Users(id) on delete set null,
ID_system integer REFERENCES System(id) on delete cascade,
location_base_x integer,
location_base_y integer
);

create table Ship(
ID integer PRIMARY KEY,
hp integer
	check(hp>=0),
state state_ship,
name_ship varchar(14),
ID_base integer default 0 REFERENCES Base(ID) on delete set default, 
ID_system integer REFERENCES System(id) on delete cascade,
ID_user integer REFERENCES Users(id) on delete cascade,
location_ship_x integer,
location_ship_y integer,
/*location_ship_z integer,*/
speed integer
	check((speed>=400 and speed<=1000) or speed=0),
protection integer
	check(protection>=0 and protection<=50)
);

create table Planet(
ID integer PRIMARY KEY,
name_Planet varchar(15),
ID_system integer REFERENCES System(ID) on delete cascade,
ID_fraction integer REFERENCES Fraction(ID) on delete set null,
location_planet_x integer,
location_planet_y integer,
weather weather_type,
ID_user integer REFERENCES Users(ID) on delete set null
);

create table Resourc(
ID integer PRIMARY KEY,
name_Resources text,
ID_planet integer REFERENCES Planet(id) on delete cascade,
type type_Resources,
count integer
);

create table User_Fraction(
id_fraction integer not null REFERENCES Ship(id) on delete cascade,
id_user integer not null REFERENCES Users(id) on delete cascade,
date date,
actual boolean,
PRIMARY KEY(id_fraction, id_user)
);

create table State(
id integer Primary Key,
name_state varchar(30)
);

create table Type(
id integer Primary Key,
name_state varchar(30)
);

create table Task(
id integer Primary Key,
name varchar(20),
description text,
access boolean not null,
id_type integer not null REFERENCES Type(id) on delete cascade,
id_state integer not null REFERENCES State(id) on delete cascade,
id_fraction integer not null REFERENCES Fraction(id) on delete cascade
);

create table Groups(
id integer Primary Key,
name name_group
);

create table Group_member(
id_group integer default 0 REFERENCES Groups(id) on delete set default,
id_user integer REFERENCES Users(ID) on delete cascade
);

create table Group_authority(
id integer Primary Key,
id_group integer REFERENCES Groups(id) on delete cascade,
name_authority text
);

create table Messages(
id integer Primary Key,
id_chat integer,
id_user integer REFERENCES Groups(id) on delete cascade,
message text
);

create table Chat(
id integer Primary Key,
name varchar(30),
date date
);

create table Chat_User(
id_user integer REFERENCES Users(id) on delete cascade,
if_chat integer REFERENCES Chat(id) on delete cascade
);

create table Voting(
id integer Primary Key,
id_chat integer REFERENCES Chat(id) on delete cascade,
message text
);

create table Results(
id integer Primary Key,
id_voting integer REFERENCES Voting(id) on delete cascade,
name varchar(15)
);


create table Vote(
id integer Primary Key,
id_user integer REFERENCES Users(id) on delete cascade,
id_result integer REFERENCES Results(id) on delete cascade
);

create table Battle(
id integer Primary Key,
name varchar(20),
id_system integer REFERENCES System(id) on delete cascade,
date date
);
