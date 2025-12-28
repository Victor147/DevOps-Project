alter table users add column role varchar(20) default 'USER';

create index idx_users_role on users(role);

update users set role = 'ADMIN' where username = 'admin';
update users set role = 'USER' where username != 'admin';
