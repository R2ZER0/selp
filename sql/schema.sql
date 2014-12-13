BEGIN;

CREATE TYPE mode_t AS ENUM ('osok', 'tosok', 'tdm', 'ctf');
CREATE TYPE weapon_t AS ENUM ('knife', 'pistol', 'carbine', 'shotgun', 'subgun',
                              'sniper', 'assault', 'grenade');
CREATE TYPE vec3_t AS (
        x       real,
        y       real,
        z       real
);

CREATE TABLE game (
        id              serial,
        server          varchar(255) not null,
        map             varchar(255) not null,
        mode            mode_t not null,
        starttime       timestamp with time zone not null,
        endtime         timestamp with time zone not null,
        PRIMARY KEY (id)
);

CREATE TABLE kill (
        id              serial,
        game            integer not null,
        killer          varchar(255) not null,
        victim          VARCHAR(255) not null,
        weapon          weapon_t not null,
        time            timestamp with time zone not null,
        gib             boolean not null,
        suicide         boolean not null,
        killer_pos      vec3_t not null,
        victim_pos      vec3_t not null,
        PRIMARY KEY(id),
        FOREIGN KEY(game) REFERENCES game(id)
);

COMMIT;
