{{ config(
    materialized = 'table',
    schema = 'staging',
    tags = ['raw', 'master', 'rutas']
) }}

SELECT * FROM read_parquet('{{ read_parquet_source("Rutas") }}')