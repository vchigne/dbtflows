{{ config(
    materialized = 'table',
    schema = 'marts',
    tags = ['transactional', 'partitioned', 'pedidos'],
    indexes = [
      {'columns': ['CodigoProveedor', 'CodigoDistribuidor', 'CodigoPedido', 'NumeroItem', 'CodigoProducto'], 'unique': true}
    ],
    post_hook = [
        "{{ write_partitioned_parquet('CodigoProveedor, CodigoDistribuidor, anio, mes, dia') }}"
    ]
) }}

SELECT
    column00::VARCHAR AS "CodigoProveedor",
    column01::VARCHAR AS "CodigoDistribuidor",
    column02::VARCHAR AS "CodigoCliente",
    column03::VARCHAR AS "CodigoVendedor",
    column04::VARCHAR AS "Origen",
    column05::VARCHAR AS "CodigoPedido",
    TRY_CAST(column06 AS DATE) AS "FechaPedido",
    -- Usar TRY_CAST para manejar posibles errores de conversión
    -- Y usar DATE_PART en lugar de EXTRACT para mayor compatibilidad
    DATE_PART('year', TRY_CAST(column06 AS DATE))::INT AS anio,
    DATE_PART('month', TRY_CAST(column06 AS DATE))::INT AS mes,
    DATE_PART('day', TRY_CAST(column06 AS DATE))::INT AS dia,
    column07 AS "EstatusPedido",
    column08 AS "MotivoCancelación",
    column09::VARCHAR AS "TipoDocumento",
    column10 AS "Documento",
    column11 AS "FechaDocumento",
    column12 AS "EstatusDocumento",
    column13 AS "NumeroItem",
    column14 AS "CodigoProducto",
    column15 AS "TipoProducto",
    column16 AS "CantidadUnidadMinima",
    column17 AS "TipoUnidadMinima",
    column18 AS "CantidadUnidadMaxima",
    column19 AS "TipoUnidadMaxima",
    column20 AS "ImportePedidoNetoSinImpuesto",
    column21 AS "ImportePedidoNetoConImpuesto",
    column22 AS "Descuento",
    column23 AS "FechaProceso",
    column24 AS "REF1",
    column25 AS "CodCombo",
    column26 AS "ZonaVendedor",
    column27 AS "REF4",
    column28 AS "REF5",
    column29 AS "REF6",
    column30 AS "REF7",
    column31 AS "REF8",
    column32 AS "REF9",
    column33 AS "REF10"
FROM {{ ref('raw_pedidos') }}