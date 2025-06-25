# Dashboard Distribuidora by Strategio Vida Software

## Ventas
```sql ventas_mensuales
SELECT 
    EXTRACT(MONTH FROM "FechaDocumento") AS mes,
    EXTRACT(YEAR FROM "FechaDocumento") AS año,
    SUM("ImporteNetoConImpuesto") AS ventas_total,
    COUNT(DISTINCT "CodigoCliente") AS clientes_unicos,
    SUM("CantidadUnidadMinima") AS unidades_vendidas
FROM ventas
GROUP BY mes, año
--ORDER BY año, mes
```

<BigValue 
    data={ventas_mensuales} 
    value=ventas_total 
    title="Ventas Totales"
/>
<BigValue 
    data={ventas_mensuales} 
    value=clientes_unicos
    title="Clientes Unicos"
/>
<BigValue 
    data={ventas_mensuales} 
    value=unidades_vendidas
    title="Unidades Vendidas"
/>


La evolución de ventas mensuales segun los datos  muestra el comportamiento del negocio en el tiempo.

<BarChart 
    data={ventas_mensuales} 
    x="mes" 
    y="ventas_total" 
    title="Ventas Mensuales" 
    yAxisTitle="Ventas (S/)" 
/>

```sql top_10_productos
SELECT 
    p."CodigoProducto",
    p."NombreProducto",
    SUM(v."ImporteNetoConImpuesto") AS ventas_total,
    SUM(v."CantidadUnidadMinima") AS unidades_vendidas
FROM ventas v
JOIN productos p ON v."CodigoProducto" = p."CodigoProducto"
                            AND v."CódigoProveedor" = p."CódigoProveedor"
                            AND v."CodigoDistribuidor" = p."CodigoDistribuidor"
GROUP BY p."CodigoProducto", p."NombreProducto"
ORDER BY ventas_total DESC
LIMIT 10
```

### Top 10 Productos más Vendidos

<BarChart 
    data={top_10_productos} 
    x="NombreProducto" 
    y="ventas_total" 
    title="Top 10 Productos por Ventas" 
    yAxisTitle="Ventas (S/)" 
/>

```sql ventas_por_vendedor
SELECT 
    v."CodigoVendedor",
    vend."NombreVendedor",
    SUM(v."ImporteNetoConImpuesto") AS ventas_total,
    COUNT(DISTINCT v."CodigoCliente") AS clientes_atendidos,
    COUNT(DISTINCT v."NroDocumento") AS documentos_emitidos
FROM ventas v
JOIN vendedores vend ON v."CodigoVendedor" = vend."CodigoVendedor"
                                AND v."CódigoProveedor" = vend."CódigoProveedor"
                                AND v."CodigoDistribuidor" = vend."CodigoDistribuidor"
GROUP BY v."CodigoVendedor", vend."NombreVendedor"
ORDER BY ventas_total DESC
```

### Rendimiento de Vendedores

<BarChart 
    data={ventas_por_vendedor} 
    x="NombreVendedor" 
    y="ventas_total" 
    title="Ventas por Vendedor" 
    yAxisTitle="Ventas (S/)" 
/>

## Stock

```sql stock_por_almacen
SELECT 
    s."CodigoAlmacen",
    s."NombreAlmacen",
    SUM(s."StockEnUnidadMinima") AS stock_total_unidades,
    SUM(s."ValorStock") AS valor_stock_total
FROM stock s
GROUP BY s."CodigoAlmacen", s."NombreAlmacen"
ORDER BY valor_stock_total DESC
```

<BigValue 
    data={stock_por_almacen} 
    value=valor_stock_total 
    title="Valor Total de Inventario"
/>

### Stock por Almacén

<BarChart 
    data={stock_por_almacen} 
    x="NombreAlmacen" 
    y="valor_stock_total" 
    title="Valor de Stock por Almacén" 
    yAxisTitle="Valor (S/)" 
/>

