# PostgreSQL

## 数据库操作

### 1、更新时间：

    创函数：
    CREATE OR REPLACE FUNCTION update_modified_column()
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.update_time = now();
        RETURN NEW;
    END;
    $$ language 'plpgsql';
    
    为每张表创建触发器，每一行更新都触发改触发器：
    CREATE TRIGGER update_time BEFORE UPDATE ON tb_scd_communication FOR EACH ROW EXECUTE PROCEDURE  update_modified_column();
    
    CREATE TRIGGER update_time BEFORE UPDATE ON tb_scd_control_gse FOR EACH ROW EXECUTE PROCEDURE  update_modified_column();

### 2、创建时间

    时间属性设置为timestamp，default设置为current_timestamp属性即可。

### 3、删除表

    truncate tb_scd_communication,tb_scd_control_gse,tb_scd_control_log,tb_scd_control_report,tb_scd_control_sv,tb_scd_data_type_da,tb_scd_data_type_do,
    tb_scd_data_type_enum,tb_scd_data_type_lnode,tb_scd_dataset,tb_scd_file_info,tb_scd_history,tb_scd_ied,tb_scd_ied_ap_authentication,tb_scd_ied_ln,
    tb_scd_ied_relation,tb_scd_mod,tb_scd_phys_conn,tb_scd_substation restart identity


