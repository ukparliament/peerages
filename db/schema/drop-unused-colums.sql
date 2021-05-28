alter table jurisdictions drop column code;

alter table law_lord_incumbencies drop column old_id;
alter table law_lord_incumbencies drop column jurisdiction_code;

alter table peerage_types drop column code;

alter table special_remainders drop column code;

alter table genders drop column letter;

alter table ranks drop column code;
alter table ranks drop column name;
alter table ranks drop column gender_char;

alter table letters_patent_times drop column time_code;

alter table announcement_types drop column code;

alter table announcements drop column announcement_type_code;
alter table announcements drop column number;
alter table announcements drop column gazette_issue_number;
alter table announcements drop column gazette_publication_date;
alter table announcements drop column gazette_page_number;

alter table people drop column gender_char;

alter table letters_patents drop column patent_time;
alter table letters_patents drop column administration_id;

alter table peerages drop column rank_name;
alter table peerages drop column peerage_type_name;
alter table peerages drop column sr;
alter table peerages drop column gender;
alter table peerages drop column forenames;
alter table peerages drop column surname;
alter table peerages drop column date_of_birth;
alter table peerages drop column date_of_death;
alter table peerages drop column previous_rank;
alter table peerages drop column previous_title;
alter table peerages drop column announced_on;
alter table peerages drop column announcement_type_code;
alter table peerages drop column patent_on;
alter table peerages drop column patent_time;
alter table peerages drop column introduced_on;
alter table peerages drop column administration_name;
alter table peerages drop column administration_id;
alter table peerages drop column announcement_id;