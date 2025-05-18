if "%1"=="" (
    echo Error: Debes proporcionar el UUID del directorio donde estan los archivos Parquet
    echo Uso: run_dbt_single_command.bat ^<uuid^>
    exit /b 1
)

set UUID=%1
set DBT_PROFILES_DIR=.

echo Inicializando esquema de staging…

dbt run-operation init_staging_db  --profiles-dir %DBT_PROFILES_DIR%  --vars "{\"uuid\":\"%UUID%\"}"

echo Ejecutando flujo completo (raw -> transform -> staging)…

dbt run --profiles-dir %DBT_PROFILES_DIR%  --vars "{\"uuid\":\"%UUID%\"}"

