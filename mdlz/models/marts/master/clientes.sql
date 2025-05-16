{{ config(
    materialized = 'table',
    schema = 'marts',
    tags = ['master', 'partitioned', 'clientes'],
    indexes = [
        {'columns': ['CodigoProveedor', 'CodigoDistribuidor', 'CodigoCliente'], 'unique': true}
    ],
    post_hook = [
        "{{ write_partitioned_parquet('CodigoProveedor, CodigoDistribuidor') }}"
    ]
) }}

SELECT
    column00::VARCHAR AS "CodigoProveedor",
    column01::VARCHAR AS "CodigoDistribuidor",
    column02::VARCHAR AS "CodigoCliente",
    column03 AS "NombreCliente",
    column04 AS "TipoDocumento",
    column05 AS "DNI",
    column06 AS "Dirección",
    column07 AS "Mercado",
    column08 AS "Módulo",
    column09 AS "Canal",
    column10 AS "GiroNegocio",
    column11 AS "SubGiroNegocio",
    column12 AS "Ubigeo",
    column13 AS "Distrito",
    column14 AS "Estatus",
    column15 AS "X",
    column16 AS "Y",
    column17 AS "CodigoPadre",
    column18 AS "FechaIngreso",
    column19 AS "FechaActualización",
    column20 AS "FechaProceso",
    column21 AS "REF1",
    column22 AS "REF2",
    column23 AS "REF3",
    column24 AS "REF4",
    column25 AS "REF5",
    column26 AS "REF6",
    column27 AS "REF7",
    column28 AS "REF8",
    column29 AS "REF9",
    column30 AS "REF10"
FROM {{ ref('raw_clientes') }}