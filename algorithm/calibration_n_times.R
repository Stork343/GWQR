# calibrating UGTWR and MUGTWR for N replications
# bs.UGT: averaged spatial bandwidths from UGTWR in N replications
# bt.UGT: averaged  temporal bandwidths from UGTWR in N replications
# beta.UGT: averaged coefficient estimates from UGTWR in N replications
# bs.MUGT: averaged spatial bandwidths from MUGTWR in N replications
# bt.MUGT: averaged  temporal bandwidths from MUGTWR in N replications
# beta.MUGT: averaged coefficient estimates from MUGTWR in N replications

bs_GTall<-matrix(NA,ncol=T,nrow=loop)
bt_GTall<-matrix(NA,ncol=T,nrow=loop)
beta_GTall<-list()
beta.UGT<-matrix(NA,ncol=ncol(beta_true),nrow=N)
RSS.UGT <-c(); SST.UGT<-c(); R2.UGT<-c()

bs_MAall<-list();bt_MAall<-list();beta_MAall<-list();
bs.MUGT<-matrix(NA,ncol=ncol(beta_true),nrow=T)
bt.MUGT<-matrix(NA,ncol=ncol(beta_true),nrow=T)
beta.MUGT<-matrix(NA,ncol=ncol(beta_true),nrow=N)
RSS.MUGT <-c(); SST.MUGT<-c(); R2.MUGT<-c()

