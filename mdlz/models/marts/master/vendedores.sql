{{ config(
    materialized = 'table',
    schema = 'marts',
    tags = ['master', 'partitioned', 'vendedores'],
    indexes = [
        {'columns': ['CodigoProveedor', 'CodigoDistribuidor', 'CodigoCliente','CodigoVendedor'], 'unique': true}
    ],
    post_hook = [
        "{{ write_partitioned_parquet('CodigoProveedor, CodigoDistribuidor') }}"
    ]
) }}

SELECT
    column00::VARCHAR AS "CodigoProveedor",
    column01::VARCHAR AS "CodigoDistribuidor",
    column02::VARCHAR AS "CodigoVendedor",
    column03 AS "NombreVendedor",
    column04 AS "TipoDocumento",
    column05 AS "DI",
    column06 AS "Canal",
    column07 AS "FechaIngreso",
    column08 AS "FechaActualización",
    column09 AS "FechaProceso",
    column10 AS "Exclusivo",
    column11::VARCHAR AS "CodigoSupervisor",
    column12 AS "NombreSupervisor",
    column13 AS "CRutaLogica",
    column14 AS "CLineaLogica",
    column15 AS "EstadoVendedor",
    column16 AS "ZonaVendedor",
    column17 AS "REF3",
    column18 AS "REF4",
    column19 AS "REF5",
    column20 AS "REF6",
    column21 AS "REF7",
    column22 AS "REF8",
    column23 AS "REF9",
    column24 AS "REF10"
FROM {{ ref('raw_vendedores') }}