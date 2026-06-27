
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION — extension
*
* > THIS SCRIPT
* AIM: Versión "oficial" del ajuste tF de Lee, McCrary, Moreira & Porter (2022).
*      Instala el paquete Stata distribuido por los autores en Princeton, corre las
*      mismas 5 regresiones IV (Tabla 2 cols 1-4 + Tabla 3 col 7 del paper DETER)
*      y reporta SE/IC ajustados via el comando oficial.
*
* > FLUJO
* 1. Setup
* 2. Instalar paquete tf de Lee et al. en ado/plus/ del proyecto
* 3. Cargar datos
* 4. Correr 5 regresiones xtivreg2 + comando oficial tF
*
* > NOTAS
* 1: Self-contained — tras instalar paquete (paso 2), correr todo de una pasada
*    debe producir los mismos numeros que table_tF_inference.do
* 2: El paquete NO esta en SSC; se descarga desde la pagina de los autores:
*    https://www.princeton.edu/~davidlee/wp/SupplementarytF.html
* 3: La sintaxis exacta del comando puede variar segun la version del paquete.
*    Si el comando se llama distinto a "tf" o su sintaxis difiere, ver el bloque
*    "USO DEL COMANDO OFICIAL" mas abajo y ajustar con base en "help tf".





** SETUP ---------------------------------------------------------------------------------------------------------------------------------------------
version    14.2
set more   off
set        matsize 11000
clear      all



** LOG
capture log close _all
log using "C:/Users/gquij/projects/replication/_run_tF_official_out.log", text replace name(tflog)



** CD AL PROYECTO
cd "C:/Users/gquij/projects/replication"



** DIRECTORIES (carga $DIR_PRJ_*)
do "code/config_proj.do"



** APUNTAR STATA AL ado/plus LOCAL DEL PROYECTO
sysdir set PLUS "$DIR_PRJ/ado/plus"
adopath ++ "$DIR_PRJ/ado/plus"





** INSTALACION DEL PAQUETE OFICIAL tF ----------------------------------------------------------------------------------------------------------------
/*
   El paquete de Lee, McCrary, Moreira & Porter (2022) se distribuye desde la pagina
   personal de Lee:  https://www.princeton.edu/~davidlee/wp/SupplementarytF.html

   Hay tres formas de instalarlo, en orden de preferencia:

   OPCION A) net install — si Princeton expone un endpoint Stata-compatible
*/

capture which tf
if _rc != 0 {
    di as text "Paquete tf no encontrado. Intentando instalar..."

    * --- OPCION A: net install ---
    capture noisily net install tf, from("https://www.princeton.edu/~davidlee/wp/")

    * --- OPCION B (fallback): descarga directa del .ado ---
    if _rc != 0 {
        di as text "net install fallo. Intentando descarga directa del .ado..."
        capture mkdir "$DIR_PRJ/ado/plus/t"
        capture copy "https://www.princeton.edu/~davidlee/wp/tf.ado" ///
                     "$DIR_PRJ/ado/plus/t/tf.ado", replace
        capture copy "https://www.princeton.edu/~davidlee/wp/tf.sthlp" ///
                     "$DIR_PRJ/ado/plus/t/tf.sthlp", replace
    }

    * --- OPCION C (manual): instrucciones para el usuario si las opciones A y B fallan ---
    capture which tf
    if _rc != 0 {
        di as error "============================================================"
        di as error "  INSTALACION AUTOMATICA FALLO."
        di as error "  Descargar manualmente desde:"
        di as error "  https://www.princeton.edu/~davidlee/wp/SupplementarytF.html"
        di as error "  y copiar tf.ado (y tf.sthlp) a:"
        di as error "  $DIR_PRJ/ado/plus/t/"
        di as error "  Luego volver a correr este do-file."
        di as error "============================================================"
        exit 198
    }
}

* Verificacion final
which tf
di as text "Paquete tf disponible. Procediendo con las regresiones."





** DATA INPUT ----------------------------------------------------------------------------------------------------------------------------------------
cd   "$DIR_PRJ_DSPC"
use  panel_forAnalysis, clear



** SAMPLE TIME PERIOD
scalar yearFirst = 2006
scalar yearLast  = 2016



** PANEL SETUP
xtset muni_code year





** ESPECIFICACIONES IV - replica las regresiones del paper DETER ------------------------------------------------------------------------------------

