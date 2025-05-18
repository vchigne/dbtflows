{% macro get_parquet_path(table_name) %}
    {% set uuid = var('uuid_prefix', '') %}
    {% set bucket = var('source_bucket', 'sagebackup') %}
    {% set path = var('source_path', 'data/parquet') %}
    
    {% set file_path = 's3://' ~ bucket ~ '/' ~ path ~ '/_' ~ uuid ~ '.' ~ table_name ~ '.parquet' %}
    
    {{ return(file_path) }}
{% endmacro %}