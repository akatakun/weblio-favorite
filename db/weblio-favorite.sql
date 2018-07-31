create table dictionaries(
  id integer primary key autoincrement,
  category_id integer,
  kaki text not null,
  yomi text,
  body text,
  count integer not null default 0
);
create index kaki_i on dictionaries(kaki);

create table categories(
  id integer primary key autoincrement,
  name text
);

create table dictionaries_tags(
  id integer primary key autoincrement,
  dictionary_id integer not null,
  tag_id integer not null
);
create unique index dictionary_id_tag_id_u on dictionaries_tags(dictionary_id, tag_id);

create table tags(
  id integer primary key autoincrement,
   name text
);
