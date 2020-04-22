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
 *  Interface Sql_db @version 1.0  
 *        Sql instructions for classes of ru.nick_ch.x1.db package. 
 *  History:
 *       Data created: 2009/09/28
 *                  2010-03-24 S_INDEX_PROP_1 was corrected.  Nick         
 *                  2013-06-09 Description of DB was added.  Nick
 */

package ru.nick_ch.x1.db;

public interface Sql_db {

    // Nick 2012/07/03 ---------------------------------------------------------
	String S_DATABASES_1 = "SELECT datname FROM pg_database WHERE ";
	String S_DATABASES_2 = "datname != 'template0' AND datname != 'template1' ";
	String S_DATABASES_3 = "ORDER by datname;";
	String S_DATABASES_4 = "AND datname != '";
	String S_DATABASES_5 = "datname = '";
	
    // String S_DRP_DBASE = "DROP DATABASE ";    
    //
    // Nick 2009-08-03 All SQL statements were placed here from PGConnection Class.
    // --------------------------------------------------------------------------------------------------
    String S_GET_USER_PERM = "SELECT usecreatedb,usesuper FROM pg_user WHERE usename = '" ;
    // --------------------------------------------------------------------------------------------------
    String S_GET_OWNER_DB = "SELECT usename FROM pg_user,pg_database " + 
                                 "WHERE datdba = usesysid AND datname = '";
    // --------------------------------------------------------------------------------------------------
    //    String S_GET_OWNER = "SELECT usename FROM pg_class,pg_user " + 
    //                              "WHERE usesysid=relowner AND relname = '";

 // 2011-10-30   
 String S_GET_OWNER_01 = "SELECT usename FROM pg_class c, pg_namespace n, pg_user u WHERE (u.usesysid=c.relowner)" +
                  "AND ( c.relnamespace = n.oid ) AND c.relname = '";
 String S_GET_OWNER_02 = "' AND ( n.nspname = '"; 
 String S_GET_END = "');";
    
   // --------------------------------------------------------------------------------------------------
    String S_GET_TABLE_PERM = "SELECT * FROM pg_class WHERE relname = '";
   // --------------------------------------------------------------------------------------------------
//     "SELECT a.attname, t.typname, a.attlen, a.attnotnull, a.atttypmod, a.atthasdef,  a.attnum, " + 
//     "( CASE WHEN d.description IS NULL THEN '' ELSE upper ( d.description ) END ) AS description " +
//     "FROM pg_attribute a " + 
//     "LEFT OUTER JOIN pg_description d ON (( a.attrelid = d.objoid ) AND ( d.objsubid = a.attnum ) ), " + 
//     "pg_type t, pg_class c WHERE ( c.relname = '" ;

    // 2011-10-30
    String S_GET_TABLE_STRUCT_1 = 
    "SELECT a.attname, t.typname, a.attlen, a.attnotnull, a.atttypmod, a.atthasdef,  a.attnum, " + 
    "( CASE WHEN d.description IS NULL THEN '' ELSE upper ( d.description ) END ) AS description " +
    "FROM pg_attribute a " + 
    "LEFT OUTER JOIN pg_description d ON (( a.attrelid = d.objoid ) AND ( d.objsubid = a.attnum ) ), " + 
    "pg_type t, pg_class c, pg_namespace n  WHERE ( c.relname = '" ;

    String S_GET_TABLE_STRUCT_2 = "') AND ( a.attnum > 0 ) AND " +
       "( a.attrelid = c.oid ) AND ( a. atttypid = t.oid ) AND ( c.relnamespace = n.oid )" +
       "AND ( n.nspname = '" ;
    
    String S_GET_TABLE_STRUCT_02 = "') ORDER BY a.attnum " ;

// 2011-10-30 Nick    
//    String S_GET_TABLE_STRUCT_3 = 
//      "SELECT a.attname, t.typname, a.attlen, a.attnotnull, a.atttypmod, a.atthasdef, a.attnum " +
//      "FROM pg_class c, pg_attribute a,pg_type t WHERE c.relname='"; 
//
//    String S_GET_TABLE_STRUCT_4 =
//        "' AND a.attnum > 0 AND a.attrelid = c.oid AND a. atttypid = t.oid ORDER BY a.attnum";
   // --------------------------------------------------------------------------------------------------
//    String S_ATTR_DEF_1 = "SELECT d.adsrc FROM pg_attrdef d, pg_class c WHERE c.relname='" ; 
//    String S_ATTR_DEF_2 = "' AND c.oid = d.adrelid AND d.adnum = " ;
    //
    //    Nick 2012-07-26
   String S_ATTR_DEF_1 = "SELECT d.adsrc FROM pg_attrdef d, pg_class c, pg_namespace n WHERE "; 
   String S_ATTR_DEF_2 = "( c.oid = d.adrelid ) AND ( c.relnamespace = n.oid ) AND ( c.relname = '";
   String S_ATTR_DEF_3 = "') AND ( n.nspname = '";
   String S_ATTR_DEF_4 = "') AND ( d.adnum = ";
    
