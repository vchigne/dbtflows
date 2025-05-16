{{ config(
    materialized = 'table',
    schema = 'staging',
    tags = ['raw', 'master', 'clientes']
) }}

SELECT * FROM read_parquet('{{ read_parquet_source("Clientes") }}')