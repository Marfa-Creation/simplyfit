CREATE TABLE belajar (
  id integer primary key,
  item_order integer UNIQUE not NULL);
  
 insert into belajar (item_order) values (1);
 insert into belajar (item_order) values (2);
 insert into belajar (item_order) values (3);
 
 update belajar set item_order = item_order - 1;
 update belajar set item_order = item_order + 1;
 
 drop table belajar;
