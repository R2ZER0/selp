BEGIN;

CREATE TYPE mode_t AS ENUM ('osok', 'tosok', 'tdm', 'ctf');
CREATE TYPE weapon_t AS ENUM ('knife', 'pistol', 'carbine', 'shotgun', 'subgun',
                              'sniper', 'assault', 'grenade');

CREATE TABLE game (
        id              serial,
        server          varchar(255) not null,
        map             varchar(255) not null,
        mode            mode_t not null,
        start_time       timestamp with time zone not null,
        end_time         timestamp with time zone not null,
        PRIMARY KEY (id)
);

CREATE TABLE kill (
        id              serial,
        game            integer not null,
        killer          varchar(255) not null,
        victim          VARCHAR(255) not null,
        weapon          weapon_t not null,
        time            integer not null,
        gib             boolean not null,
        suicide         boolean not null,
        killer_x        real,
        killer_y        real,
        killer_z        real,
        victim_x        real,
        victim_y        real,
        victim_z        real,
        PRIMARY KEY(id),
        FOREIGN KEY(game) REFERENCES game(id)
);

COMMIT;
