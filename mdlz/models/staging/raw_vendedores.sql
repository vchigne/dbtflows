{{ config(
    materialized = 'table',
    schema = 'staging',
    tags = ['raw', 'master', 'vendedores']
) }}

SELECT * FROM read_parquet('{{ read_parquet_source("Vendedores") }}')