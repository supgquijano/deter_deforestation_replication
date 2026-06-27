
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION — extension
*
* > THIS SCRIPT
* AIM: Inferencia tF (Lee, McCrary, Moreira, Porter 2022) para las
*      especificaciones IV de la Tabla 2 (cols 1-4) y Tabla 3 col 7.
*      Replica las regresiones del paper con xtivreg2 y aplica los
*      factores de ajuste de las Tablas 3A y 3B de Lee et al.
*
* > NOTES
* 1: Se asume que panel_forAnalysis.dta esta cargado y procesado por
*    dataPrep_forAnalysis.do (se invoca desde _run_tF_inference.do).
* 2: F reportado es Kleibergen-Paap (e(widstat) de xtivreg2). En el
*    caso single-instrument, KP = F clasico (Lee et al. 2022, p.3262 n10).
* 3: Interpolacion lineal entre valores tabulados (recomendacion de los
*    autores, Seccion II.B).





** PROGRAMA tf_factor: F, level (0.05 o 0.01) → factor de ajuste --------------------------------------------------------------------------------------
capture program drop tf_factor
program define tf_factor, rclass
    args F level

    * Tabla 3A de Lee et al. (5%): pares (F, adj = sqrt(c_0.05(F))/1.96)
    matrix T05 = (4.000, 9.519 \ 4.008, 9.305 \ 4.015, 9.095 \ 4.023, 8.891 \ 4.031, 8.691 \ ///
                  4.040, 8.495 \ 4.049, 8.304 \ 4.059, 8.117 \ 4.068, 7.934 \ 4.079, 7.756 \ ///
                  4.090, 7.581 \ 4.101, 7.411 \ 4.113, 7.244 \ 4.125, 7.081 \ 4.138, 6.922 \ ///
                  4.151, 6.766 \ 4.166, 6.614 \ 4.180, 6.465 \ 4.196, 6.319 \ 4.212, 6.177 \ ///
                  4.229, 6.038 \ 4.247, 5.902 \ 4.265, 5.770 \ 4.285, 5.640 \ 4.305, 5.513 \ ///
                  4.326, 5.389 \ 4.349, 5.268 \ 4.372, 5.149 \ 4.396, 5.033 \ 4.422, 4.920 \ ///
                  4.449, 4.809 \ 4.477, 4.701 \ 4.507, 4.595 \ 4.538, 4.492 \ 4.570, 4.391 \ ///
                  4.604, 4.292 \ 4.640, 4.195 \ 4.678, 4.101 \ 4.717, 4.009 \ 4.759, 3.919 \ ///
                  4.803, 3.830 \ 4.849, 3.744 \ 4.897, 3.660 \ 4.948, 3.578 \ 5.002, 3.497 \ ///
                  5.059, 3.418 \ 5.119, 3.341 \ 5.182, 3.266 \ 5.248, 3.193 \ 5.319, 3.121 \ ///
                  5.393, 3.051 \ 5.472, 2.982 \ 5.556, 2.915 \ 5.644, 2.849 \ 5.738, 2.785 \ ///
                  5.838, 2.723 \ 5.944, 2.661 \ 6.056, 2.602 \ 6.176, 2.543 \ 6.304, 2.486 \ ///
                  6.440, 2.430 \ 6.585, 2.375 \ 6.741, 2.322 \ 6.907, 2.270 \ 7.085, 2.218 \ ///
                  7.276, 2.169 \ 7.482, 2.120 \ 7.702, 2.072 \ 7.940, 2.025 \ 8.196, 1.980 \ ///
                  8.473, 1.935 \ 8.773, 1.892 \ 9.098, 1.849 \ 9.451, 1.808 \ 9.835, 1.767 \ ///
                  10.253, 1.727 \ 10.711, 1.688 \ 11.214, 1.650 \ 11.766, 1.613 \ 12.374, 1.577 \ ///
                  13.048, 1.542 \ 13.796, 1.507 \ 14.631, 1.473 \ 15.566, 1.440 \ 16.618, 1.407 \ ///
                  17.810, 1.376 \ 19.167, 1.345 \ 20.721, 1.315 \ 22.516, 1.285 \ 24.605, 1.256 \ ///
                  27.058, 1.228 \ 29.967, 1.200 \ 33.457, 1.173 \ 37.699, 1.147 \ 42.930, 1.121 \ ///
                  49.495, 1.096 \ 57.902, 1.071 \ 68.930, 1.047 \ 83.823, 1.024 \ 104.67, 1.000)

    * Tabla 3B de Lee et al. (1%): pares (F, adj = sqrt(c_0.01(F))/2.576)
    matrix T01 = (6.670, 35.366 \ 6.673, 34.135 \ 6.676, 32.946 \ 6.679, 31.798 \ 6.682, 30.691 \ ///
                  6.685, 29.622 \ 6.689, 28.591 \ 6.693, 27.595 \ 6.697, 26.634 \ 6.701, 25.706 \ ///
                  6.706, 24.811 \ 6.711, 23.947 \ 6.717, 23.113 \ 6.723, 22.308 \ 6.729, 21.531 \ ///
                  6.736, 20.781 \ 6.743, 20.058 \ 6.751, 19.359 \ 6.759, 18.685 \ 6.768, 18.034 \ ///
                  6.778, 17.406 \ 6.788, 16.800 \ 6.799, 16.215 \ 6.811, 15.650 \ 6.824, 15.105 \ ///
                  6.837, 14.579 \ 6.852, 14.072 \ 6.867, 13.581 \ 6.884, 13.109 \ 6.901, 12.652 \ ///
                  6.920, 12.211 \ 6.941, 11.786 \ 6.963, 11.376 \ 6.986, 10.980 \ 7.011, 10.597 \ ///
                  7.038, 10.228 \ 7.066, 9.872 \ 7.097, 9.528 \ 7.129, 9.196 \ 7.164, 8.876 \ ///
                  7.202, 8.567 \ 7.242, 8.269 \ 7.285, 7.981 \ 7.331, 7.703 \ 7.380, 7.435 \ ///
                  7.432, 7.176 \ 7.489, 6.926 \ 7.549, 6.685 \ 7.614, 6.452 \ 7.683, 6.227 \ ///
                  7.757, 6.010 \ 7.836, 5.801 \ 7.922, 5.599 \ 8.013, 5.404 \ 8.111, 5.216 \ ///
                  8.216, 5.034 \ 8.329, 4.859 \ 8.451, 4.690 \ 8.581, 4.526 \ 8.721, 4.369 \ ///
                  8.872, 4.217 \ 9.035, 4.070 \ 9.210, 3.928 \ 9.399, 3.791 \ 9.603, 3.659 \ ///
                  9.824, 3.532 \ 10.062, 3.409 \ 10.320, 3.290 \ 10.600, 3.176 \ 10.904, 3.065 \ ///
                  11.235, 2.958 \ 11.595, 2.855 \ 11.988, 2.756 \ 12.418, 2.660 \ 12.889, 2.567 \ ///
                  13.407, 2.478 \ 13.979, 2.392 \ 14.610, 2.308 \ 15.312, 2.228 \ 16.094, 2.150 \ ///
                  16.969, 2.076 \ 17.953, 2.003 \ 19.067, 1.934 \ 20.333, 1.866 \ 21.783, 1.801 \ ///
                  23.455, 1.739 \ 25.399, 1.678 \ 27.680, 1.620 \ 30.383, 1.563 \ 33.624, 1.509 \ ///
                  37.560, 1.456 \ 42.416, 1.406 \ 48.511, 1.357 \ 56.324, 1.309 \ 66.592, 1.264 \ ///
                  80.502, 1.220 \ 100.069, 1.177 \ 128.950, 1.136 \ 174.370, 1.097 \ 252.342, 1.059)

    if "`level'" == "0.05" {
        local Fcrit = 3.8415
        local rows = rowsof(T05)
        tempname M
        matrix `M' = T05
    }
    else {
        local Fcrit = 6.6349
        local rows = rowsof(T01)
        tempname M
        matrix `M' = T01
    }

    * Si F <= q_{1-alpha}: tF da IC infinito → factor = . (missing)
    if `F' <= `Fcrit' {
        return scalar adj = .
        exit
    }

    * Si F mayor que el valor tabulado mas alto: factor minimo
    if `F' >= `M'[`rows', 1] {
        return scalar adj = `M'[`rows', 2]
        exit
    }

    * Si F menor que el valor tabulado mas bajo: factor maximo (extrapolacion)
    if `F' <= `M'[1, 1] {
        return scalar adj = `M'[1, 2]
        exit
    }

    * Interpolacion lineal
    local i = 1
    while `M'[`i'+1, 1] < `F' {
        local i = `i' + 1
    }
    local F_lo  = `M'[`i', 1]
    local F_hi  = `M'[`i'+1, 1]
    local a_lo  = `M'[`i', 2]
    local a_hi  = `M'[`i'+1, 2]
    local adj   = `a_lo' + (`F' - `F_lo') / (`F_hi' - `F_lo') * (`a_hi' - `a_lo')
    return scalar adj = `adj'
end





** PROGRAMA report_tf: imprime inferencia convencional vs tF -----------------------------------------------------------------------------------------
capture program drop report_tf
program define report_tf
    args label beta se F

    local z95 = 1.959964
    local z99 = 2.575829

    tf_factor `F' 0.05
    local adj05 = r(adj)

    tf_factor `F' 0.01
    local adj01 = r(adj)

    local se05 = `se' * `adj05'
    local se01 = `se' * `adj01'

    local t_conv = `beta' / `se'
    local t_05   = `beta' / `se05'
    local t_01   = `beta' / `se01'

    local ci95_conv_lo = `beta' - `z95' * `se'
    local ci95_conv_hi = `beta' + `z95' * `se'
    local ci95_tf_lo   = `beta' - `z95' * `se05'
    local ci95_tf_hi   = `beta' + `z95' * `se05'
    local ci99_conv_lo = `beta' - `z99' * `se'
    local ci99_conv_hi = `beta' + `z99' * `se'
    local ci99_tf_lo   = `beta' - `z99' * `se01'
    local ci99_tf_hi   = `beta' + `z99' * `se01'

    di as text _newline "{hline 92}"
    di as result " `label'"
    di as text   "{hline 92}"
    di as text   "  beta = " as result %9.4f `beta' "   SE_conv = " %8.4f `se' "   F = " %8.3f `F'
    di as text   "  adj_5%%  = " as result %7.4f `adj05' "    adj_1%%  = " %7.4f `adj01'
    di ""
    di as text   "  {center 22:metodo}      {center 9:SE}   {center 7:t}   {center 10:IC low}  {center 10:IC high}   sig?"
    di as text   "  {hline 22}      {hline 9}   {hline 7}   {hline 10}  {hline 10}   {hline 4}"

    local s_conv_5 = cond(abs(`t_conv') > `z95', "**", " no")
    local s_tf_5   = cond(abs(`t_05')   > `z95', "**", " no")
    local s_conv_1 = cond(abs(`t_conv') > `z99', "**", " no")
    local s_tf_1   = cond(abs(`t_01')   > `z99', "**", " no")

    di as text "  Convencional 5%      " ///
       as result %9.4f `se' "  " %7.3f `t_conv' "   " %9.4f `ci95_conv_lo' "  " %9.4f `ci95_conv_hi' "   `s_conv_5'"
    di as text "  tF-ajustado 5%       " ///
       as result %9.4f `se05' "  " %7.3f `t_05' "   " %9.4f `ci95_tf_lo' "  " %9.4f `ci95_tf_hi' "   `s_tf_5'"
    di as text "  Convencional 1%      " ///
       as result %9.4f `se' "  " %7.3f `t_conv' "   " %9.4f `ci99_conv_lo' "  " %9.4f `ci99_conv_hi' "   `s_conv_1'"
    di as text "  tF-ajustado 1%       " ///
       as result %9.4f `se01' "  " %7.3f `t_01' "   " %9.4f `ci99_tf_lo' "  " %9.4f `ci99_tf_hi' "   `s_tf_1'"
    di ""

    * Guardar fila para la tabla resumen final
    matrix tF_results = nullmat(tF_results) \ ///
        (`beta', `se', `F', `adj05', `se05', `t_05', `ci95_tf_lo', `ci95_tf_hi', ///
         `adj01', `se01', `t_01', `ci99_tf_lo', `ci99_tf_hi')
    local n = rowsof(tF_results)
    global tF_label_`n' "`label'"
end





** SETUP: limpiar matriz de resultados ------------------------------------------------------------------------------------------------------------------
capture matrix drop tF_results





** ESPECIFICACIONES IV - replica las regresiones del paper ----------------------------------------------------------------------------------------------

local CONTROLS L.weather_rain L.weather_temp prodes_nonobs prodes_cloud ///
               priceWgtNdx_brzl_s1_cattle  L.priceWgtNdx_brzl_s1_cattle  L.priceWgtNdx_brzl_s2_cattle ///
               priceWgtNdx_brzl_s1_sugar   L.priceWgtNdx_brzl_s1_sugar   L.priceWgtNdx_brzl_s2_sugar ///
               priceWgtNdx_brzl_s1_corn    L.priceWgtNdx_brzl_s1_corn    L.priceWgtNdx_brzl_s2_corn ///
               priceWgtNdx_brzl_s1_soybean L.priceWgtNdx_brzl_s1_soybean L.priceWgtNdx_brzl_s2_soybean ///
               priceWgtNdx_brzl_s1_cassava L.priceWgtNdx_brzl_s1_cassava L.priceWgtNdx_brzl_s2_cassava ///
               priceWgtNdx_brzl_s1_rice    L.priceWgtNdx_brzl_s1_rice    L.priceWgtNdx_brzl_s2_rice



* --- Tabla 2 col 1: IHS(deforest), benchmark -------------------------------------------------------------------------------------------------------
xi: xtivreg2 prodes_deforest_ihs (L.fines_count = L.deter_cloud) `CONTROLS' i.year ///
    if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast')), ///
    fe cluster(muni_code cl_microYear) ffirst

local b   = _b[L.fines_count]
local se  = _se[L.fines_count]
local F   = e(widstat)
report_tf "T2 col 1 - IHS(deforest), benchmark" `b' `se' `F'



* --- Tabla 2 col 2: ln(deforest+0.01) --------------------------------------------------------------------------------------------------------------
xi: xtivreg2 prodes_deforest_log (L.fines_count = L.deter_cloud) `CONTROLS' i.year ///
    if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast')), ///
    fe cluster(muni_code cl_microYear) ffirst

local b   = _b[L.fines_count]
local se  = _se[L.fines_count]
local F   = e(widstat)
report_tf "T2 col 2 - ln(deforest+0.01)" `b' `se' `F'



* --- Tabla 2 col 3: deforest/muni_area -------------------------------------------------------------------------------------------------------------
xi: xtivreg2 prodes_deforest_dma_100 (L.fines_count = L.deter_cloud) `CONTROLS' i.year ///
    if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast')), ///
    fe cluster(muni_code cl_microYear) ffirst

local b   = _b[L.fines_count]
local se  = _se[L.fines_count]
local F   = e(widstat)
report_tf "T2 col 3 - deforest/muni_area" `b' `se' `F'



* --- Tabla 2 col 4: deforest/mean_def --------------------------------------------------------------------------------------------------------------
xi: xtivreg2 prodes_deforest_dbm (L.fines_count = L.deter_cloud) `CONTROLS' i.year ///
    if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast')), ///
    fe cluster(muni_code cl_microYear) ffirst

local b   = _b[L.fines_count]
local se  = _se[L.fines_count]
local F   = e(widstat)
report_tf "T2 col 4 - deforest/mean_def" `b' `se' `F'



* --- Tabla 3 col 7: cluster state-year -------------------------------------------------------------------------------------------------------------
xi: xtivreg2 prodes_deforest_ihs (L.fines_count = L.deter_cloud) `CONTROLS' i.year ///
    if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast')), ///
    fe cluster(muni_code cl_stateYear) ffirst

local b   = _b[L.fines_count]
local se  = _se[L.fines_count]
local F   = e(widstat)
report_tf "T3 col 7 - cluster state-year" `b' `se' `F'





** TABLA RESUMEN FINAL ----------------------------------------------------------------------------------------------------------------------------------
matrix colnames tF_results = beta se F adj05 se_tf05 t_tf05 ci95_lo ci95_hi adj01 se_tf01 t_tf01 ci99_lo ci99_hi

di as text _newline _newline "{hline 92}"
di as result " TABLA RESUMEN: Inferencia tF (Lee et al. 2022) aplicada al paper DETER"
di as text   "{hline 92}"
matrix list tF_results, format(%9.4f)



* Exportar a CSV
preserve
clear
svmat double tF_results, names(col)
gen str60 spec = ""
forvalues r = 1/`=_N' {
    replace spec = "${tF_label_`r'}" in `r'
}
order spec
export delimited using "$DIR_PRJ_DANL_REG/table_tF_inference.csv", replace
restore



* END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------
