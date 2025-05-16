{{ config(
    materialized = 'table',
    schema = 'marts',
    tags = ['master', 'partitioned', 'productos'],
    indexes = [
        {'columns': ['CodigoProveedor', 'CodigoDistribuidor', 'CodigoProducto'], 'unique': true}
    ],
    post_hook = [
        "{{ write_partitioned_parquet('CodigoProveedor, CodigoDistribuidor') }}"
    ]
) }}


SELECT
    column00::VARCHAR AS "CodigoProveedor",
    column01::VARCHAR AS "CodigoDistribuidor",
    column02::VARCHAR AS "CodigoProducto",
    column03 AS "NombreProducto",
    column04 AS "EAN",
    column05 AS "DUN",
    column06 AS "FactorCaja",
    column07 AS "Peso",
    column08 AS "FlagBonificado",
    column09 AS "Afecto",
    column10 AS "PrecioCompra",
    column11 AS "PrecioSugerido",
    column12 AS "PrecioPromedio",
    column13 AS "FechaProceso",
    column14 AS "REF1",
    column15 AS "REF2",
    column16 AS "REF3",
    column17 AS "REF4",
    column18 AS "REF5",
    column19 AS "REF6",
    column20 AS "REF7",
    column21 AS "REF8",
    column22 AS "REF9",
    column23 AS "REF10"
FROM {{ ref('raw_productos') }}