local CONTROLS L.weather_rain L.weather_temp prodes_nonobs prodes_cloud ///
               priceWgtNdx_brzl_s1_cattle  L.priceWgtNdx_brzl_s1_cattle  L.priceWgtNdx_brzl_s2_cattle ///
               priceWgtNdx_brzl_s1_sugar   L.priceWgtNdx_brzl_s1_sugar   L.priceWgtNdx_brzl_s2_sugar ///
               priceWgtNdx_brzl_s1_corn    L.priceWgtNdx_brzl_s1_corn    L.priceWgtNdx_brzl_s2_corn ///
               priceWgtNdx_brzl_s1_soybean L.priceWgtNdx_brzl_s1_soybean L.priceWgtNdx_brzl_s2_soybean ///
               priceWgtNdx_brzl_s1_cassava L.priceWgtNdx_brzl_s1_cassava L.priceWgtNdx_brzl_s2_cassava ///
               priceWgtNdx_brzl_s1_rice    L.priceWgtNdx_brzl_s1_rice    L.priceWgtNdx_brzl_s2_rice




** USO DEL COMANDO OFICIAL ----------------------------------------------------------------------------------------------------------------------------
/*
   SINTAXIS PROBABLE (verificar con "help tf" tras instalar):

      tf , level(95)
            -> Lee el F de la primera etapa y el SE de la 2SLS desde e() de la
               regresion previa, devuelve SE ajustado, t-stat e IC al nivel pedido.

   SINTAXIS ALTERNATIVA (si el comando no lee e()):

      tf , f(`F') se(`se') level(95)
            -> Recibe F y SE como argumentos explicitos.

   En cualquiera de las dos formas, los resultados se acceden via r() o se imprimen
   directamente a pantalla. Aqui usamos la version "lee de e()" como default y, si
   no funciona, recurrimos a la version explicita.

   AJUSTAR SEGUN LO QUE DIGA "help tf".
*/

capture program drop run_official_tf
program define run_official_tf
    args label
    di as text _newline "{hline 92}"
    di as result " `label'"
    di as text   "{hline 92}"

    * --- Intento 1: el paquete lee directamente de e() ---
    capture noisily tf, level(95)
    if _rc == 0 {
        capture noisily tf, level(99)
        exit
    }

    * --- Intento 2: pasar F y SE explicitos ---
    local b  = _b[L.fines_count]
    local se = _se[L.fines_count]
    local F  = e(widstat)
    di as text "Reintentando con argumentos explicitos: F=`F', SE=`se'"

    capture noisily tf , f(`F') se(`se') level(95)
    capture noisily tf , f(`F') se(`se') level(99)
end





** Tabla 2 col 1: IHS(deforest), benchmark -----------------------------------------------------------------------------------------------------------
xi: tf prodes_deforest_ihs (L.fines_count = L.deter_cloud) `CONTROLS' i.year ///
    if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast')), ///
    fe cluster(muni_code cl_microYear) ffirst

run_official_tf "T2 col 1 - IHS(deforest), benchmark"



** Tabla 2 col 2: ln(deforest+0.01) ------------------------------------------------------------------------------------------------------------------
xi: xtivreg2 prodes_deforest_log (L.fines_count = L.deter_cloud) `CONTROLS' i.year ///
    if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast')), ///
    fe cluster(muni_code cl_microYear) ffirst

run_official_tf "T2 col 2 - ln(deforest+0.01)"



** Tabla 2 col 3: deforest/muni_area -----------------------------------------------------------------------------------------------------------------
xi: xtivreg2 prodes_deforest_dma_100 (L.fines_count = L.deter_cloud) `CONTROLS' i.year ///
    if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast')), ///
    fe cluster(muni_code cl_microYear) ffirst

run_official_tf "T2 col 3 - deforest/muni_area"



** Tabla 2 col 4: deforest/mean_def ------------------------------------------------------------------------------------------------------------------
xi: xtivreg2 prodes_deforest_dbm (L.fines_count = L.deter_cloud) `CONTROLS' i.year ///
    if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast')), ///
    fe cluster(muni_code cl_microYear) ffirst

run_official_tf "T2 col 4 - deforest/mean_def"



** Tabla 3 col 7: cluster state-year -----------------------------------------------------------------------------------------------------------------
xi: xtivreg2 prodes_deforest_ihs (L.fines_count = L.deter_cloud) `CONTROLS' i.year ///
    if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast')), ///
    fe cluster(muni_code cl_stateYear) ffirst

run_official_tf "T3 col 7 - cluster state-year"





** CIERRE --------------------------------------------------------------------------------------------------------------------------------------------
log close tflog

* END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------
