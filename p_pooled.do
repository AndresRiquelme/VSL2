*************************************************************
*************** Estimate POOLED REGRESSION ******************
*************************************************************


* First Model:
* Wrong formula OLS standard errors (require e_it is i.i.d.)
regress $y $x $controls if $filter
estimates store polsiid

* Second Model:
* Wrong White heteroskesdastic-consistent standard errors 
* Assume standard errors (require e_it is independent over i)
regress $y $x  $controls if $filter, robust
estimates store polshet

* Third Model
* Correct panel robust standard errors
regress $y $x  $controls if $filter, cluster(id)
estimates store polspanel 

* Fourth Model
* Correct panel bootstrap standard errors
* Note that use cluster option so that bootstrap is over just i and not both i and t

*bs "regress $y $x $controls if $filter" "_b[$x] _b[_cons]", cluster(id) reps($nreps) level(95)
*matrix polsbootse = e(se)


****************************************************
*********** BEGIN WRITTING OUTPUT TABLE ************
*********************POOLED*************************
estimates restore polsiid
scalar table_column = 1
matrix betas = e(b)
matrix stds  = e(V)
matrix table_output[1,table_column ] = betas[1,2]
matrix table_output[2,table_column ] = betas[1,1]
*matrix table_output[4,table_column ] = polsbootse[1,1]
matrix table_output[5,table_column ] = sqrt(stds[1,1])   
matrix table_output[6,table_column ] = e(r2)
matrix table_output[7,table_column ] = e(rmse)
matrix table_output[8,table_column ] = e(rss)
matrix table_output[9,table_column ] = e(rss) + e(mss)

matrix table_output[11,table_column ] = e(rmse)

matrix table_output[13,table_column ] = e(N)

estimates restore polspanel
matrix stds  = e(V)
matrix table_output[3,table_column ] = sqrt(stds[1,1])
******************************************************
*********** END  WRITTING OUTPUT TABLE ***************
******************************************************