   // ----------------------------------------------------------------------------------------------------------- 
   // 2011-12-03 Nick 
    String S_INDEX_TABLE_1 = "SELECT c2.relname FROM pg_class c, pg_class c2, pg_index i, pg_namespace n WHERE (n.nspname = '" ;
    String S_INDEX_TABLE_2 = "') AND ( c.relname = '" ;
    String S_INDEX_TABLE_3 = "') AND ( c.oid = i.indrelid ) AND ( i.indexrelid = c2.oid )" ;
    String S_INDEX_TABLE_4 = "AND ( c.relnamespace = n.oid ) ORDER BY c2.relname;";
    
   // -------------------------------------------------------------------------------------------------------
   // 2010-03-24 Nick S_INDEX_PROP_1 was corrected.
   // 
    String S_INDEX_PROP_1 = "SELECT pg_index.indexrelid, pg_index.indisunique, pg_index.indisprimary " + 
                                 "FROM pg_index, pg_class WHERE pg_class.relname='" ;
    String S_INDEX_PROP_2 = "' AND pg_class.oid = pg_index.indexrelid;" ;
   // --------------------------------------------------------------------------------------------------
   // 2011-12-03 Nick 
   String S_FOREING_KEY_1 = "SELECT p.tgargs FROM pg_trigger p,pg_class k WHERE k.relname='";
   String S_FOREING_KEY_2 = "' AND k.oid=p.tgrelid AND p.tgtype=21";
   // 
   //  2011-12-03 I don't understand this :(  Nick 
   //  String S_FOREING_KEY_1 = "SELECT DISTINCT p.tgconstrname FROM pg_trigger p,pg_class c WHERE c.relname='";
   //  String S_FOREING_KEY_2 = "' AND c.oid=p.tgrelid;";
    
    // --------------------------------------------------------------------------------------------------
    String S_GET_GROUP = "SELECT groname FROM pg_group ORDER BY groname";
   // --------------------------------------------------------------------------------------------------
    String S_GET_NUM_TABLES = "SELECT count(*) FROM pg_tables where tablename !~ '^pg_' " + 
                                   "AND tablename  !~ '^pga_' AND tablename  !~ '^sql_'" ;
   // --------------------------------------------------------------------------------------------------
    // Nick 2011-10-16
    String S_GET_TABLES_NAMES_1 =
      "SELECT tablename FROM pg_tables WHERE tablename !~ '^pg_' AND tablename  !~ '^pga_' " + 
       "AND tablename  !~ '^sql_'";

    String S_GET_TABLES_NAMES_2 = " AND tableowner = '";
    String S_GET_TABLES_NAMES_3 = " ORDER BY tablename;";
   // --------------------------------------------------------------------------------------------------
    String S_GET_GROUP_USER_0 = "SELECT array_dims(grolist) FROM pg_group WHERE groname = '";
    String S_GET_GROUP_USER_1 = "SELECT grolist[" ;
    String S_GET_GROUP_USER_2 = "] FROM pg_group WHERE groname = '" ;
    String S_GET_GROUP_USER_3 = "select usename from pg_user where usesysid='" ;
   // --------------------------------------------------------------------------------------------------
    String S_GET_USERS = "SELECT usename FROM pg_user ORDER BY usename" ;
   // --------------------------------------------------------------------------------------------------
    String S_GET_USER_INFO = 
                  "SELECT usecreatedb,usesuper,valuntil FROM pg_user WHERE usename = '";
   // --------------------------------------------------------------------------------------------------
    String S_GET_INDEX_FIELDS = 
         "SELECT pg_attribute.attname FROM pg_attribute WHERE pg_attribute.attrelid = " ;
   // --------------------------------------------------------------------------------------------------
    String S_SHEMANAME_T = "SELECT schemaname FROM pg_tables WHERE tablename = '";
    String S_SHEMANAME_V = "SELECT schemaname FROM pg_views WHERE viewname = '";
   // --------------------------------------------------------------------------------------------------
    String S_THE_END = "';";
    String S_THE_END_0 = "'";

    // 2011-11-13
    String S_GET_DESCR_01 = "SELECT CASE WHEN c.description IS NULL THEN ' ' ELSE c.description END AS description, "; 
    String S_GET_DESCR_02 = "b.relname AS relname FROM pg_class b "; 
    String S_GET_DESCR_03 = "LEFT OUTER JOIN pg_description c ON ( b.oid = c.objoid ) AND ( c.objsubid = 0 ) ";
    String S_GET_DESCR_04 = ", pg_namespace n WHERE ( b.relname = '"; 
    String S_GET_DESCR_05 = "' ) AND ( b.relkind = '"; 
    String S_GET_DESCR_15 = "' ) AND ( n.oid = b.relnamespace ) AND ( n.nspname = '";
    String S_GET_DESCR_06 = "' ); ";
    
