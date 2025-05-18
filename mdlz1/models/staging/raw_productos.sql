{{ config(
    materialized = 'table',
    schema = 'staging',
    tags = ['raw', 'master', 'productos']
) }}

SELECT * FROM read_parquet('{{ read_parquet_source("Productos") }}')