-- macros/write_local_parquet.sql
{% macro write_local_parquet(partition_by) %}
    {# Macro para escribir datos particionados como Parquet localmente #}
    {% set local_path = var('target_local_path') %}
    {% set model_name = this.identifier %}
    
    {% set output_path = local_path ~ '/' ~ model_name %}
    
    {% set write_query %}
      
        
        -- Escribir datos particionados a disco local
        COPY (SELECT * FROM {{ this }})
        TO '{{ output_path }}' (
            FORMAT PARQUET,
            PARTITION_BY ({{ partition_by }}),
            ROW_GROUP_SIZE 100000,
            COMPRESSION 'ZSTD'
        )
    {% endset %}
    
    {% do run_query(write_query) %}
    {% do log("Tabla " ~ model_name ~ " escrita como Parquet particionado en: " ~ output_path, info=True) %}
{% endmacro %}