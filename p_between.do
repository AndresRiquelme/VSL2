*******************************************************
***************  BETWEEN ESTIMATION  ******************
*******************************************************

* First Model:
* Usual standard errors (assume iid error)
xtreg $y $x $controls if $filter, be i(id)
estimates store beiid

* Second Model:
* Heteroskedasticity robust standard errors
xtreg $y $x $controls if $filter, be vce(bootstrap, reps($nreps))
estimates store be_het

* Third Model:
* Correct panel bootstrap standard errors
*bootstrap "xtreg $y $x $controls if $filter, be i(id)" "_b[$x] _b[_cons]", cluster(id) reps($nreps) level(95)
*matrix bebootse = e(se)

******************************************************
************* BEGIN WRITTING OUTPUT TABLE ************
*********************** BETWEEN **********************
estimates restore beiid
scalar table_column = 2
matrix betas = e(b)
matrix stds  = e(V)
matrix table_output[1,table_column ] = betas[1,2]
matrix table_output[2,table_column ] = betas[1,1]
matrix table_output[5,table_column ] = sqrt(stds[1,1])
matrix table_output[6,table_column ] = e(r2)
matrix table_output[7,table_column ] = e(rmse)
matrix table_output[8,table_column ] = e(rss)
matrix table_output[9,table_column ] = e(rss) + e(mss)
matrix table_output[13,table_column] = e(N_g)

*matrix table_output[4,table_column ] = bebootse[1,1]
estimates restore be_het
matrix stds  = e(V)
scalar tmpval= sqrt(stds[1,1])
matrix table_output[3,table_column ] = tmpval
******************************************************
*********** END  WRITTING OUTPUT TABLE ***************
******************************************************
