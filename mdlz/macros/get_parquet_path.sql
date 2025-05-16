{% macro get_parquet_path(table_name) %}
    {% set uuid = env_var('UUID_PREFIX', '') %}
    {% set bucket = env_var('MINIO_BUCKET', 'sagebackup') %}
    {% set path = env_var('PARQUET_PATH', 'data/parquet') %}
    
    {% set file_path = 's3://' ~ bucket ~ '/' ~ path ~ '/_' ~ uuid ~ '.' ~ table_name ~ '.parquet' %}
    
    {{ return(file_path) }}
{% endmacro %}
