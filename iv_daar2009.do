*******************************************************
***************  CROSS SECTION ESTIMATES **************
***************       IV REGRESSION                   *
*******************************************************

* First Model:
* Usual standard errors (assume iid error)
ivregress 2sls $y $controls ($x = $risk $instrumentos) if $filter & year==2009
estimates store ivrisk_iid

* Second Model:
* Heteroskedasticity robust standard errors
ivregress 2sls $y $controls ($x = $risk $instrumentos) if $filter & year==2009, vce(robust)
estimates store ivrisk_het

* Third Model:
* Correct panel bootstrap standard errors
*bootstrap "xtreg $y $x $controls if $filter, be i(id)" "_b[$x] _b[_cons]", cluster(id) reps($nreps) level(95)
*matrix olsbootse = e(se)

******************************************************
************* BEGIN WRITTING OUTPUT TABLE ************
*********************** BETWEEN **********************
estimates restore ivrisk_iid
scalar table_column = 11

matrix betas = e(b)
matrix stds  = e(V)
matrix table_output[1,table_column ] = betas[1,2]
matrix table_output[2,table_column ] = betas[1,1]
matrix table_output[5,table_column ] = sqrt(stds[1,1])
matrix table_output[6,table_column ] = e(r2)
matrix table_output[7,table_column ] = e(rmse)
matrix table_output[8,table_column ] = e(rss)
matrix table_output[9,table_column ] = e(rss) + e(mss)
matrix table_output[13,table_column] = e(N)

*matrix table_output[4,table_column ] = olsbootse[1,1]
estimates restore ivrisk_het
matrix stds  = e(V)
scalar tmpval= sqrt(stds[1,1])
matrix table_output[3,table_column ] = tmpval
******************************************************
*********** END  WRITTING OUTPUT TABLE ***************
******************************************************