```sql productos_criticos
SELECT 
    p."CodigoProducto",
    p."NombreProducto",
    s."StockEnUnidadMinima" AS stock_actual,
    s."ValorStock" AS valor_stock,
    CASE 
        WHEN s."StockEnUnidadMinima" < 100 THEN 'Crítico'
        WHEN s."StockEnUnidadMinima" < 300 THEN 'Bajo'
        ELSE 'Normal'
    END AS estado_stock
FROM stock s
JOIN productos p ON s."CodigoProducto" = p."CodigoProducto"
                            AND s."CódigoProveedor" = p."CódigoProveedor"
                            AND s."CodigoDistribuidor" = p."CodigoDistribuidor"
WHERE s."StockEnUnidadMinima" < 300
ORDER BY s."StockEnUnidadMinima" ASC
LIMIT 10
```

### Productos con Stock Crítico o Bajo

<DataTable data={productos_criticos} />

## Vendedores

```sql resumen_vendedores
SELECT 
    COUNT(*) AS total_vendedores,
    SUM(CASE WHEN "EstadoVendedor" = 'Activo' THEN 1 ELSE 0 END) AS vendedores_activos,
    AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, "FechaIngreso"::DATE))) AS antiguedad_promedio_años
FROM vendedores
```

<BigValue 
    data={resumen_vendedores} 
    value=total_vendedores 
    title="Total de Vendedores"
/>

<BigValue 
    data={resumen_vendedores} 
    value=vendedores_activos 
    title="Vendedores Activos"
/>

```sql vendedores_efectividad
SELECT 
    v."CodigoVendedor",
    v."NombreVendedor",
    COUNT(DISTINCT vent."NroDocumento") AS documentos_emitidos,
    COUNT(DISTINCT vent."CodigoCliente") AS clientes_atendidos,
    SUM(vent."ImporteNetoConImpuesto") AS ventas_total,
    SUM(vent."ImporteNetoConImpuesto") / COUNT(DISTINCT vent."CodigoCliente") AS ticket_promedio
FROM vendedores v
LEFT JOIN ventas vent ON v."CodigoVendedor" = vent."CodigoVendedor"
                                AND v."CódigoProveedor" = vent."CódigoProveedor"
                                AND v."CodigoDistribuidor" = vent."CodigoDistribuidor"
GROUP BY v."CodigoVendedor", v."NombreVendedor"
ORDER BY ventas_total DESC
```

### Efectividad de Vendedores

<DataTable data={vendedores_efectividad} />

## Clientes

```sql resumen_clientes
SELECT 
    COUNT(*) AS total_clientes,
    COUNT(DISTINCT "GiroNegocio") AS segmentos_negocio,
    COUNT(DISTINCT "Ubigeo") AS zonas_geograficas
FROM clientes
```

<BigValue 
    data={resumen_clientes} 
    value=total_clientes 
    title="Total de Clientes"
/>

```sql clientes_por_canal
SELECT 
    "Canal",
    COUNT(*) AS cantidad_clientes,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clientes), 2) AS porcentaje
FROM clientes
GROUP BY "Canal"
ORDER BY cantidad_clientes DESC
```

### Distribución de Clientes por Canal

```sql clientes_por_canal_echarts_format
SELECT 
    "Canal" AS name,
    COUNT(*) AS value
FROM clientes
GROUP BY "Canal"
ORDER BY value DESC
```

<ECharts config={ {
    tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c} ({d}%)'
    },
    series: [
        {
            name: 'Clientes por Canal',
            type: 'pie',
            radius: ['40%', '70%'],
            avoidLabelOverlap: false,
            itemStyle: {
                borderRadius: 10,
                borderColor: '#fff',
                borderWidth: 2
            },
            label: {
                show: true,
                formatter: '{b}: {c} ({d}%)'
            },
            emphasis: {
                label: {
                    show: true,
                    fontSize: '16',
                    fontWeight: 'bold'
                }
            },
            data: [...clientes_por_canal_echarts_format]
        }
    ]
} } />

```sql top_clientes
SELECT 
    c."CodigoCliente",
    c."NombreCliente",
    c."Canal",
    c."GiroNegocio",
    SUM(v."ImporteNetoConImpuesto") AS ventas_total,
    COUNT(DISTINCT v."NroDocumento") AS transacciones
FROM clientes c
JOIN ventas v ON c."CodigoCliente" = v."CodigoCliente"
                        AND c."CódigoProveedor" = v."CódigoProveedor"
                        AND c."CodigoDistribuidor" = v."CodigoDistribuidor"
GROUP BY c."CodigoCliente", c."NombreCliente", c."Canal", c."GiroNegocio"
ORDER BY ventas_total DESC
LIMIT 10
```

