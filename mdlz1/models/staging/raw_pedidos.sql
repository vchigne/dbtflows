{{ config(
    materialized = 'table',
    schema = 'staging',
    tags = ['raw', 'transactional', 'pedidos']
) }}

SELECT * FROM read_parquet('{{ read_parquet_source("Pedidos") }}')