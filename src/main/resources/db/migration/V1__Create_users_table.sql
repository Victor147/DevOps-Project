CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

create index idx_users_username on users (username);
create index idx_users_email on users (email);
create index idx_users_active on users (active);

insert into users (username, email, first_name, last_name, active, created_at, updated_at)
values ('admin', 'admin@example.com', 'Admin', 'Adminov', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
       ('john.doe', 'john.doe@example.com', 'John', 'Doe', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
       ('min.praz', 'min.praz@example.com', 'Mincho', 'Praznikov', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);