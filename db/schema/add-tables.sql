alter table peerages add column of_title boolean default false;
alter table subsidiary_titles add column of_title boolean default false;


drop table if exists kingdom_ranks;
drop table if exists rank_labels;
drop table if exists letters_patents;
drop table if exists letters_patent_times;
drop table if exists peerage_holdings;
drop table if exists people;
drop table if exists letters;
drop table if exists genders;
drop table if exists jurisdictions;
drop table if exists special_remainders;
drop table if exists kingdoms;
drop table if exists monarchs;

create table monarchs (
	id serial,
	name varchar(255) not null,
	primary key (id)
);
create table kingdoms (
	id serial,
	name varchar(255) not null,
	start_on date,
	end_on date,
	primary key (id)
);
create table genders (
	id serial,
	label varchar(10) not null,
	letter char(1) not null,
	primary key (id)
);
insert into genders (label, letter) values ('Male', 'm');
insert into genders (label, letter) values ('Female', 'f');
create table letters (
	id serial,
	letter varchar(100) not null,
	url_key char(1) not null,
	primary key (id)
);
create table people (
	id serial,
	forenames varchar(200) not null,
	surname varchar(100) not null,
	gender_char char(1) not null,
	date_of_birth date,
	date_of_death date,
	letter_id int,
	gender_id int,
	wikidata_id varchar(20),
	mnis_id varchar(20),
	rush_id varchar(20),
	constraint fk_letter foreign key (letter_id) references letters(id),
	constraint fk_gender foreign key (gender_id) references genders(id),
	primary key (id)
);
create table peerage_holdings (
	id serial,
	ordinality int not null,
	start_on date,
	end_on date,
	notes varchar(2000) null,
	person_id int not null,
	peerage_id int not null,
	introduced_on date default null,
	constraint fk_person foreign key (person_id) references people(id),
	constraint fk_peerage foreign key (peerage_id) references peerages(id),
	primary key (id)
);
create table rank_labels (
	id serial,
	label varchar(100) not null,
	rank_id int not null,
	gender_id int not null,
	constraint fk_rank foreign key (rank_id) references ranks(id),
	constraint fk_gender foreign key (gender_id) references genders(id),
	primary key (id)
);
create table jurisdictions (
	id serial,
	code varchar(10) not null,
	label varchar(100) not null,
	primary key (id)
);
create table special_remainders (
	id serial,
	code varchar(10) not null,
	description varchar(500) not null,
	primary key (id)
);
create table letters_patent_times (
	id serial,
	time_code char(1) not null,
	label varchar(20) not null,
	primary key (id)
);
create table letters_patents (
	id serial,
	patent_on date not null,
	patent_time char(1),
	previous_title varchar(255),
	previous_rank varchar(255),
	ordinality_on_date int,
	administration_id int,
	announcement_id int,
	letters_patent_time_id int,
	person_id int,
	kingdom_id int,
	constraint fk_administration foreign key (administration_id) references administrations(id),
	constraint fk_announcement foreign key (announcement_id) references announcements(id),
	constraint fk_person foreign key (person_id) references people(id),
	constraint fk_letters_patent_time foreign key (letters_patent_time_id) references letters_patent_times(id),
	constraint fk_kingdom foreign key (kingdom_id) references kingdoms(id),
	primary key (id)
);
create table kingdom_ranks (
	id serial,
	rank_id int not null,
	kingdom_id int not null,
	constraint fk_rank foreign key (rank_id) references ranks(id),
	constraint fk_kingdom foreign key (kingdom_id) references kingdoms(id),
	primary key (id)
);

alter table law_lords add column jurisdiction_id int;
alter table peerages add column special_remainder_id int;
alter table peerages add column letters_patent_id int;
alter table peerages add column kingdom_id int;
alter table subsidiary_titles add column letters_patent_id int;
alter table subsidiary_titles add column special_remainder_id int;
alter table peerages add column letter_id int;

