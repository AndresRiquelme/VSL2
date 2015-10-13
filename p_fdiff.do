************************************************************
*********** FIRST DIFFERENCES ESTIMATION *******************
************************************************************

* First Model
* Usual standard errors assume iid error
regress d.$y d.$x d.($controls) if $filter 
estimates store fdiffiid

* Second Model
* Correct panel robust standard errors
regress d.$y d.$x d.($controls) if $filter,  robust
estimates store fdiffpanel

* Third Model
* "Robust" standard errors only control for heteroskedasticity
regress d.$y d.$x d.($controls) if $filter, cluster(id)
estimates store fdiffhet

* Fourth Model
* Correct panel bootstrap standard errors

*bs "regress d.$y d.$x d.($controls) if $filter" "_b[d.$x] _b[_cons]", reps($nreps) level(95)
*matrix fdiffbootse = e(se)


******************************************************
*********** BEGIN WRITTING OUTPUT TABLE **************
************** FIRST DIFFERENCES *********************
estimates restore fdiffiid
scalar table_column = 4
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

*matrix table_output[4,table_column ] = febootse[1,1]
estimates restore fdiffpanel
matrix stds  = e(V)
matrix table_output[3,table_column ] = sqrt(stds[1,1])
******************************************************
*********** END  WRITTING OUTPUT TABLE ***************
******************************************************
