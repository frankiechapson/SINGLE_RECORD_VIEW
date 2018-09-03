
# Single Record View

## Oracle PL/SQL function to display a single record



This function returns with the single record view of the row what is specified by the table name and primary key parameters.
It can display only the following data types: 

* CHAR
* DATE
* FLOAT
* NCHAR
* NUMBER
* NVARCHAR
* VARCHAR
* VARCHAR2
* NVARCHAR2
* TIMESTAMP with or without Timezone

... and certainly the TABLE must have a Primary Key!

Definition:

    F_GET_SINGLE_RECORD_VIEW ( I_TABLE_NAME    in varchar2
                             , I_KEY           in varchar2
                             ) return T_SINGLE_RECORD_LIST PIPELINED is

Sample:

    select * from table( F_GET_SINGLE_RECORD_VIEW ( 'ALL_TYPES', 1 ) );

Result:

    COLUMN_NAME                 COL_VALUE
    ------------                -------------------------------------------
    C_BIGDECIMAL                22
    C_CHAR                      árvíztűrőtükörfúrógépÁRVÍZTŰRŐTÜKÖRFÚRÓGÉP
    C_DATE                      2018.09.03 13:20:38
    C_DOUBLE                    11
    C_FLOAT                     1415
    C_INTEGER                   2
    C_NCHAR	                    árvíztűrőtükörfúrógépÁRVÍZTŰRŐTÜKÖRFÚRÓGÉP
    C_NUMBER                    3
    C_NVARCHAR2                 árvíztűrőtükörfúrógépÁRVÍZTŰRŐTÜKÖRFÚRÓGÉP
    C_REAL                      33,1415
    C_SMALLINT                  1
    C_TIMESTAMP                 2018.09.03 13:20:38.473000
    C_TIMESTAMP_TZ              2018.09.03 13:20:38.473000 +02:00
    C_VARCHAR                   árvíztűrőtükörfúrógépÁRVÍZTŰRŐTÜKÖRFÚRÓGÉP
    C_VARCHAR2                  árvíztűrőtükörfúrógépÁRVÍZTŰRŐTÜKÖRFÚRÓGÉP

Where ALL_TYPES is:

    CREATE TABLE all_types ( c_smallint              SMALLINT PRIMARY KEY,
                           , c_integer               INTEGER,
                           , c_real                  REAL,
                           , c_float                 FLOAT(126),
                           , c_double                DOUBLE PRECISION,
                           , c_bigdecimal            DECIMAL(13,0),
                           , c_number                NUMBER(3,2),
                           , c_varchar2              VARCHAR2(254),
                           , c_nvarchar2             NVARCHAR2(254),
                           , c_varchar               VARCHAR(254),
                           , c_char                  CHAR(254),
                           , c_nchar                 NCHAR(254),
                           , c_date                  DATE,
                           , c_timestamp             TIMESTAMP(6),
                           , c_timestamp_tz          TIMESTAMP(6) WITH TIME ZONE
                           );

    DECLARE
        V_ALL_TYPES    ALL_TYPES%rowtype;
    BEGIN
    
        V_ALL_TYPES.C_SMALLINT       := 1;
        V_ALL_TYPES.C_INTEGER        := 2;
        V_ALL_TYPES.C_REAL           := 33.1415;
        V_ALL_TYPES.C_FLOAT          := 1415;
        V_ALL_TYPES.C_DOUBLE         := 11;
        V_ALL_TYPES.C_BIGDECIMAL     := 22;
        V_ALL_TYPES.C_NUMBER         := 3;
        V_ALL_TYPES.C_VARCHAR2       := 'árvíztűrőtükörfúrógépÁRVÍZTŰRŐTÜKÖRFÚRÓGÉP';
        V_ALL_TYPES.C_NVARCHAR2      := 'árvíztűrőtükörfúrógépÁRVÍZTŰRŐTÜKÖRFÚRÓGÉP';
        V_ALL_TYPES.C_VARCHAR        := 'árvíztűrőtükörfúrógépÁRVÍZTŰRŐTÜKÖRFÚRÓGÉP';
        V_ALL_TYPES.C_CHAR           := 'árvíztűrőtükörfúrógépÁRVÍZTŰRŐTÜKÖRFÚRÓGÉP';
        V_ALL_TYPES.C_NCHAR          := 'árvíztűrőtükörfúrógépÁRVÍZTŰRŐTÜKÖRFÚRÓGÉP';
        V_ALL_TYPES.C_DATE           := sysdate;
        V_ALL_TYPES.C_TIMESTAMP      := systimestamp;
        V_ALL_TYPES.C_TIMESTAMP_TZ   := systimestamp;
        insert into ALL_TYPES values V_ALL_TYPES;
        commit;
    
    END;
    /
    
