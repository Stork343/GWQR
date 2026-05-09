# N: the total number of samples
# T: the number of time stamps 
# T.lag: the given number of time stamps involved in estimation
# loop: the number of replications

N<-3600; T<-8; T.lag <- 5; loop <-100
u<-(seq(1:N)-1)%%sqrt(N)/(sqrt(N)-1)
v<-(seq(1:N)-1)%/%sqrt(N)/(sqrt(N)-1)
t<-(seq(1:N)-1)%%T 
beta0 <- 4;
beta1 <-(u+v)*exp(t/10)
beta2 <-2+ 2*sin(pi*u*exp(t/4))
beta_true=cbind(beta0,beta1,beta2)


# get the time stamp with corresponding index of the temporal variable (obs.tv)
obs.u <- u;  obs.v <- v;  obs.tv <- t
tv.fac <- as.factor(obs.tv)
obs.ts <- as(sort(levels(tv.fac)), class(obs.tv))
ts.n <- length(obs.ts)
obs.ts.idx <- c()
for(i in obs.tv)
{obs.ts.idx <- c(obs.ts.idx, which(obs.ts==i))
}

# reordering data by their time stamps for estimation
Bs0 <- seq(0.01,1,by=0.03) 
Bt0 <- list()
r.idx <- list();  r.n <- c()
r.u <- list(); r.v <- list(); r.t <- list() 
r.beta <- list()
rn.idx <- list();  rn.n <- c()
rn.u <- list(); rn.v <- list(); rn.t <- list()
rn.beta <- list()
rn.idx_l <- list()
sd.mat_rn <- list();  td.mat_rn <- list()

for(r.ti in 1:length(obs.ts)){
  t.lag <- T.lag;  
  if(r.ti < T.lag){ t.lag <- r.ti}
  Bt0[[r.ti]] <- seq(1, (t.lag-1)); Bt0[[1]] <- 1
  rsts_r.idx <- get_dataidx(ti=obs.ts[r.ti],ts=obs.ts, ts.idx=obs.ts.idx, time.lag=t.lag)
  r.idx[[r.ti]]<- rsts_r.idx$r.idx;  r.n[r.ti] <- length(r.idx[[r.ti]]) 
  r.u[[r.ti]] <- obs.u[r.idx[[r.ti]]];  r.v[[r.ti]] <- obs.v[r.idx[[r.ti]]];  r.t[[r.ti]] <-obs.tv[r.idx[[r.ti]]]
  r.beta[[r.ti]] <- beta_true[r.idx[[r.ti]],]
  rn.idx[[r.ti]] <- rsts_r.idx$rn.idx;   rn.n[r.ti] <- length(rn.idx[[r.ti]]);
  rn.u[[r.ti]] <- obs.u[rn.idx[[r.ti]]];  rn.v[[r.ti]] <- obs.v[rn.idx[[r.ti]]];  rn.t[[r.ti]] <-obs.tv[rn.idx[[r.ti]]]
  rn.beta[[r.ti]] <- beta_true[rn.idx[[r.ti]],] 
  rn.idx_l[[r.ti]] <- rsts_r.idx$rn.idx_l
  sd.mat_rn[[r.ti]] = get_sd.mat(rn.u[[r.ti]], rn.v[[r.ti]])
  td.mat_rn[[r.ti]] <- get_td.vec(ti = obs.ts[r.ti], ts=obs.ts, ts.idx=obs.ts.idx, time.lag=t.lag)
  t.lag <- T.lag
}

