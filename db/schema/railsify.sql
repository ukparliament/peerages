/* table renames */
alter table "Administrations" rename to administrations;
alter table "Announcement" rename to announcement_types;
alter table "LawLords" rename to law_lord_incumbencies;
alter table "Lists" rename to announcements;
alter table "Peerages" rename to peerages;
alter table "Ranks" rename to ranks;
alter table "SubsidiaryTitles" rename to subsidiary_titles;
alter table "Types" rename to peerage_types;

/* peerages table */
alter table peerages rename column "IDNum" to id;
alter table peerages rename column "Title" to title;
alter table peerages rename column "Rank" to rank_name;
alter table peerages rename column "of" to territorial_designation;
alter table peerages rename column "Type" to peerage_type_name;
alter table peerages rename column "SR" to sr;
alter table peerages rename column "Sex" to gender;
alter table peerages rename column "Surname" to surname;
alter table peerages rename column "Oldtitle" to previous_title;
alter table peerages rename column "Oldrank" to previous_rank;
alter table peerages rename column "Forenames" to forenames;
alter table peerages rename column "Birthdate" to date_of_birth;
alter table peerages rename column "Announcement" to announced_on;
alter table peerages rename column "ListType" to announcement_type_code;
alter table peerages rename column "Patent" to patent_on;
alter table peerages rename column "Time" to patent_time;
alter table peerages rename column "Introduction" to introduced_on;
alter table peerages rename column "Died" to date_of_death;
alter table peerages rename column "Extinct" to extinct_on;
alter table peerages rename column "LastNo" to last_number;
alter table peerages rename column "Notes" to notes;
alter table peerages rename column "Alpha" to alpha;
alter table peerages rename column "Administration" to administration_name;
alter table peerages drop column "BirthdateDRB";
alter table peerages alter column patent_on type date;
alter table peerages alter column announced_on type date;
alter table peerages alter column date_of_birth type date;
alter table peerages alter column date_of_death type date;
alter table peerages alter column extinct_on type date;
alter table peerages alter column introduced_on type date;
alter table peerages add primary key (id);

/* administrations table */
alter table administrations rename column "Number" to number;
alter table administrations rename column "Prime Minister" to prime_minister;
alter table administrations rename column "StartDate" to start_date;
alter table administrations rename column "EndDate" to end_date;
alter table administrations rename column "ColourCode" to colour_code;
alter table administrations alter column start_date type date;
alter table administrations alter column end_date type date;
alter table administrations drop constraint "Administrations_pkey";
alter table administrations add column id serial;
alter table administrations add primary key (id);

/* peerages types table */
alter table peerage_types rename column "Type" to code;
alter table peerage_types rename column "Details" to name;
alter table peerage_types drop constraint "Types_pkey";
alter table peerage_types add column id serial;
alter table peerage_types add primary key (id);

/* ranks types table */
alter table ranks rename column "Rank" to code;
alter table ranks rename column "FullRank" to name;
alter table ranks rename column "Degree" to degree;
alter table ranks rename column "Sex" to gender_char;
alter table ranks add column "label" varchar(100);
alter table ranks drop constraint "Ranks_pkey";
alter table ranks add column id serial;
alter table ranks add primary key (id);

/* announcement types table */
alter table announcement_types rename column "Abbreviation" to code;
alter table announcement_types rename column "Announcement type" to name;
alter table announcement_types drop constraint "Announcement_pkey";
alter table announcement_types add column id serial;
alter table announcement_types add primary key (id);

/* announcements table */
alter table announcements rename column "Date" to announced_on;
alter table announcements alter column announced_on type date;
alter table announcements rename column "Type" to announcement_type_code;
alter table announcements rename column "Gazette" to in_gazette;
alter table announcements rename column "Gazette Issue No" to gazette_issue_number;
alter table announcements rename column "Gazette date" to gazette_publication_date;
alter table announcements rename column "Gazette page" to gazette_page_number;
alter table announcements rename column "Number" to number;
alter table announcements rename column "Details" to notes;
alter table announcements add column announcement_type_id int;
alter table announcements add column gazette_url varchar(255);
alter table announcements add constraint announcement_type foreign key (announcement_type_id) references announcement_types(id);
alter table announcements drop constraint "Lists_pkey";
alter table announcements add column id serial;
alter table announcements add primary key (id);

