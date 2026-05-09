# UGTWR_pro & UGTWR_st: functions of UGTWR estimation  
# MUGTWR_st: function of MUGTWR estimation

UGTWR_pro<-function(Xp,yp,n,h,ds,bt,dt){
  beta<-matrix(0,ncol=ncol(Xp),nrow=n) 
  h<-round(length(yp)*h)
  for (i in 1:n){
    kh=sort(ds[i,])[h]         
    oh=order(ds[i,])[1:h] 
    if(kh ==0){
      w_h<-exp(-(dt[oh]/bt)^2)
    } else{
      w_h<-exp(-(ds[i,oh]/kh)^2)*exp(-(dt[oh]/bt)^2)
    }
    p=t(Xp[oh,]*w_h)  
    if (length(oh)==1){
      p<-t(p) 
    }
    beta[i,]=solve(p%*%Xp[oh,],tol = 1e-25)%*%p%*%yp[oh]
  }
  return(beta)
}


UGTWR_st <- function(rn.x, rn.y,r.n,Bs0,sd.mat_rn,Bt0,td.mat_rn,r.idx,rn.idx_l){
  bt_opt <-c();bs_opt <-c();AIC_opt <-c()
  beta_all <- matrix(0,ncol=ncol(beta_true),nrow=N) 
  r.beta_ts <- list()
  for(r.ts in 1:length(obs.ts)){
    out_st <- AIC_bt(Xu=rn.x[[r.ts]],yu = rn.y[[r.ts]],n=r.n[r.ts],Bs=Bs0,
                     ds= sd.mat_rn[[r.ts]],Bt =Bt0[[r.ts]],dt=td.mat_rn[[r.ts]],r.ts=r.ts)
    bt_opt[r.ts] <- out_st$bt_opt
    bs_opt[r.ts] <- out_st$bs_opt
    AIC_opt[r.ts] <- out_st$AIC_opt
    beta_all[r.idx[[r.ts]],] <- r.beta_ts[[r.ts]] <- UGTWR_pro(Xp =rn.x[[r.ts]],yp=rn.y[[r.ts]],
                                                               n=r.n[r.ts],h=bs_opt[r.ts],ds=sd.mat_rn[[r.ts]],
                                                               bt=bt_opt[r.ts],dt=td.mat_rn[[r.ts]])
  }
  bt_opt[1]<-0
  return(list(beta_all=beta_all,bs_opt=bs_opt,bt_opt=bt_opt,AIC_opt=AIC_opt ))
}


MUGTWR_st<-function(Xus,yus,beta_Gf,n,Bs,ds,Bt,dt,r.ts){
  beta_singlek<-matrix(NA,ncol=ncol(Xus),nrow=n)
  bs_optsk=matrix(NA,ncol=ncol(Xus),nrow=15)
  bt_optsk=matrix(NA,ncol=ncol(Xus),nrow=15)
  AIC_optsk=matrix(NA,ncol=ncol(Xus),nrow=15)
  f=matrix(NA,ncol=ncol(Xus),nrow=length(yus))
  Yf<-matrix(NA,ncol=ncol(Xus),nrow=length(yus))
  SOCF<-numeric(15)
  SOCf<-10000
  k<-0
  while(SOCf>0.001){
    if(k>=10){
      break
    }  
    k<-k+1
    beta_old<-beta_Gf
    for(m in 1:ncol(Xus)){
      f<-beta_Gf*Xus  
      Yf[,m]<-yus-rowSums(f[,-m])   
      out_st=AIC_bt(Xu<-matrix(Xus[,m]),yu<-Yf[,m],n,Bs,ds,Bt=Bt,dt,r.ts)
      bt_optsk[k,m]=out_st$bt_opt; bs_optsk[k,m]=out_st$bs_opt; AIC_optsk[k,m]=out_st$AIC_opt
      beta_singlek[,m]<-UGTWR_pro(Xp<-matrix(Xus[,m]),yp<-Yf[,m],n,h<-bs_optsk[k,m],ds,bt<-bt_optsk[k,m],dt)
      beta_Gf[1:n,m]=beta_singlek[,m]
      f[,m]<-beta_Gf[,m]*Xus[,m]
    }
    beta_new<-beta_Gf
    SOC_1<-0
    for(j in 1:ncol(Xus)){
      SOC_1<-SOC_1+(1/n)*sum((f[1:n,j]-beta_old[1:n,j]*Xus[1:n,j])^2) 
    }
    SOC_2<-sum((rowSums(f[1:n,]))^2)
    SOCf<-sqrt(SOC_1/SOC_2)
    SOCF[k]<-SOCf
  }
  if(k>10){
    k=k-1
  }
  bt_optMA<-bt_optsk[k,]; bs_optMA<-bs_optsk[k,]; 
  beta_Bf<-beta_new[1:n,];AIC_optMA <-AIC_optsk[k,]
  return(list(bt_optMA=bt_optMA, bs_optMA=bs_optMA, beta_Bf=beta_Bf, AIC_optMA=AIC_optMA))
}

