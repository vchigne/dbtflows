{% macro read_parquet_source(table_name) %}
    {# Macro para leer archivos Parquet de origen #}
    {% set uuid = var('uuid_prefix') %}
    {% set bucket = var('source_bucket') %}
    {% set path = var('source_path') %}
    
    {% set file_path = 's3://' ~ bucket ~ '/' ~ path ~ '/_' ~ uuid ~ '.' ~ table_name ~ '.parquet' %}
    
    {{ return(file_path) }}
{% endmacro %}

{% macro write_partitioned_parquet(partition_by) %}
    {# Macro para escribir datos particionados como Parquet #}
    {% set bucket = var('target_bucket', 'sagebackup') %}
    {% set base_path = var('target_path', 'data/processed') %}
    {% set model_name = this.identifier %}
    
    {# Usar siempre un directorio con timestamp para evitar conflictos #}
    {% set timestamp = modules.datetime.datetime.now().strftime('%Y%m%d%H%M%S') %}
    {% set output_path = 's3://' ~ bucket ~ '/' ~ base_path ~ '/' ~ model_name ~ '_' ~ timestamp %}
    
    {# Escribir al directorio con timestamp #}
    {% set write_query %}
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
    
    {# Agregar mensaje informativo para consolidación #}
    {% do log("NOTA: Los datos más recientes están en el directorio con timestamp: " ~ output_path, info=True) %}
{% endmacro %}

{# Macro para eliminar recursivamente un directorio en S3 usando boto3 #}
{% macro s3_delete_directory(bucket, prefix) %}
    {% if execute %}
        {{ return(adapter.dispatch('s3_delete_directory')(bucket, prefix)) }}
    {% endif %}
{% endmacro %}

{% macro default__s3_delete_directory(bucket, prefix) %}
    {% if modules.sys.modules.get('boto3') %}
        {% set s3 = modules.boto3.resource('s3') %}
        {% set bucket_obj = s3.Bucket(bucket) %}
        {% set objects = bucket_obj.objects.filter(Prefix=prefix) %}
        {% for obj in objects %}
            {% do obj.delete() %}
        {% endfor %}
        {% do log("Directorio S3 eliminado: " ~ bucket ~ "/" ~ prefix, info=True) %}
    {% else %}
        {% do log("Boto3 no está disponible. No se pudo eliminar el directorio S3.", info=True) %}
    {% endif %}
{% endmacro %}