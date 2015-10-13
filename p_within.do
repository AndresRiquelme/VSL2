*********************** WIHIN ESTIMATION *******************
***************** (FIXED EFFECTS) REGRESSION ***************
************************************************************

* First Model
* Usual wrong standard errors (assume iid error)
xtreg $y $x $controls if $filter, fe i(id)
estimates store feiid

* Second Model
* Correct panel robust standard errors
xtreg $y $x $controls if $filter, fe vce(cluster id)
estimates store ferob

* Third Model
* Correct panel bootstrap standard errors

*bootstrap "xtreg $y $x $xextra if $filter, fe i(id)" "_b[$x] _b[_cons]", cluster(id) reps($nreps) level(95)
*matrix febootse = e(se)

*****************************************************
*********** BEGIN WRITTING OUTPUT TABLE *************
****************** WITHIN ***************************
estimates restore feiid
scalar table_column = 3
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
matrix table_output[11,table_column] = e(sigma_e)
matrix table_output[12,table_column] = 1
matrix table_output[13,table_column] = e(N_g)

*matrix table_output[4,table_column ] = febootse[1,1]
estimates restore ferob
matrix stds  = e(V)
scalar tmpval= sqrt(stds[1,1])
matrix table_output[3,table_column ] = tmpval
******************************************************
*********** END  WRITTING OUTPUT TABLE ***************
******************************************************
