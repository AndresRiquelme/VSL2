******************************************************
********** RANDOM EFFECTS MLE REGRESSION *************
******************************************************

* First Regression
* Usual standard errors (assume iid error)
xtreg $y $x $controls if $filter, mle i(id)
estimates store remleiid

* Second Regression
* Correct panel robust standard errors
xtreg $y $x $controls if $filter, mle vce(bootstrap, reps($nreps))
estimates store mlerob

* Third Regression
* Correct panel bootstrap standard errors

*bootstrap "xtreg $y $x $controls if $filter, mle i(id)" "_b[$x] _b[_cons]", cluster(id) reps($nreps) level(95)
*matrix remlebootse = e(se)

* Population averaged is similar to re  (gives similar to mle version of re)
* Exactly same as xtgee, i(id)          //not sure why do this
xtreg $y $x $controls if $filter, pa i(id)
estimates store paiid


*********** BEGIN WRITTING OUTPUT TABLE *************
*************** RANDOM EFFECTS MLE ******************
estimates restore remleiid
scalar table_column = 6
matrix betas = e(b)
matrix stds  = e(V)
matrix table_output[1,table_column ] = betas[1,2]
matrix table_output[2,table_column ] = betas[1,1]
matrix table_output[5,table_column ] = sqrt(stds[1,1])
matrix table_output[6,table_column ] = e(r2_p)
* Calculate RSS
predict yhat
gen err = $y - yhat
summarize err
scalar meanerr = r(mean)
gen errsq = (err - meanerr)^2
summarize errsq
scalar rss_temp = r(sum)
drop err errsq
matrix table_output[8,table_column ] = rss_temp
* Calculate TSS
summarize $y
scalar meany = r(mean)
gen ydemeansq = ($y - meany)^2
summarize ydemeansq
scalar tss_temp = r(sum)
drop ydemeansq
*Calculate RMSE
gen errsq = ($y - yhat)^2
summarize errsq
scalar rmse_temp = sqrt(r(sum)/_N)
matrix table_output[7,table_column ] = rmse_temp
matrix table_output[9,table_column ] = tss_temp
matrix table_output[10,table_column] = e(sigma_u)
matrix table_output[11,table_column] = e(sigma_e)
*matrix table_output[12,table_column] = 1- e(sigma_e)/sqrt(e(sigma_e)^2+e(N)*e(sigma_u)^2)
matrix table_output[13,table_column] = e(N_g)

*matrix table_output[4,table_column ] = remlebootse[1,1]

estimates restore mlerob
matrix stds  = e(V)
matrix table_output[3,table_column ] = sqrt(stds[1,1])
******************************************************
*********** END  WRITTING OUTPUT TABLE ***************
******************************************************