/* law lord incumbencies table */
alter table law_lord_incumbencies rename column "IDNum" to old_id;
alter table law_lord_incumbencies rename column "Appointed" to appointed_on;  
alter table law_lord_incumbencies alter column appointed_on type date;
alter table law_lord_incumbencies rename column "Retired" to end_on; 
alter table law_lord_incumbencies alter column end_on type date;
alter table law_lord_incumbencies rename column "Notes" to notes;
alter table law_lord_incumbencies rename column "Jurisdiction" to jurisdiction_code;
alter table law_lord_incumbencies rename column "OldOffice" to old_office;
alter table law_lord_incumbencies rename column "AnnuityFrom" to annuity_from;
alter table law_lord_incumbencies alter column annuity_from type date;
alter table law_lord_incumbencies rename column "AnnuityLGIssue" to annuity_london_gazette_issue;
alter table law_lord_incumbencies rename column "AnnuityLGPage" to annuity_london_gazette_page;
alter table law_lord_incumbencies rename column "AppointmentLGIssue" to appointment_london_gazette_issue;
alter table law_lord_incumbencies rename column "AppointmentLGPage" to appointment_london_gazette_page;
alter table law_lord_incumbencies drop constraint "LawLords_pkey";
alter table law_lord_incumbencies add column id serial;
alter table law_lord_incumbencies add primary key (id);

/* subsidiary titles table */
alter table subsidiary_titles rename column "IDNum" to id;
alter table subsidiary_titles rename column "Title" to title;
alter table subsidiary_titles rename column "Rank" to rank_code;
alter table subsidiary_titles rename column "of" to territorial_designation;
alter table subsidiary_titles rename column "Type" to subsidiary_title_name;
alter table subsidiary_titles rename column "SR" to sr;
alter table subsidiary_titles rename column "Extinct" to extinct_on;
alter table subsidiary_titles alter column extinct_on type date;
alter table subsidiary_titles rename column "LastNo" to last_number;
alter table subsidiary_titles rename column "Notes" to notes;
alter table subsidiary_titles rename column "Alpha" to alpha;
alter table subsidiary_titles rename column "ParentID" to peerage_id;
alter table subsidiary_titles drop column "Parent";
alter table subsidiary_titles drop column "ParentAlpha";
alter table subsidiary_titles rename column "Patent" to patent_on;
alter table subsidiary_titles alter column patent_on type date;
alter table subsidiary_titles rename column "Time" to patent_time;
alter table subsidiary_titles drop column "Surname";
alter table subsidiary_titles add constraint peerage foreign key (peerage_id) references peerages(id);
alter table subsidiary_titles add column rank_id int;
alter table subsidiary_titles add constraint rank foreign key (rank_id) references ranks(id);

/* foreign keys from peerages table */
alter table peerages add column administration_id int;
alter table peerages add constraint administration foreign key (administration_id) references administrations(id);
alter table peerages add column peerage_type_id int;
alter table peerages add constraint peerage_type foreign key (peerage_type_id) references peerage_types(id);
alter table peerages add column rank_id int;
alter table peerages add constraint rank foreign key (rank_id) references ranks(id);
alter table peerages add column announcement_id int;
alter table peerages add constraint announcement foreign key (announcement_id) references announcements(id);

/* foreign keys from law lords table */
alter table law_lord_incumbencies add column peerage_id int;
alter table law_lord_incumbencies add constraint peerage foreign key (peerage_id) references peerages(id);

/* new column on rank to identify ranks of type peerage */
/* added because 'prince' is not a peerage rank but we wish to retain the data, whilst hiding from the rank listing */
alter table ranks add column is_peerage_rank boolean default true;

/* new column on peerages to store a wikidata id */
alter table peerages add column wikidata_id varchar(20);

/* new column on announcements to store administration_id */
alter table announcements add column administration_id int;

/* Make the id on the peerages table into an auto incrementing serial */
create sequence peerages_id_seq minvalue 2996;
alter table peerages alter id set default nextval('peerages_id_seq');
alter sequence peerages_id_seq owned by peerages.id;






