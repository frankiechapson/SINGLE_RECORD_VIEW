create or replace TYPE T_SINGLE_RECORD AS 
OBJECT ( COLUMN_NAME         VARCHAR2 (   100 )
       , COL_VALUE           VARCHAR2 ( 32000 )
       );
/

create or replace TYPE T_SINGLE_RECORD_LIST AS TABLE OF T_SINGLE_RECORD;
/

create or replace function F_GET_SINGLE_RECORD_VIEW ( I_TABLE_NAME    in varchar2
                                                    , I_KEY           in varchar2
                                                    ) return T_SINGLE_RECORD_LIST PIPELINED is

/* *******************************************************************************************************************

    This function returns with the single record view of the row what is specified by the table name and primary key parameters.
    It can display only the following data types: 
    CHAR, DATE, FLOAT, NCHAR, NUMBER, NVARCHAR, VARCHAR, VARCHAR2, NVARCHAR2, TIMESTAMP

    Sample:
    -------
    select * from table( F_GET_SINGLE_RECORD_VIEW ( 'ANY_TABLE', 1 ) );


    History of changes
    yyyy.mm.dd | Version | Author         | Changes
    -----------+---------+----------------+-------------------------
    2018.01.16 |  1.0    | Ferenc Toth    | Created 

******************************************************************************************************************* */

    V_SINGLE_RECORD         T_SINGLE_RECORD := T_SINGLE_RECORD ( null, null );
    V_SQL                   varchar2( 3000 );
    V_PK_COLUMN             varchar2(  100 );

    function F_PK ( I_TABLE_NAME   in varchar2 ) return varchar2 deterministic is
    /*  very simple PK function */
        L_PK                 varchar2 (    40 );
    begin
        select COLUMN_NAME
          into L_PK
          from USER_CONSTRAINTS  UC
             , USER_CONS_COLUMNS DBC
         where UC.CONSTRAINT_TYPE  = 'P'
           and DBC.CONSTRAINT_NAME = UC.CONSTRAINT_NAME
           and DBC.TABLE_NAME      = I_TABLE_NAME;

        return L_PK;

    exception when others then
        return null;
    end;

begin

    V_PK_COLUMN := F_PK( upper( I_TABLE_NAME ) );

    for L_R in ( SELECT column_name, data_type
                   FROM user_tab_columns tc
                  WHERE table_name  = upper( I_TABLE_NAME )
                    AND (data_type IN ('CHAR','DATE','FLOAT','NCHAR','NUMBER','NVARCHAR','VARCHAR','VARCHAR2','NVARCHAR2') OR data_type LIKE 'TIMESTAMP%' )
                  ORDER BY column_name
                ) 
    loop
        V_SINGLE_RECORD.COLUMN_NAME := L_R.column_name;
        V_SQL := 'select ';

        IF (L_R.data_type = 'DATE') OR (SUBSTR(L_R.data_type,1,9)='TIMESTAMP') THEN
            V_SQL := V_SQL || 'TO_CHAR(';

        ELSIF L_R.data_type IN ('FLOAT','NUMBER') THEN
            V_SQL := V_SQL || 'TO_NUMBER(';

        END IF;

        V_SQL := V_SQL || L_R.column_name;

        IF L_R.data_type = 'DATE' THEN
            V_SQL := V_SQL || ',''YYYY.MM.DD HH24:MI:SS'')';

        ELSIF SUBSTR( L_R.data_type, -4 ) = 'ZONE' THEN
            V_SQL := V_SQL || ',''YYYY.MM.DD HH24:MI:SS.FF TZH:TZM'')';

        ELSIF SUBSTR( L_R.data_type, 1, 9 ) = 'TIMESTAMP' THEN
            V_SQL := V_SQL || ',''YYYY.MM.DD HH24:MI:SS.FF'')';

        ELSIF L_R.data_type IN ( 'FLOAT', 'NUMBER' ) THEN
            V_SQL := V_SQL || ')';

        END IF;

        V_SQL := V_SQL ||' from ' || I_TABLE_NAME ||' where '||V_PK_COLUMN||'='''||I_KEY||'''';
         
        execute immediate V_SQL into V_SINGLE_RECORD.COL_VALUE;
        PIPE ROW( V_SINGLE_RECORD );

    end loop;

    return;

end;
/