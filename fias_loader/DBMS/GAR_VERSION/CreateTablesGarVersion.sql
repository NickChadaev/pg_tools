/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     13.10.2021 12:20:01                          */
/*==============================================================*/
SET search_path=gar_version;
------------------------------------------------------
-- 2021-10-12 Из каталога с файлами ГАР-ФИАС
--  Взято из Сети, регионы для автомобильных номеров.
--  Неопределён (82, '82', 'XXXX')
------------------------------------------------------
DROP TABLE IF EXISTS gar_version.rcl_region CASCADE;
CREATE TABLE IF NOT EXISTS gar_version.rcl_region
(
     id_region    integer      NOT NULL
    ,nm_region    varchar(250) NOT NULL
    ,kd_region    Char(2)      NOT NULL
    ,dt_data_del  timestamp without time zone
);

ALTER TABLE gar_version.rcl_region
    ADD CONSTRAINT rcl_region_pkey PRIMARY KEY (id_region);
    
ALTER TABLE gar_version.rcl_region    
    ADD CONSTRAINT ak1_rcl_region_nm_region UNIQUE (nm_region);

ALTER TABLE gar_version.rcl_region  OWNER to postgres;

COMMENT ON TABLE gar_version.rcl_region
    IS 'С_Справочник территорий обслуживания (Справочник регионов)';

COMMENT ON COLUMN gar_version.rcl_region.id_region
    IS 'ИД территории';

COMMENT ON COLUMN gar_version.rcl_region.nm_region
    IS 'Наименование территории';

COMMENT ON COLUMN gar_version.rcl_region.kd_region
    IS 'Код территории';

COMMENT ON COLUMN gar_version.rcl_region.dt_data_del
    IS 'Дата удаления';

INSERT INTO gar_version.rcl_region (id_region, kd_region, nm_region)
   VALUES (01, '01', 'Республика Адыгея')               
         ,(02, '02', 'Республика Башкортостан')
         ,(03, '03', 'Республика Бурятия')
         ,(04, '04', 'Республика Алтай')
         ,(05, '05', 'Республика Дагестан')
         ,(06, '06', 'Республика Ингушетия')
         ,(07, '07', 'Кабардино-Балкарская Республика')
         ,(08, '08', 'Республика Калмыкия')
         ,(09, '09', 'Карачаево-Черкесская Республика')
         ,(10, '10', 'Республика Карелия')
         ,(11, '11', 'Республика Коми')
         ,(12, '12', 'Республика Марий-Эл')
         ,(13, '13', 'Республика Мордовия')
         ,(14, '14', 'Республика Саха-Якутия')
         ,(15, '15', 'Республика Северная Осетия-Алания')
         ,(16, '16', 'Республика Татарстан')
         ,(17, '17', 'Республика Тува')
         ,(18, '18', 'Удмуртская Республика')
         ,(19, '19', 'Республика Хакасия')
         ,(20, '20', 'Чеченская Республика')
         ,(21, '21', 'Чувашская Республика')
         ,(22, '22', 'Алтайский край')
         ,(23, '23', 'Краснодарский край')
         ,(24, '24', 'Красноярский край')
         ,(25, '25', 'Приморский край')
         ,(26, '26', 'Ставропольский край')
         ,(27, '27', 'Хабаровский край')
         ,(28, '28', 'Амурская область')
         ,(29, '29', 'Архангельская область')
         ,(30, '30', 'Астраханская область')
         ,(31, '31', 'Белгородская область')
         ,(32, '32', 'Брянская область')
         ,(33, '33', 'Владимирская область')
         ,(34, '34', 'Волгоградская область')
         ,(35, '35', 'Вологодская область')
         ,(36, '36', 'Воронежская область')
         ,(37, '37', 'Ивановская область')
         ,(38, '38', 'Иркутская область')
         ,(39, '39', 'Калининградская область')
         ,(40, '40', 'Калужская область')
         ,(41, '41', 'Камчатский край')
         ,(42, '42', 'Кемеровская область')
         ,(43, '43', 'Кировская область')
         ,(44, '44', 'Костромская область')
         ,(45, '45', 'Курганская область')
         ,(46, '46', 'Курская область')
         ,(47, '47', 'Ленинградская область')
         ,(48, '48', 'Липецкая область')
         ,(49, '49', 'Магаданская область')
         ,(50, '50', 'Московская область')
         ,(51, '51', 'Мурманская область')
         ,(52, '52', 'Нижегородская область')
         ,(53, '53', 'Новгородская область')
         ,(54, '54', 'Новосибирская область')
         ,(55, '55', 'Омская область')
         ,(56, '56', 'Оренбургская область')
         ,(57, '57', 'Орловская область')
         ,(58, '58', 'Пензенская область')
         ,(59, '59', 'Пермский край')
         ,(60, '60', 'Псковская область')
         ,(61, '61', 'Ростовская область')
         ,(62, '62', 'Рязанская область')
         ,(63, '63', 'Самарская область')
         ,(64, '64', 'Саратовская область')
         ,(65, '65', 'Сахалинская область')
         ,(66, '66', 'Свердловская область')
         ,(67, '67', 'Смоленская область')
         ,(68, '68', 'Тамбовская область')
         ,(69, '69', 'Тверская область')
         ,(70, '70', 'Томская область')
         ,(71, '71', 'Тульская область')
         ,(72, '72', 'Тюменская область')
         ,(73, '73', 'Ульяновская область')
         ,(74, '74', 'Челябинская область')
         ,(75, '75', 'Забайкальский край')
         ,(76, '76', 'Ярославская область')
         ,(77, '77', 'Москва')
         ,(78, '78', 'Санкт-Петербург')
         ,(79, '79', 'Еврейская автономная область')
         ,(80, '80', 'бывший Агинский Бурятский автономный округ')
         ,(81, '81', 'бывший Коми-Пермяцкий автономный округ')
         ,(82, '82', 'XXXX')
         ,(83, '83', 'Ненецкий автономный округ')
         ,(84, '84', 'бывший Таймырский автономный округ')
         ,(85, '85', 'бывший Усть-Ордынский Бурятский автономный округ')
         ,(86, '86', 'Ханты-Мансийский автономный округ')
         ,(87, '87', 'Чукотский автономный округ')
         ,(88, '88', 'бывший Эвенкийский автономный округ')
         ,(89, '89', 'Ямало-Ненецкий автономный округ')
         ,(91, '91', 'Республика Крым')
         ,(92, '92', 'Севастополь с 2014 года')
         ,(99, '99', 'Москва с 1998 года')
