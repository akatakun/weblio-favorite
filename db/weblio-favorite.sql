create table dictionaries(
  id integer primary key autoincrement,
  category_id integer,
  kaki text not null,
  yomi text,
  body text,
  count integer not null default 0
);

create table categories(
  id integer primary key autoincrement,
   name text
);
