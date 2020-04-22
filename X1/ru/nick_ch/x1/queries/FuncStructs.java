/**
 * This software is free according GNU GENERAL PUBLIC LICENSE and
 * based on the XPg project, developed by KAZAK Solutions. 
 * Research and Development Group of Free Software, 
 * Santiago de Cali Republic of Colombia 2001.
 * Author:
 *          Gustavo Gonz¿lez <xtingray@kazak.com.co>.                   
 * ----------------------------------------------------------------------------
 * Now this software is developing for modern version of PostgreSQL.
 * Author: 
 *          Nick Chadaev <nick_ch58@list.ru>. Moscow, Russia. Single developer.
 *          New stage of developing had been started at 2009-06-16. 
 * ----------------------------------------------------------------------------
 *  CLASS FuncStructs @version 1.0   
 *  This class defines a helper functions to the QUERIES package.
 *  History:
 *          Date Created: 2013/06/02 
 */
 
package ru.nick_ch.x1.queries;

import ru.nick_ch.x1.idiom.Language;

public class FuncStructs {

	private static Language idiom ;
	
	public FuncStructs () {
		super ();
	}	
	public static void setIdiom ( Language p_idiom ) {
		idiom = p_idiom;
	}

	/**
	  * The method funcBasicStruct 
	  * There are definitions of the basic SQL instructions. 
	  */
	 public static SQLFuncBasic[] funcBasicStruct() {

	    SQLFuncBasic[] basicArray = new SQLFuncBasic[38];

	    String[][] descriptFunc = {
	    {"ALTER GROUP","ALTER GROUP name ADD USER username [, ... ]<br>ALTER GROUP name DROP USER username [, ... ]"},
	    {"ALTER TABLE","ALTER TABLE [ ONLY ] table [ * ]<br>ADD [ COLUMN ] column type [ column_constraint [ ... ] ]<br><br>ALTER TABLE [ ONLY ] table [ * ]<br>ALTER [ COLUMN ] column { SET DEFAULT value | DROP DEFAULT }<br><br>ALTER TABLE [ ONLY ] table [ * ]<br>ALTER [ COLUMN ] column SET STATISTICS integer<br><br>ALTER TABLE [ ONLY ] table [ * ]<br>RENAME [ COLUMN ] column TO newcolumn<br><br>ALTER TABLE table<br>RENAME TO new_table<br><br>ALTER TABLE table<br>ADD table_constraint_definition<br><br>ALTER TABLE [ ONLY ] table<br>DROP CONSTRAINT constraint { RESTRICT | CASCADE }<br><br>ALTER TABLE table<br>OWNER TO new_owner"},
	    {"ALTER USER","ALTER USER username [ [ WITH ] option [ ... ] ]<br>" + idiom.getWord("WHERE") + " <b>option</b> " + idiom.getWord("CAN") + "<br>[ ENCRYPTED | UNENCRYPTED ] PASSWORD 'password'<br>| CREATEDB | NOCREATEDB<br>| CREATEUSER | NOCREATEUSER<br>| VALID UNTIL 'abstime'"},
	    {"CREATE AGGREGATE","CREATE AGGREGATE name ( BASETYPE = input_data_type,<br>SFUNC = sfunc, STYPE = state_type<br>[ , FINALFUNC = ffunc ]<br>[ , INITCOND = initial_condition ] )"},
	    {"CONSTRAINT TRIGGER","CREATE CONSTRAINT TRIGGER name<br>AFTER events ON<br>relation constraint attributes<br>FOR EACH ROW EXECUTE PROCEDURE func '(' args ')'"},
	    {"CREATE DATABASE","CREATE DATABASE name<br>[ WITH [ LOCATION = 'dbpath' ]<br>[ TEMPLATE = template ]<br>[ ENCODING = encoding ] ]"},
	    {"CREATE FUNCTION","CREATE [ OR REPLACE ] FUNCTION name ( [ argtype [, ...] ] )<br>RETURNS rettype<br>AS 'definition'<br>LANGUAGE langname<br>[ WITH ( attribute [, ...] ) ]<br><br>CREATE [ OR REPLACE ] FUNCTION name ( [ argtype [, ...] ] )<br>RETURNS rettype<br>AS 'obj_file', 'link_symbol'<br>LANGUAGE langname<br>[ WITH ( attribute [, ...] ) ]"},
	    {"CREATE GROUP","CREATE GROUP name [ [ WITH ] option [ ... ] ]<br>" + idiom.getWord("WHERE") + " <b>option</b> " + idiom.getWord("CAN") + "<br>SYSID gid<br>| USER  username [, ...]"},
	    {"CREATE INDEX","CREATE [ UNIQUE ] INDEX index_name ON table<br>[ USING acc_method ] ( column [ ops_name ] [, ...] )<br>[ WHERE predicate ]<br><br>CREATE [ UNIQUE ] INDEX index_name ON table<br>[ USING acc_method ] ( func_name( column [, ... ]) [ ops_name ] )<br>[ WHERE predicate ]"},
	    {"CREATE LANGUAGE","CREATE [ TRUSTED ] [ PROCEDURAL ] LANGUAGE langname<br>HANDLER call_handler"},
	    {"CREATE OPERATOR","CREATE OPERATOR name ( PROCEDURE = func_name<br>[, LEFTARG = lefttype<br>] [, RIGHTARG = righttype ]<br>[, COMMUTATOR = com_op ] [, NEGATOR = neg_op ]<br>[, RESTRICT = res_proc ] [, JOIN = join_proc ]<br>[, HASHES ] [, SORT1 = left_sort_op ] [, SORT2 = right_sort_op ] )"},
	    {"CREATE RULE","CREATE RULE name AS ON event<br>TO object [ WHERE condition ]<br>DO [ INSTEAD ] action<br>" + idiom.getWord("WHERE") + " <b>action</b> " + idiom.getWord("CAN") + "<br>NOTHING<br>|<br>query<br>|<br>( query ; query ... )<br>|<br>[ query ; query ... ]"},
	    {"CREATE SEQUENCE","CREATE [ TEMPORARY | TEMP ] SEQUENCE seqname [ INCREMENT increment ]<br>[ MINVALUE minvalue ] [ MAXVALUE maxvalue ]<br>[ START start ] [ CACHE cache ] [ CYCLE ]"},
	    {"CREATE TABLE","&nbsp;&nbsp;CREATE [ [ LOCAL ] { TEMPORARY | TEMP } ] TABLE table_name (<br>&nbsp;&nbsp;{ column_name data_type [ DEFAULT default_expr ] [ column_constraint [, ...<br>&nbsp;&nbsp;] ]<br>&nbsp;&nbsp;    | table_constraint }  [, ... ]<br>&nbsp;&nbsp;)<br>&nbsp;&nbsp;[ INHERITS ( parent_table [, ... ] ) ]<br>&nbsp;&nbsp;[ WITH OIDS | WITHOUT OIDS ]<br><br>" + idiom.getWord("WHERE") + " <b>column_constraint</b> " + idiom.getWord("IS") + "<br>&nbsp;&nbsp;[ CONSTRAINT constraint_name ]<br>&nbsp;&nbsp;{ NOT NULL | NULL | UNIQUE | PRIMARY KEY |<br>&nbsp;&nbsp;CHECK (expression) |<br>&nbsp;&nbsp;REFERENCES reftable [ ( refcolumn ) ] [ MATCH FULL | MATCH PARTIAL ]<br>&nbsp;&nbsp;[ ON DELETE action ] [ ON UPDATE action ] }<br>&nbsp;&nbsp;[ DEFERRABLE | NOT DEFERRABLE ] [ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]<br><br>" + idiom.getWord("AND") + " <b>table_constraint</b> " + idiom.getWord("IS") + "<br>&nbsp;&nbsp;[ CONSTRAINT constraint_name ]<br>&nbsp;&nbsp;{ UNIQUE ( column_name [, ... ] ) |<br>&nbsp;&nbsp;PRIMARY KEY ( column_name [, ... ] ) |<br>&nbsp;&nbsp;CHECK ( expression ) |<br>&nbsp;&nbsp;FOREIGN KEY ( column_name [, ... ] ) REFERENCES reftable [ ( refcolumn [, ...<br>&nbsp;&nbsp;] ) ]<br>&nbsp;&nbsp;] ) ]<br>&nbsp;&nbsp;[ MATCH FULL | MATCH PARTIAL ] [ ON DELETE action ] [ ON UPDATE action ] }<br>&nbsp;&nbsp;[ DEFERRABLE | NOT DEFERRABLE ] [ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]"},
	    {"CREATE TABLE AS","CREATE [ [ LOCAL ] { TEMPORARY | TEMP } ] TABLE table_name [ (column_name [, ...] ) ]<br>AS query"},
	    {"CREATE TRIGGER","CREATE TRIGGER name { BEFORE | AFTER } { event [OR ...] }<br>ON table FOR EACH { ROW | STATEMENT }<br>EXECUTE PROCEDURE func ( arguments )"},
	    {"CREATE TYPE","CREATE TYPE typename ( INPUT = input_function, OUTPUT = output_function<br>, INTERNALLENGTH = { internallength | VARIABLE }<br>[ , EXTERNALLENGTH = { externallength | VARIABLE } ]<br>[ , DEFAULT = default ]<br>[ , ELEMENT = element ] [ , DELIMITER = delimiter ]<br>[ , SEND = send_function ] [ , RECEIVE = receive_function ]<br>[ , PASSEDBYVALUE ]<br>[ , ALIGNMENT = alignment ]<br>[ , ALIGNMENT = alignment ]<br>[ , STORAGE = storage ]<br>)"},
	    {"CREATE USER","CREATE USER username [ [ WITH ] option [ ... ] ]<br>" + idiom.getWord("WHERE") + " <b>option</b> " + idiom.getWord("CAN") + "<br>SYSID uid<br>| [ ENCRYPTED | UNENCRYPTED ] PASSWORD 'password'<br>| CREATEDB | NOCREATEDB<br>| CREATEUSER | NOCREATEUSER<br>| IN GROUP groupname [, ...]<br>| VALID UNTIL 'abstime'"},
	    {"CREATE VIEW","CREATE VIEW view [ ( column name list ) ] AS SELECT query"},
	    {"DELETE","DELETE FROM [ ONLY ] table [ WHERE condition ]"},
	    {"DROP AGGREGATE","DROP AGGREGATE name ( type )"},
	    {"DROP DATABASE","DROP DATABASE name"},
	    {"DROP FUNCTION","DROP FUNCTION name ( [ type [, ...] ] )"},
	    {"DROP GROUP","DROP GROUP name"},
	    {"DROP INDEX","DROP INDEX index_name [, ...]"},
	    {"DROP LANGUAGE","DROP [ PROCEDURAL ] LANGUAGE name"},
	    {"DROP OPERATOR","DROP OPERATOR id ( lefttype | NONE , righttype | NONE )"},
	    {"DROP RULE","DROP RULE name [, ...]"},
	    {"DROP SEQUENCE","DROP SEQUENCE name [, ...]"},
	    {"DROP TABLE","DROP TABLE name [, ...]"},
	    {"DROP TRIGGER","DROP TRIGGER name ON table"},
	    {"DROP TYPE","DROP TYPE typename [, ...]"},
	    {"DROP USER","DROP USER name"},
	    {"DROP VIEW","DROP VIEW name [, ...]"},
	    {"GRANT","GRANT { { SELECT | INSERT | UPDATE | DELETE | RULE | REFERENCES | TRIGGER } [,...] | ALL [ PRIVILEGES ] }<br>ON [ TABLE ] objectname [, ...]<br>TO { username | GROUP groupname | PUBLIC } [, ...]"},
	    {"REVOKE","REVOKE { { SELECT | INSERT | UPDATE | DELETE | RULE | REFERENCES | TRIGGER } [,...] | ALL [ PRIVILEGES ] }<br>ON [ TABLE ] object [, ...]<br>FROM { username | GROUP groupname | PUBLIC } [, ...]"},
	    {"SELECT","SELECT [ ALL | DISTINCT [ ON ( expression [, ...] ) ] ]<br>* | expression [ AS output_name ] [, ...]<br>[ FROM from_item [, ...] ]<br>[ WHERE condition ]<br>[ GROUP BY expression [, ...] ]<br>[ HAVING condition [, ...] ]<br>[ { UNION | INTERSECT | EXCEPT } [ ALL ] select ]<br>[ ORDER BY expression [ ASC | DESC | USING operator ] [, ...] ]<br>[ FOR UPDATE [ OF tablename [, ...] ] ]<br>[ LIMIT { count | ALL } ]<br>[ OFFSET start ]<br><br>" + idiom.getWord("WHERE") + " <b>from_item</b> " + idiom.getWord("CAN") + "<br><br>[ ONLY ] table_name [ * ]<br>[ [ AS ] alias [ ( column_alias_list ) ] ]<br>|<br>( select )<br>[ AS ] alias [ ( column_alias_list ) ]<br>|<br>from_item [ NATURAL ] join_type from_item<br>[ ON join_condition | USING ( join_column_list ) ]"},
	    {"UPDATE","UPDATE [ ONLY ] table SET col = expression [, ...]<br>[ FROM fromlist ]<br>[ WHERE condition ]"}
	    };

	    for (int i=0;i<38;i++) {
	         int k = i + 1;        
	         SQLFuncBasic func = new SQLFuncBasic(idiom,descriptFunc[i][0],idiom.getWord("FDB" + k),descriptFunc[i][1]);
	         basicArray[i] = func;
	      }

	    return basicArray;
	  }

	
	/**
	  * The method funcDataStruct
	  * There is definition of pgSQL functions.
	  */
	 public static SQLFunctionDataStruc[] funcDataStruct() {

	    SQLFunctionDataStruc[] funcList = new SQLFunctionDataStruc[100];
	    int[] funcSets = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
	                       1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1,
	                       1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 4,
	                       1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2,
	                       2, 1, 3, 4, 1, 1, 1, 1, 2, 1, 2, 1 };
	    
