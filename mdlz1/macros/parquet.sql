{% macro read_parquet_source(table_name) %}
    {% set uuid = var('uuid_prefix', '') %}
    {% set bucket = var('source_bucket', 'sagebackup') %}
    {% set path = var('source_path', 'data/parquet') %}

    {% set file_path = 's3://' ~ bucket ~ '/' ~ path ~ '/_' ~ uuid ~ '.' ~ table_name ~ '.parquet' %}
    {% do log("Parquet path: " ~ file_path, info=True) %}
    {{ return(file_path) }}
{% endmacro %}


-- macros/write_partitioned_parquet.sql
{% macro write_partitioned_parquet(partition_by) %}
    {# Macro que decidirá si escribir local o remotamente según configuración #}
    {% if var('write_to_s3', false) %}
        {{ write_s3_parquet(partition_by) }}
    {% else %}
        {{ write_local_parquet(partition_by) }}
    {% endif %}
{% endmacro %}

{% macro write_s3_parquet(partition_by) %}
    {% set bucket = var('target_bucket', env_var('OUTPUT_BUCKET', 'sagebackup')) %}
    {% set base_path = var('target_path', env_var('OUTPUT_PATH', 'data/processed')) %}
    {% set model_name = this.identifier %}
    {% set timestamp = modules.datetime.datetime.now().strftime('%Y%m%d%H%M%S') %}
    {% set output_path = 's3://' ~ bucket ~ '/' ~ base_path ~ '/' ~ model_name ~ '_' ~ timestamp %}

    {# -- Generamos el SQL de escritura en S3 -- #}
    {% set write_query %}
        COPY (SELECT * FROM {{ this }})
        TO '{{ output_path }}' (
            FORMAT PARQUET,
            PARTITION_BY ({{ partition_by }}),
            ROW_GROUP_SIZE 100000,
            COMPRESSION 'ZSTD'
        )
    {% endset %}

    {# -- DEBUG: Escribir el contenido del query generado -- #}
    {% do log("🪵 Generando COPY para modelo: " ~ model_name, info=True) %}
    {% do log("🪵 COPY SQL generado:", info=True) %}
    {% do log(write_query, info=True) %}
    {% do log("🪵 Output path: " ~ output_path, info=True) %}

    {% do run_query(write_query) %}
    {% do log("✅ Tabla " ~ model_name ~ " escrita como Parquet particionado en S3: " ~ output_path, info=True) %}
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