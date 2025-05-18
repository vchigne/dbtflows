{{ config(
    materialized = 'table',
    schema = 'marts',
    tags = ['transactional', 'partitioned', 'ventas'],
    indexes = [
      {'columns': ['CodigoProveedor', 'CodigoDistribuidor', 'TipoDocumento', 'NroDocumento', 'NumeroItem', 'CodigoProducto'], 'unique': true}
    ],
    post_hook = [
        "{{ write_partitioned_parquet('CodigoProveedor, CodigoDistribuidor, anio, mes, dia') }}"
    ]
) }}

SELECT
    column00::VARCHAR AS "CodigoProveedor",
    column01::VARCHAR AS "CodigoDistribuidor",
    column02 AS "TipoDocumento",
    column03 AS "NroDocumento",
    column04 AS "FechaDocumento",
    EXTRACT(YEAR FROM column04::DATE)::INT AS anio,
    EXTRACT(MONTH FROM column04::DATE)::INT AS mes,
    EXTRACT(DAY FROM column04::DATE)::INT AS dia,
    column05 AS "MotivoNC",
    column06 AS "Origen",
    column07::VARCHAR AS "CodigoCliente",
    column08 AS "CanalCliente",
    column09 AS "TipoNegocio",
    column10::VARCHAR AS "CodigoVendedor",
    column11 AS "CanalVendedor",
    column12 AS "Ruta",
    column13 AS "NumeroItem",
    column14::VARCHAR AS "CodigoProducto",
    column15 AS "CantidadUnidadMinima",
    column16 AS "TipoUnidadMinima",
    column17 AS "CantidadUnidadMaxima",
    column18 AS "TipoUnidadMaxima",
    column19 AS "Moneda",
    column20 AS "ImporteNetoSinImpuesto",
    column21 AS "ImporteNetoConImpuesto",
    column22 AS "Descuento",
    column23 AS "TipoVenta",
    column24 AS "CodCombo",
    column25 AS "CodPromoción",
    column26 AS "TipoDocumentoReferencia",
    column27 AS "NroDocumentoReferencia",
    column28 AS "FechaDocumentoReferencia",
    column29 AS "FechaProceso",
    column30 AS "DescripcionPromocion",
    column31 AS "REF2",
    column32 AS "REF3",
    column33 AS "REF4",
    column34 AS "ZonaVendedor",
    column35 AS "REF6",
    column36 AS "REF7",
    column37 AS "REF8",
    column38 AS "REF9",
    column39 AS "REF10"
FROM {{ ref('raw_ventas') }}