	    String[][] descriptFunc = { 
	    {"COALESCE(list)","non-NULL","COALESCE(rle, c2 + 5, 0)"},
	    {"NULLIF(input,value)","input or NULL","NULLIF(c1, 'N/A')"},
	    {"CASE WHEN expr THEN expr [...] ELSE expr END","expr","CASE WHEN c1 = 1 THEN 'match'<br>ELSE 'no match' END"},
	    {"abs(float8)","float8","abs(-17.4)"},
	    {"degrees(float8)","float8","degrees(0.5)"},
	    {"exp(float8)","float8","exp(2.0)"},
	    {"ln(float8)","float8","ln(2.0)"},
	    {"log(float8)","float8","log(2.0)"},
	    {"pi()","float8","pi()"},
	    {"pow(float8,float8)","float8","pow(2.0, 16.0)"},
	    {"radians(float8)","float8","radians(45.0)"},
	    {"round(float8)","float8","round(42.4)"},
	    {"sqrt(float8)","float8","sqrt(2.0)"},
	    {"cbrt(float8)","float8","cbrt(27.0)"},
	    {"trunc(float8)","float8","trunc(42.4)"},
	    {"float(int)","float8","float(2)"},
	    {"float4(int)","float4","float4(2)"},
	    {"integer(float)","int","integer(2.0)"},
	    {"acos(float8)","float8","acos(10.0)"},
	    {"asin(float8)","float8","asin(10.0)"},
	    {"atan(float8)","float8","atan(10.0)"},
	    {"atan2(float8,float8)","float8","atan3(10.0,20.0)"},
	    {"cos(float8)","float8","cos(0.4)"},
	    {"cot(float8)","float8","cot(20.0)"},
	    {"sin(float8)","float8","cos(0.4)"},
	    {"tan(float8)","float8","tan(0.4)"},
	    {"char_length(string)","int4","char_length('jose')"},
	    {"character_length(string)","int4","character_length('jose')"},
	    {"lower(string)","string","lower('TOM')"},
	    {"octet_length(string)","int4","octet_length('jose')"},
	    {"position(string in string)","int4","position('o' in 'Tom')"},
	    {"substring(string [from int] [for int])","string","substring('Tom' from 2 for 2)"},
	    {"trim([leading|trailing|both] [string] from string)","string","trim(both 'x' from 'xTomx')"},
	    {"upper(text)","text","upper('tom')"},
	    {"char(text)","char","char('text string')"},
	    {"char(varchar)","char","char(varchar 'varchar string')"},
	    {"initcap(text)","text","initcap('thomas')"},
	    {"lpad(text,int,text)","text","lpad('hi',4,'??')"},
	    {"ltrim(text,text)","text","ltrim('xxxxtrim','x')"},
	    {"textpos(text,text)","text","position('high','ig')"},
	    {"rpad(text,int,text)","text","rpad('hi',4,'x')"},
	    {"rtrim(text,text)","text","rtrim('trimxxxx','x')"},
	    {"substr(text,int[,int])","text","substr('hi there',3,5)"},
	    {"text(char)","text","text('char string')"},
	    {"text(varchar)","text","text(varchar 'varchar string')"},
	    {"translate(text,from,to)","text","translate('12345', '1', 'a')"},
	    {"varchar(char)","varchar","varchar('char string')"},
	    {"varchar(text)","varchar","varchar('text string')"},
	    {"abstime(timestamp)","abstime","abstime(timestamp 'now')"},
	    {"age(timestamp)","interval","age(timestamp '1957-06-13')"},
	    {"age(timestamp,timestamp)","interval","age('now', timestamp '1957-06-13')"},
	    {"date_part(text,timestamp)","float8","date_part('dow',timestamp 'now')"},
	    {"date_part(text,interval)","float8","date_part('hour',interval '4 hrs 3 mins')"},
	    {"date_trunc(text,timestamp)","timestamp","date_trunc('month',abstime 'now')"},
	    {"interval(reltime)","interval","interval(reltime '4 hours')"},
	    {"isfinite(timestamp)","bool","isfinite(timestamp 'now')"},
	    {"isfinite(interval)","bool","isfinite(interval '4 hrs')"},
	    {"reltime(interval)","reltime","reltime(interval '4 hrs')"},
	    {"timestamp(date)","timestamp","timestamp(date 'today')"},
	    {"timestamp(date,time)","timestamp","timestamp(timestamp '1998-02-24',time '23:07');"},
	    {"to_char(timestamp,text)","text","to_char(timestamp '1998-02-24','DD');"},
	    {"to_char(timestamp, text)","text","to_char(timestamp 'now','HH12:MI:SS')"},
	    {"to_char(int, text)","text","to_char(125, '999')"},
	    {"to_char(float, text)","text","to_char(125.8, '999D9')"},
	    {"to_char(numeric, text)","text","to_char(numeric '-125.8', '999D99S')"},
	    {"to_date(text, text)","date","to_date('05 Dec 2000', 'DD Mon YYYY')"},
	    {"to_timestamp(text, text)","date","to_timestamp('05 Dec 2000', 'DD Mon YYYY')"},
	    {"to_number(text, text)","numeric","to_number('12,454.8-', '99G999D9S')"},
	    {"area(object)","float8","area(box '((0,0),(1,1))')"},
	    {"box(box,box)","box","box(box '((0,0),(1,1))',box '((0.5,0.5),(2,2))')"},
	    {"center(object)","point","center(box '((0,0),(1,2))')"},
	    {"diameter(circle)","float8","diameter(circle '((0,0),2.0)')"},
	    {"height(box)","float8","height(box '((0,0),(1,1))')"},
	    {"isclosed(path)","bool","isclosed(path '((0,0),(1,1),(2,0))')"},
	    {"isopen(path)","bool","isopen(path '[(0,0),(1,1),(2,0)]')"},
	    {"length(object)","float8","length(path '((-1,0),(1,0))')"},
	    {"pclose(path)","path","popen(path '[(0,0),(1,1),(2,0)]')"},
	    {"npoint(path)","int4","npoints(path '[(0,0),(1,1),(2,0)]')"},
	    {"popen(path)","path","popen(path '((0,0),(1,1),(2,0))')"},
	    {"radius(circle)","float","radius(circle '((0,0),2.0)')"},
	    {"width(box)","float8","width(box '((0,0),(1,1))')"},
	    {"box(circle)","box","box('((0,0),2.0)'::circle)"},
	    {"box(point,point)","box","box('(0,0)'::point,'(1,1)'::point)"},
	    {"box(polygon)","box","box('((0,0),(1,1),(2,0))'::polygon)"},
	    {"circle(box)","box","circle('((0,0),(1,1))'::box)"},
	    {"circle(point,float8)","circle","circle('(0,0)'::point,2.0)"},
	    {"lseg(box)","lseg","lseg('((-1,0),(1,0))'::box)"},
	    {"lseg(point,point)","lseg","lseg('(-1,0)'::point,'(1,0)'::point)"},
	    {"path(polygon)","point","path('((0,0),(1,1),(2,0))'::polygon)"},
	    {"point(circle)","point","point('((0,0),2.0)'::circle)"},
	    {"point(lseg,lseg)","point","point('((-1,0),(1,0))'::lseg, '((-2,-2),(2,2))'::lseg)"},
	    {"point(polygon)","point","point('((0,0),(1,1),(2,0))'::polygon)"},
	    {"polygon(box)","polygon","polygon('((0,0),(1,1))'::box)"},
	    {"polygon(circle)","polygon","polygon('((0,0),2.0)'::circle)"},
	    {"polygon(npts,circle)","polygon","polygon(12,'((0,0),2.0)'::circle)"},
	    {"polygon(path)","polygon","polygon('((0,0),(1,1),(2,0))'::path)"},
	    {"isoldpath(path)","path","isoldpath('(1,3,0,0,1,1,2,0)'::path)"},
	    {"revertpoly(polygon)","polygon","revertpoly('((0,0),(1,1),(2,0))'::polygon)"},
	    {"upgradepath(path)","path","upgradepath('(1,3,0,0,1,1,2,0)'::path)"},
	    {"upgradepoly(polygon)","polygon","upgradepoly('(0,1,2,0,1,0)'::polygon)"},
	    {"broadcast(cidr)","text","broadcast('192.168.1.5/24')"},
	    {"broadcast(inet)","text","broadcast('192.168.1.5/24')"},
	    {"host(inet)","text","host('192.168.1.5/24')"},
	    {"masklen(cidr)","int4","masklen('192.168.1.5/24')"},
	    {"masklen(inet)","int4","masklen('192.168.1.5/24')"},
	    {"netmask(inet)","text","netmask('192.168.1.5/24')"}
	    };

	    int counter = 0;
	    int index = 0;
	    SQLFunctionDataStruc func;

	    for (int i=0;i<funcSets.length;i++) {

	      if (funcSets[i] == 1) {

	          int word = index + 1;
	          func = new SQLFunctionDataStruc(idiom,descriptFunc[index][0],descriptFunc[index][1],
	                                         idiom.getWord("FD" + word),descriptFunc[index][2]);    
	          index++;
	       }
	      else {

	            func = new SQLFunctionDataStruc(idiom);

	            for (int j=0;j<funcSets[i];j++) {

	                 int word = index + 1;
	                 func.addItem(descriptFunc[index][0],descriptFunc[index][1],idiom.getWord("FD" + word),
	                              descriptFunc[index][2]);
	                 index++;
	             }
	       }

	      funcList[counter] = func;
	      counter++;
	     }

	    return funcList;
	  } // funcDataStruct

} // End of class FuncStructs