### Top 10 Clientes por Ventas

<DataTable data={top_clientes} />

## Productos

```sql resumen_productos
SELECT 
    COUNT(*) AS total_productos,
    AVG("PrecioSugerido") AS precio_promedio,
    AVG("FactorCaja") AS factor_caja_promedio
FROM productos
```

<BigValue 
    data={resumen_productos} 
    value=total_productos 
    title="Total de Productos"
/>

```sql productos_mas_rentables
SELECT 
    p."CodigoProducto",
    p."NombreProducto",
    p."PrecioSugerido",
    p."PrecioCompra",
    p."PrecioSugerido" - p."PrecioCompra" AS margen_unitario,
    ROUND((p."PrecioSugerido" - p."PrecioCompra") * 100.0 / p."PrecioCompra", 2) AS porcentaje_margen
FROM productos p
ORDER BY porcentaje_margen DESC
LIMIT 10
```

### Productos con Mayor Margen de Ganancia

<BarChart 
    data={productos_mas_rentables} 
    x="NombreProducto" 
    y="porcentaje_margen" 
    title="Top 10 Productos por Margen (%)" 
    yAxisTitle="Margen (%)" 
/>

```sql productos_mas_caros
SELECT 
    "CodigoProducto",
    "NombreProducto",
    "PrecioSugerido",
    "EAN",
    "FlagBonificado"
FROM productos
ORDER BY "PrecioSugerido" DESC
LIMIT 10
```

### Productos de Mayor Valor

<DataTable data={productos_mas_caros} />

## Indicadores Clave de Desempeño (KPIs)

```sql kpi_general
WITH 
ventas_total AS (
    SELECT SUM("ImporteNetoConImpuesto") AS total_ventas
    FROM ventas
),
stock_valor AS (
    SELECT SUM("ValorStock") AS total_stock
    FROM stock
),
clientes_activos AS (
    SELECT COUNT(DISTINCT "CodigoCliente") AS total_clientes
    FROM ventas
),
ticket_promedio AS (
    SELECT 
        SUM("ImporteNetoConImpuesto") / COUNT(DISTINCT "NroDocumento") AS promedio
    FROM ventas
)
SELECT 
    vt.total_ventas,
    sv.total_stock,
    ca.total_clientes,
    tp.promedio AS ticket_promedio
FROM ventas_total vt, stock_valor sv, clientes_activos ca, ticket_promedio tp
```

<BigValue 
    data={kpi_general} 
    value=total_ventas 
    title="Ventas Totales"
/>

<BigValue 
    data={kpi_general} 
    value=total_stock 
    title="Valor de Inventario"
/>

<BigValue 
    data={kpi_general} 
    value=total_clientes 
    title="Clientes Activos"
/>

<BigValue 
    data={kpi_general} 
    value=ticket_promedio 
    title="Ticket Promedio"
/>

```sql rotacion_stock
WITH 
ventas_cantidad AS (
    SELECT 
        v."CodigoProducto",
        SUM(v."CantidadUnidadMinima") AS unidades_vendidas
    FROM ventas v
    GROUP BY v."CodigoProducto"
),
stock_cantidad AS (
    SELECT 
        s."CodigoProducto",
        AVG(s."StockEnUnidadMinima") AS stock_promedio
    FROM stock s
    GROUP BY s."CodigoProducto"
)
SELECT 
    p."CodigoProducto",
    p."NombreProducto",
    vc.unidades_vendidas,
    sc.stock_promedio,
    CASE 
        WHEN sc.stock_promedio > 0 THEN vc.unidades_vendidas / sc.stock_promedio
        ELSE 0
    END AS indice_rotacion
FROM productos p
JOIN ventas_cantidad vc ON p."CodigoProducto" = vc."CodigoProducto"
JOIN stock_cantidad sc ON p."CodigoProducto" = sc."CodigoProducto"
ORDER BY indice_rotacion DESC
LIMIT 10
```

### Productos con Mayor Rotación de Inventario

<DataTable data={rotacion_stock} />
