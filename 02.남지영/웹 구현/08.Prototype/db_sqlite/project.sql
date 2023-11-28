create table anniversary (
       aid integer primary key autoincrement,
       aname text not null,
       adate text not null,
       isholiday int not null,
       uid text not null
);


create table schedule (
    sid integer primary key autoincrement,
    uid text not null,
    sdate text not null,
    title text not null,
    place text,
    start_time text,
    end_time text,
    is_important int default 0,
    memo text
);