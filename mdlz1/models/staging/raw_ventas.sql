{{ config(
    materialized = 'table',
    schema = 'staging',
    tags = ['raw', 'transactional', 'ventas']
) }}

SELECT * FROM read_parquet('{{ read_parquet_source("Ventas") }}')