# get_sd.mat: function of spatial distance matrix  
# get_td.vec: function of temporal distance vector
# get_dataidx: function to reorder data involved in estimation 

get_sd.mat <- function(u,v){
  sd.mat <- matrix(NA,ncol=length(u),nrow=length(u))
  for (i in 1:length(u)){
    sd.mat[,i]<-sqrt((u-u[i])^2+(v-v[i])^2)}
  return(sd.mat)
}


get_td.vec <- function(ti, ts, ts.idx, time.lag){
  r.ts <- which(ts == ti) 
  tsi <- r.ts  
  td.vec <- c()
  while(tsi > 0 && (ti - ts[tsi]) < time.lag){
    td.vec <- c(td.vec, rep((r.ts-tsi),length( which(ts.idx== tsi))))
    tsi <- tsi-1
  }
  return(td.vec)
}


get_dataidx <- function(ti, ts, ts.idx, time.lag){
  r.ts <- which(ts == ti) 
  r.idx <- which(ts.idx== r.ts)
  tsi <- r.ts; 
  ti.tlag <- c(); rn.idx <- c(); rn.idx_l <- list()
  while(tsi>0 && (ti - ts[tsi])<time.lag)
  {
    ti.tlag <- c(ti.tlag,ts[tsi])
    rn.idx_l[[(r.ts-tsi+1)]] <- length(rn.idx)+c(1:length(which(ts.idx== tsi)))
    rn.idx <- c(rn.idx, which(ts.idx== tsi))
    tsi <- tsi-1
  }
  results <- list(ti.tlag=ti.tlag, r.idx=r.idx, rn.idx=rn.idx, rn.idx_l = rn.idx_l)
  results
}


