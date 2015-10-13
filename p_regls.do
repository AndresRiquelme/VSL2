***************************************************
************** EFFECTS GLS REGRESSION *************
***************************************************

* First Regression
* Usual standard errors (assume iid error)
xtreg $y $x $controls if $filter, re i(id)
estimates store reglsiid

* Second Regression
* Correct panel robust standard errors
xtreg $y $x $controls if $filter, re vce(robust)
estimates store reglsrob

* Third Regression
* Correct panel bootstrap standard errors
*bootstrap "xtreg $y $x  $controls if $filter, re i(id)" "_b[$x] _b[_cons]", cluster(id) reps($nreps) level(95)
*matrix reglsbootse = e(se)

*********** BEGIN WRITTING OUTPUT TABLE *************
**************** RANDOM EFFECTS GLS *****************
estimates restore reglsiid
scalar table_column = 5
matrix betas = e(b)
matrix stds  = e(V)
matrix table_output[1,table_column ] = betas[1,2]
matrix table_output[2,table_column ] = betas[1,1]
matrix table_output[5,table_column ] = sqrt(stds[1,1])
matrix table_output[6,table_column ] = e(r2_o)
matrix table_output[7,table_column ] = e(rmse)
* Calculate RSS
predict yhat
gen err = $y - yhat
summarize err
scalar meanerr = r(mean)
gen errsq = (err - meanerr)^2
summarize errsq
scalar rss_temp = r(sum)
drop yhat err errsq
matrix table_output[8,table_column ] = rss_temp
* Calculate TSS
summarize y
scalar meany = r(mean)
gen ydemeansq = ($y - meany)^2
summarize ydemeansq
scalar tss_temp = r(sum)
drop ydemeansq
matrix table_output[9,table_column ] = tss_temp
matrix table_output[10,table_column ] = e(sigma_u)
matrix table_output[11,table_column ] = e(sigma_e)
*matrix table_output[12,table_column ] = e(theta)
matrix table_output[13,table_column ] = e(N_g)
*matrix table_output[4,table_column ] = reglsbootse[1,1]

estimates restore reglsrob
matrix stds  = e(V)
matrix table_output[3,table_column ] = sqrt(stds[1,1])
******************************************************
*********** END  WRITTING OUTPUT TABLE ***************
******************************************************
