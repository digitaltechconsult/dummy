set serveroutput on size 30000;
declare
   CURSOR c_table_info IS
    SELECT 
        table_name as table_name,
        column_name as column_name
    FROM DBA_TAB_COLUMNS
    WHERE DATA_TYPE LIKE '_LOB'
    AND OWNER LIKE '%SYSTEM%';
    
    r_table_info c_table_info%ROWTYPE;
    
    v_size_GB decimal(9,2);
    v_query VARCHAR(255);
BEGIN
    open c_table_info;
    LOOP
        fetch c_table_info into r_table_info;
        exit when c_table_info%notfound;
        v_size_GB := 0;
        v_query := 'select nvl(sum(dbms_lob.getlength(' || r_table_info.column_name || ')),0)/1024/1024/1024 as v_size_GB from ' || r_table_info.table_name;
        --dbms_output.put_line(v_query);
        execute immediate v_query into v_size_GB;
        dbms_output.put_line(r_table_info.table_name || CHR(9) || v_size_GB || 'GB');
    
    end loop;
    
END;
/