    //  Nick 2009-10-02
    // String S_GET_DESCR_01 = "SELECT CASE WHEN c.description IS NULL THEN ' ' ELSE c.description END AS description, " ;
    // String S_GET_DESCR_02 = "b.relname AS relname FROM pg_class b " ;
    // String S_GET_DESCR_03 = "LEFT OUTER JOIN pg_description c ON ( b.relfilenode = c.objoid ) AND ( c.objsubid = 0 ) " ;
    // String S_GET_DESCR_04 = "WHERE ( b.relname = '";
    // String S_GET_DESCR_05 = "' ) AND ( b.relkind = '";
    // String S_GET_DESCR_06 = "' )"; 
    //
    String S_GET_XRD_LINK_01 = "SELECT count(*) FROM v_xrd WHERE ( table_name = '";
    String S_GET_XRD_LINK_02 = "' )";
    // 2010-01-12
    String S_GET_XRD_LINK_11 = "SELECT count(*) FROM pg_views WHERE viewname = 'v_xrd' ";
    // 2012-06-29 Nick
    String cPUBLIC = "public";
    
    String S_SCHEMAS = "SELECT n.nspname AS schemaname FROM pg_namespace n " + 
    "WHERE (n.nspname !~ '^pg_') AND ( n.nspname <> 'information_schema' ) " +
    "AND ( n.nspname <> 'public' ); ";

    // 2011-12-03 Nick 
    String S_SCHEMAS_2 = "SELECT n.nspname AS schemaname FROM pg_namespace n " +
      "WHERE (n.nspname !~ '^pg_') AND (n.nspname <> 'information_schema');";

    // Nick 2011-10-20
    String S_TABLES_01 = "SELECT a.tablename AS table_name, CASE WHEN d.description IS NULL THEN ' ' ELSE d.description END AS description, ";  
    String S_TABLES_11 = "a.schemaname AS schema_name FROM pg_tables a LEFT OUTER JOIN pg_namespace b ON ( a.schemaname = b.nspname ) ";
    String S_TABLES_02 = "LEFT OUTER JOIN pg_class c ON ( a.tablename = c.relname ) AND ( c.relnamespace = b.oid ) AND ( c.relkind = 'r' ) "; 
    // String S_TABLES_03 = "LEFT OUTER JOIN pg_description d ON ( c.relfilenode = d.objoid ) AND ( d.objsubid = 0 ) ";
    
    // 2011-12-03 Nick
    String S_TABLES_03 = "LEFT OUTER JOIN pg_description d ON ( c.oid = d.objoid ) AND ( d.objsubid = 0 ) ";    
    
    String S_TABLES_04 = "WHERE ( a.schemaname = '"; 
    String S_TABLES_05 = "') ORDER BY table_name";
    
 // Nick 2011-10-20
    String S_VIEWS_01 = "SELECT a.viewname AS view_name, CASE WHEN d.description IS NULL THEN ' ' ELSE d.description END AS description, a.schemaname AS schema_name ";  
    String S_VIEWS_11 = "FROM pg_views a LEFT OUTER JOIN pg_namespace b ON ( a.schemaname = b.nspname ) ";
    String S_VIEWS_02 = "LEFT OUTER JOIN pg_class c ON ( a.viewname = c.relname ) AND ( c.relnamespace = b.oid ) AND ( c.relkind = 'v' ) "; 

    // 2011-12-03 Nick
    // String S_VIEWS_03 = "LEFT OUTER JOIN pg_description d ON ( c.relfilenode = d.objoid ) AND ( d.objsubid = 0 ) ";
    String S_VIEWS_03 = "LEFT OUTER JOIN pg_description d ON ( c.oid = d.objoid ) AND ( d.objsubid = 0 ) ";

    String S_VIEWS_04 = "WHERE ( a.schemaname = '";
    String S_VIEWS_05 = "') ORDER BY view_name";
 
    String cNEXTVAL = "nextval";
    //  2012-07-14 Nick
    // There are some twins of constant definition from Sql_menu interface.
    String cEMPdb   = "";
    String cLBRdb   = "(";
    String cRBRdb   = ")";
    String cCOMMAdb = ",";
    // 2012-10-28 Nick
    String cDP2db = "::";
    // 2012-11-04 Nick
    String cDQUdb = "\"" ;
    // 2013-06-09 Nick
    String cSPACE = " ";
    
	// For attention !!!
	// Nick 2009-12-10

    String S_DATABASES_21 = "SELECT CASE WHEN b.description IS NULL THEN '-' ELSE b.description END AS description "; 
    String S_DATABASES_22 = "FROM pg_database a LEFT OUTER JOIN pg_description b ON ( a.oid = b.objoid ) WHERE ( datname = '";
    String S_DATABASES_23 = "' )";
    
    // 2013-06-09 Nick 
    String S_DATABASES_211 = "SELECT CASE WHEN b.description IS NULL THEN '-' ELSE b.description END AS description "; 
    String S_DATABASES_221 = "FROM pg_database a LEFT OUTER JOIN pg_shdescription b ON ( a.oid = b.objoid ) WHERE ( datname = '";
}
