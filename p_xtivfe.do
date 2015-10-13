*******************************************************
***************  XTIVREG2 SECTION ESTIMATES**************
*******************************************************

* First Model:
* Usual standard errors (assume iid error)
xtivreg2  $y $controls ($x = $instrumentos) if $filter, fe
summarize $y $x $controls if e(sample)
estimates store xtivfe_iid

* Second Model:
* Heteroskedasticity robust standard errors
xtivreg2  $y $controls ($x = $instrumentos) if $filter, fe robust
summarize $y $x $controls if e(sample)
estimates store xtivfe_het

* Third Model:
* Correct panel bootstrap standard errors
*bootstrap "xtreg $y $x $controls if $filter, be i(id)" "_b[$x] _b[_cons]", cluster(id) reps($nreps) level(95)
*matrix xtivfehetbootse = e(se)

******************************************************
************* BEGIN WRITTING OUTPUT TABLE ************
******************************************************
estimates restore xtivfe_iid
scalar table_column = 7

matrix betas = e(b)
matrix stds  = e(V)
matrix table_output[1,table_column ] = betas[1,2]
matrix table_output[2,table_column ] = betas[1,1]
matrix table_output[5,table_column ] = sqrt(stds[1,1])
matrix table_output[6,table_column ] = e(r2)
matrix table_output[7,table_column ] = e(rmse)
matrix table_output[8,table_column ] = e(rss)
matrix table_output[9,table_column ] = e(rss) + e(mss)
matrix table_output[10,table_column] = e(sigma_u)
matrix table_output[13,table_column] = e(N_g)

*matrix table_output[4,table_column ] = xtivfehetbootse[1,1]
estimates restore xtivfe_het
matrix stds  = e(V)
scalar tmpval= sqrt(stds[1,1])
matrix table_output[3,table_column ] = tmpval
******************************************************
*********** END  WRITTING OUTPUT TABLE ***************
******************************************************
