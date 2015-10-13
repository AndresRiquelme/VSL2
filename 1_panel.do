********************************************************************
* !v1.1 26jul2015                                                  *
*  do file to process the panel_small.dta file (3,404KB)           *
*  For the working paper:                                          *
*   "The Value of A Statistical Life in Absence of Panel Data:     *
*       What can we do?."  Marcela Parada, Andrés Riquelme         *
*   Created on 24jul2015                                           *
********************************************************************

* Este archivo funciona bien, por favor pon un comentario con cada cambio que hagas


* Load the data set
clear all // Marcela agrego esto 
clear
log using vsl2, replace
set more off
set memory 50000
set matsize 1500
set seed 10001

ssc install ivreg2 // Marcela agrego esto para virtual lab UNC
ssc install xtivreg2 // Marcela agrego esto para virtual lab UNC
ssc install ranktest // Marcela agrego esto para virtual lab UNC

capture cd "\\Client\C$\Users\Marcela\Documents\VSL2\Models" // Marcela Agrego esto para virtual lab UNC


use panel_small.dta, replace

* Preliminarly cleaning and recoding
drop if b2==4 // Drop inactive workers
recode daar 88 99 =. 

* We have mothly wage and weekly hours
capture drop hwage lnhwage
gen hwage = (salario /4.5) /horas
gen lnhwage = log(hwage)

/*
* Histogram of the Willingness to take risks (2009)
histogram daar if year==2009, discrete width(1) start(0) percent addlabel ///
          scheme(s2mono) name(graph1, replace) graphregion(fcolor(white)  ///
		  lcolor(none) ifcolor(none) ilcolor(none))
*/

* Panel Setup here
* Generate consecutive time
capture drop t
gen int      t  = year
recode       t (2004=1) (2006=2) (2009=3)
capture drop id
egen int     id = group(folio)
xtset        id t

capture drop chsec
gen byte     chsec= 0 + (d.sector != 0)		// Job sector switchers
capture drop filter
gen byte     filter = 1

* Try some splines here
capture drop spline*
gen int      spline1 = esc if esc<=8
recode       spline1 (.=0)
gen int      spline2 = esc-8 if (esc >8 & esc <=12)
recode       spline2 (.=0)
gen int      spline3 = esc-12 if esc>12
recode       spline3 (.=0)
*************************************************
* User changeable settings start here

recode filter (1=0) if b2!=1 | edad >65 // Employed only

* Define global variables
*  (we use global to allow multiple do-files batch)
global y            lnhwage
global x            rf
global controls     spline* expe expe2    // publico sindicato contrato
global instrumentos sexo ecivil esc_cony enf_cony trab_cony hijo6
global risk         daar
global filter       filter
global nreps        10    //for bootstrap SE

* Example> regress d.$y d.$x d.($controls) if $filter

*/////////////////////////////////////
local  total_models = 11
matrix table_output = J(17 , `total_models', 1/0)
matrix rownames table_output = Alpha Beta(risk) Robust_SE Boot_SE Default R2 RMSE RSS TSS Sigma_a Sigma_e Lambda N VSL Range VSL_l VSL_h
matrix colnames table_output = POLS Between Within First_Diff REGLS REML XTIVFE XTIVFD OSL09 IV09 IVDAAR2009

*quietly{
	do p_pooled
	do p_between
	do p_within
	do p_fdiff
 	do p_regls
 	do p_remle
	do p_xtivfe
	do p_xtivfd
	do ols2009
	do iv2009
	do iv_daar2009
*}

summarize salario if $filter
scalar averagew = r(mean)
forvalues j = 1/6 {
	matrix table_output[14,`j'] = table_output[2,`j']* averagew * 12 * 10000
	matrix table_output[15,`j'] = 1.96 * table_output[3,`j'] * averagew * 12 * 10000
	matrix table_output[16,`j'] = table_output[14,`j'] - table_output[15,`j']
	matrix table_output[17,`j'] = table_output[14,`j'] + table_output[15,`j']
}

*Correct mean wage
summarize salario if $filter & year==2009
scalar averagew = r(mean)
forvalues j = 7/`total_models' {
	matrix table_output[14,`j'] = table_output[2,`j']* averagew * 12 * 10000
	matrix table_output[15,`j'] = 1.96 * table_output[3,`j'] * averagew * 12 * 10000
	matrix table_output[16,`j'] = table_output[14,`j'] - table_output[15,`j']
	matrix table_output[17,`j'] = table_output[14,`j'] + table_output[15,`j']
}


matrix output = table_output[2...,1...]
matrix list output

log close