if (!exists("generated_data_dir")) {
  generated_data_dir <- file.path(getwd(), "generated_data")
}
if (!exists("results_root")) {
  results_root <- file.path(getwd(), "results")
}
dir.create(generated_data_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(results_root, recursive = TRUE, showWarnings = FALSE)

for(l in 1:loop){
  # read the existing data 
  name = paste0("data_N=", N, "_test", l, ".csv")
  road_file <- file.path(generated_data_dir, name)
  data_test<-read.csv(road_file,sep=",");data_test<-as.matrix(data_test)[,-1]
  u<-data_test[,1]; v<-data_test[,2]; t<-data_test[,3]
  Y<-data_test[,4]; X<-data_test[,5:7]; EPS<-data_test[,8]

  rn.x <- list();  rn.y <- list()
  for(r.ti in 1:length(obs.ts)){
    rn.x[[r.ti]] <- X[rn.idx[[r.ti]],]
    rn.y[[r.ti]] <- Y[rn.idx[[r.ti]]]
  }
  
  # calibrating UGTWR once
  out_st0<-UGTWR_st(rn.x, rn.y,r.n,Bs0,sd.mat_rn,Bt0,td.mat_rn,r.idx,rn.idx_l)
  bs_GT_one<-out_st0$bs_opt; bt_GT_one<-out_st0$bt_opt; beta_GT_one<-out_st0$beta_all
  bs_GTall[l,]<-bs_GT_one; bt_GTall[l,]<-bt_GT_one;
  beta_GTall[[l]]<-beta_GT_one
  Y.UGT <- rowSums(beta_GT_one*X)
  
  SST.UGT[l] <- sum((Y- mean(Y))^2)
  RSS.UGT[l] <- sum((Y-Y.UGT)^2)
  R2.UGT[l] <- 1- RSS.UGT[l]/SST.UGT[l]

  # calibrating MUGTWR once
  beta_GTc=beta_GT_one
  beta_MUGT_one<-matrix(NA,ncol=ncol(X),nrow=nrow(X)) 
  bt_MUGT_one<-matrix(NA,ncol=ncol(X),nrow=T)
  bs_MUGT_one<-matrix(NA,ncol=ncol(X),nrow=T)
  for(r.ts in 1:length(obs.ts)){
    beta_GT<-beta_GTc[rn.idx[[r.ts]],]
    out_Bf<-MUGTWR_st(Xus=rn.x[[r.ts]],yus=rn.y[[r.ts]],beta_Gf=beta_GT, 
                      n=r.n[r.ts],Bs=Bs0,ds<-sd.mat_rn[[r.ts]],Bt=Bt0[[r.ts]],
                      dt=td.mat_rn[[r.ts]],r.ts=r.ts)
    betaBf<-out_Bf$beta_Bf
    bt_MUGT_one[r.ts,]<-out_Bf$bt_optMA 
    bs_MUGT_one[r.ts,]<-out_Bf$bs_optMA 
    beta_MUGT_one[r.idx[[r.ts]],]<-out_Bf$beta_Bf
    beta_GTc[r.idx[[r.ts]],]<-out_Bf$beta_Bf 
  }
  bt_MUGT_one[1,]<-0
  bs_MAall[[l]]<-bs_MUGT_one; bt_MAall[[l]]<-bt_MUGT_one; beta_MAall[[l]]<-beta_MUGT_one
  Y.MUGT <-rowSums(beta_MUGT_one*X)
  
  SST.MUGT[l] <- sum((Y- mean(Y))^2)
  RSS.MUGT[l] <- sum((Y-Y.MUGT)^2)
  R2.MUGT[l] <- 1- RSS.MUGT[l]/SST.MUGT[l]
}

bs.UGT<-colMeans(bs_GTall);  bt.UGT<-colMeans(bt_GTall)
for(i in 1: ncol(beta_true)){
  beta.UGT[,i]<-rowMeans(sapply(beta_GTall,function(x){ x[,i]}))
  bs.MUGT[,i]<-rowMeans(sapply(bs_MAall,function(x){ x[,i]}))
  bt.MUGT[,i]<-rowMeans(sapply(bt_MAall,function(x){ x[,i]}))
  beta.MUGT[,i]<-rowMeans(sapply(beta_MAall,function(x){ x[,i]}))
}

#results of UGTWR & MUGTWR
beta.UGT.l <- list()
RMSE.UGT <- matrix(NA, ncol =ncol(beta_true),nrow =N)
beta.MUGT.l <- list()
RMSE.MUGT <- matrix(NA, ncol =ncol(beta_true),nrow =N)

for(j in 1: ncol(beta_true)){
  beta.UGT.l[[j]] <-sapply(beta_GTall,function(x){ x[,j]})
  beta.MUGT.l[[j]] <-sapply(beta_MAall,function(x){ x[,j]})
  for(i in 1:N){
    RMSE.UGT[i,j] <- sqrt(mean((beta.UGT.l[[j]][i,]-beta_true[i,j])^2))
    RMSE.MUGT[i,j] <- sqrt(mean((beta.MUGT.l[[j]][i,]-beta_true[i,j])^2))
  }
}

ARMSE.UGT <- colMeans(RMSE.UGT)
ARSS.UGT <- mean(RSS.UGT)
AR2.UGT <- mean(R2.UGT)

ARMSE.MUGT <- colMeans(RMSE.MUGT)
ARSS.MUGT <- mean(RSS.MUGT)
AR2.MUGT <- mean(R2.MUGT)

t.record <- format(Sys.time(), "%m-%d-%H")
folder <- file.path(results_root, paste0("result_", t.record, "_UGT_N=", N))
dir.create(folder, recursive = TRUE, showWarnings = FALSE)

write.table(ARMSE.UGT,file.path(folder, paste0("N=",N,"_ARMSE.UGT.txt")),sep="\t")
write.table(ARSS.UGT,file.path(folder, paste0("N=",N,"_ARSS.UGT.txt")),sep="\t")
write.table(AR2.UGT,file.path(folder, paste0("N=",N,"_AR2.UGT.txt")),sep="\t")
bs.UGT <- t(sapply(bs.UGT, "[", i = 1:max(sapply(bs.UGT, length))))
write.table(bs.UGT,file.path(folder, paste0("N=",N,"_bs.UGT.txt")),sep="\t")
write.table(bt.UGT,file.path(folder, paste0("N=",N,"_bt.UGT.txt")),sep="\t")
write.csv(beta.UGT,file.path(folder, paste0("N=",N,"_beta.UGT.csv")))

write.table(ARMSE.MUGT,file.path(folder, paste0("N=",N,"_ARMSE.MUGT.txt")),sep="\t")
write.table(ARSS.MUGT,file.path(folder, paste0("N=",N,"_ARSS.MUGT.txt")),sep="\t")
write.table(AR2.MUGT,file.path(folder, paste0("N=",N,"_AR2.MUGT.txt")),sep="\t")
write.table(bs.MUGT,file.path(folder, paste0("N=",N,"_bs.MUGT.txt")),sep="\t")
write.table(bt.MUGT,file.path(folder, paste0("N=",N,"_bt.MUGT.txt")),sep="\t")
write.csv(beta.MUGT,file.path(folder, paste0("N=",N,"_beta.MUGT.csv")))


