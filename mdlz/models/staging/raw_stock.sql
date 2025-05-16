{{ config(
    materialized = 'table',
    schema = 'staging',
    tags = ['raw', 'transactional', 'stock']
) }}

SELECT * FROM read_parquet('{{ read_parquet_source("Stock") }}')