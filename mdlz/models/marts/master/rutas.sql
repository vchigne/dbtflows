{{ config(
    materialized = 'table',
    schema = 'marts',
    tags = ['master', 'partitioned', 'rutas'],
    indexes = [
        {'columns': ['CodigoProveedor', 'CodigoDistribuidor', 'CodigoCliente','CodigoVendedor','FrecuenciaVisita'], 'unique': true}
    ],
    post_hook = [
        "{{ write_partitioned_parquet('CodigoProveedor, CodigoDistribuidor') }}"
    ]
) }}


SELECT
    column00::VARCHAR AS "CodigoProveedor",
    column01::VARCHAR AS "CodigoDistribuidor", 
    column02::VARCHAR AS "CodigoCliente",
    column03::VARCHAR AS "CodigoVendedor",
    column04 AS "FuerzaDeVenta",
    column05 AS "FrecuenciaVisita",
    column06 AS "Zona",
    column07 AS "Mesa",
    column08 AS "Ruta",
    column09 AS "Modulo",
    column10 AS "FechaProceso",
    column11 AS "ZonaVendedor",
    column12 AS "REF2",
    column13 AS "REF3",
    column14 AS "REF4",
    column15 AS "REF5",
    column16 AS "REF6",
    column17 AS "REF7",
    column18 AS "REF8",
    column19 AS "REF9",
    column20 AS "REF10"
FROM {{ ref('raw_rutas') }}