;
/*==============================================================*/
/* Table: garfias_version                                    */
/*==============================================================*/
DROP TABLE IF EXISTS gar_version.garfias_version CASCADE;
CREATE SEQUENCE IF NOT EXISTS gar_version.garfias_version_id_seq INCREMENT 1 START 1;   

create table if not exists gar_version.garfias_version (
   ID_GARFIAS_VERSION   INT8 not null DEFAULT nextval('gar_version.garfias_version_id_seq'::regclass),
   NM_GARFIAS_VERSION   DATE        not null,
   KD_DOWNLOAD_TYPE     BOOL        not null default true,
   DT_DOWNLOAD          TIMESTAMP   not null DEFAULT now(),
   DT_CREATE            TIMESTAMP   null,
   ID_USER              TEXT        not null default session_user,
   arc_path             TEXT        not null
);

comment on table garfias_version is
'Версия ГАР ФИАС';

comment on column garfias_version.ID_GARFIAS_VERSION is
'ИД версии ГАР ФИАС';

comment on column garfias_version.NM_GARFIAS_VERSION is
'Номер версии ГАР ФИАС (Официальная дата версии ГАР ФИАС с сайта https://fias.nalog.ru.)';

comment on column garfias_version.KD_DOWNLOAD_TYPE is
'Тип загрузки: FALSE – Загрузка полной базы ГАР ФИАС, TRUE – Загрузка обновления базы ГАР ФИАС';

comment on column garfias_version.DT_DOWNLOAD is
'Дата загрузки с сайта ФИАС (Системная дата момента, когда архивный файл загружен с сайта https://fias.nalog.ru, распакован и данные размещены в буферном хранилище)';

comment on column garfias_version.DT_CREATE is
'Дата загрузки в Систему. (Системная дата момента окончания загрузки справочников и основных данных в Адресный справочник Системы).';

comment on column garfias_version.ID_USER is
'Идентификатор пользователя, запустившего процесс «Загрузка ГАР ФИАС».';

-- Непонятно сиё (ракрывают его программно).
comment on column garfias_version.arc_path is
'Ссылка на загружаемый архивный файл с базой ГАР ФИАС загружаемой версии';

alter table garfias_version
   add constraint PK_garfias_version primary key (ID_GARFIAS_VERSION);

--
--   2021-11-17 Уникальность версии
--
ALTER TABLE gar_version.garfias_version
   ADD CONSTRAINT ak1_garfias_version UNIQUE (nm_garfias_version);
   
/*==============================================================*/
/* Table: garfias_files_by_region                               */
/*==============================================================*/
drop table if exists gar_version.garfias_files_by_region cascade;
CREATE SEQUENCE IF NOT EXISTS gar_version.garfias_files_by_region_id_seq INCREMENT 1 START 1;  

create table if not exists gar_version.garfias_files_by_region (
   id_file_version     INT8 NOT NULL DEFAULT nextval('gar_version.garfias_files_by_region_id_seq'::regclass),
   id_garfias_version  INT8      not null,
   id_region           integer   null,
   file_path           text      not null
);

comment on table garfias_files_by_region is
'Версия ГАР ФИАС по регионам';

comment on column garfias_files_by_region.ID_GARFIAS_VERSION is
'ИД версии ГАР ФИАС';

comment on column garfias_files_by_region.id_region is
'ИД территории';

comment on column garfias_files_by_region.file_path is
'Ссылка на обрабатываемый XML-файл';

alter table garfias_files_by_region
   add constraint PK_garfias_files_by_region primary key (id_file_version);
--
-- 2021-11-09
--

ALTER TABLE garfias_files_by_region
   ADD CONSTRAINT ak1_garfias_files_by_region UNIQUE (file_path);   
--
--
--
alter table garfias_files_by_region
   add constraint fk_garfias_version_by_region__rcl_region foreign key (id_region)
      references gar_version.rcl_region (id_region)
      on delete cascade on update cascade;

alter table garfias_files_by_region
   add constraint fk_garf_reference__id__garffias_version_by_region foreign key (ID_GARFIAS_VERSION)
      references garfias_version (ID_GARFIAS_VERSION)
      on delete cascade on update cascade;

