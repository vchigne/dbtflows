{% macro generate_date_dimensions() %}
    {# Genera dimensiones de fecha a partir de un campo fecha #}
    EXTRACT(YEAR FROM fecha_campo)::INT AS anio,
    EXTRACT(MONTH FROM fecha_campo)::INT AS mes,
    EXTRACT(DAY FROM fecha_campo)::INT AS dia
{% endmacro %}

{% macro verify_file_exists(file_path) %}
    {# Verifica si un archivo existe #}
    {% set verification_query %}
        SELECT COUNT(*) FROM read_parquet('{{ file_path }}') LIMIT 1
    {% endset %}
    
    {% set results = run_query(verification_query) %}
    {% if execute %}
        {{ return(results) }}
    {% else %}
        {{ return(0) }}
    {% endif %}
{% endmacro %}