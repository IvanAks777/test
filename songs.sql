--create_table_queries = [user_table_create, artist_table_create, song_table_create, time_table_create, songplay_table_create]


create table if not exists users (
	user_id int constraint user_pk primary key,
	first_name varchar,
	last_name varchar, 
	gender char(1),
	level varchar not null
);


create table if not exists artists (
	artist_id varchar constraint artist_pk primary key,
	name varchar,
	location varchar,
	latitude numeric(9, 6),
	longitude numeric(9,6)
);

create table if not exists songs (
	song_id varchar constraint song_pk primary key,
	title varchar,
	artist_id varchar references artists(artist_id),
	year int check (year>=0),
	duration numeric
	);


create table if not exists time (
	start_time timestamp constraint time_pk primary key,
	hour int not null check (hour>=0),
	day int not null check (day>=0),
	week int not null check(week >=0),
	month int not null check(month >= 0),
	year int not null check(year >= 0),
	weekday varchar not null
);



create table if not exists songplay (
	songplay_id serial constraint songplay_pk primary key,
	start_time timestamp references time (start_time),
	user_id int references users (user_id),
	level varchar,
	song_id varchar references songs (song_id),
	artist_id varchar references artists (artist_id),
	session_id int,
	location varchar,
	user_agent varchar
);




