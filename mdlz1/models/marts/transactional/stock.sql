{{ config(
    materialized = 'table',
    schema = 'marts',
    tags = ['transactional', 'partitioned', 'stock'],
    indexes = [
      {'columns': ['CodigoProveedor', 'CodigoDistribuidor', 'CodigoAlmacen', 'CodigoProducto'], 'unique': true}
    ],
    post_hook = [
        "{{ write_partitioned_parquet('CodigoProveedor, CodigoDistribuidor, anio, mes, dia') }}"
    ]
) }}

SELECT
    column00::VARCHAR AS "CodigoProveedor",
    column01::VARCHAR AS "CodigoDistribuidor",
    column02::VARCHAR AS "CodigoAlmacen",
    column03 AS "NombreAlmacen",
    column04::VARCHAR AS "CodigoProducto",
    column05 AS "Lote",
    column06 AS "FechaVencimiento",
    column07 AS "StockEnUnidadMinima",
    column08 AS "UnidadDeMedidaMinima",
    column09 AS "StockEnUnidadesMaximas",
    column10 AS "UnidadDeMedidaMaxima",
    column11 AS "ValorStock",
    column12 AS "FechaProceso",
    EXTRACT(YEAR FROM column12::DATE)::INT AS anio,
    EXTRACT(MONTH FROM column12::DATE)::INT AS mes,
    EXTRACT(DAY FROM column12::DATE)::INT AS dia,
    column13 AS "IngresosEnUnidadDeConsumo",
    column14 AS "ValorIngresos",
    column15 AS "VentasEnUnidadDeConsumo",
    column16 AS "ValorVentas",
    column17 AS "OtrosEnUnidadDeConsumo",
    column18 AS "ValorOtros",
    column19 AS "Periodo",
    column20 AS "REF1",
    column21 AS "REF2",
    column22 AS "REF3",
    column23 AS "REF4",
    column24 AS "REF5",
    column25 AS "REF6",
    column26 AS "REF7",
    column27 AS "REF8",
    column28 AS "REF9",
    column29 AS "REF10"
FROM {{ ref('raw_stock') }}