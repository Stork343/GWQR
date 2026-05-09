#AIC_fun & AIC_bs: functions to find bs_opt using AICc criterion (given a temporal bandwidth (bt) )
# AIC_bt : the function to find bt_opt using AICc criterion
# bt_opt: the optimal temporal bandwidth
# bs_opt: the optimal spatial bandwidth

AIC_fun=function(Xp,yp,n,h,ds,bt,dt){
  ll=numeric(n)
  y_h=numeric(n)
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
    c=solve(p%*%Xp[oh,],tol = 1e-35)%*%p
    if (length(oh)==1){
      c<-t(c) 
    }
    y_h[i]=Xp[i,]%*%c%*%yp[oh]
    ll[i]=Xp[oh[1],]%*%c[,1]
  }
  thegma=(1/n)*sum((yp[1:n]-y_h)^2)
  AIC=log(thegma)+(n+sum(ll))/(n-2-sum(ll))
  return(AIC = AIC)
}


AIC_bs<-function(Xu,yu,n,Bs,ds,bt,dt){
  a<-Bs[1]
  c<-Bs[length(Bs)]
  c1<-a+((sqrt(5)-1)/2)*abs(c-a)
  a1<-c-((sqrt(5)-1)/2)*abs(c-a)
  AIC_c1<-AIC_fun(Xu,yu,n,c1,ds,bt,dt)
  AIC_a1<-AIC_fun(Xu,yu,n,a1,ds,bt,dt)
  iter=0
  AIC_Bs<-numeric()
  sel_h<-numeric()
  max_iter<-500
  while(abs(c-a)>0.001 && iter<max_iter){
    iter <-iter+1
    if(AIC_c1 <= AIC_a1){
      opt_h<-c1
      opt_AIC<-AIC_c1
      a<-a1
      a1<-c1
      AIC_a1<-AIC_c1
      c1<-a+((sqrt(5)-1)/2)*abs(c-a)
      AIC_c1<-AIC_fun(Xu,yu,n,c1,ds,bt,dt)
    } else{
      opt_h<-a1
      opt_AIC<-AIC_a1
      c<-c1
      c1<-a1
      AIC_c1<-AIC_a1
      a1<-c-((sqrt(5)-1)/2)*abs(c-a)
      AIC_a1<-AIC_fun(Xu,yu,n,a1,ds,bt,dt)
    }
    AIC_Bs[iter]<-opt_AIC
    sel_h[iter]<-opt_h
  }
  return(list(opt_AIC = opt_AIC, opt_h = opt_h,sel_h =sel_h))
}


AIC_bt<-function(Xu,yu,n,Bs,ds,Bt,dt,r.ts){
  AIC_Bt<-numeric(length(Bt))
  Bs_Bt<-numeric(length(Bt))
  for(t in 1:length(Bt)){
    bt<-Bt[t]
    out_bs<-AIC_bs(Xu,yu,n,Bs,ds,bt,dt)
    AIC_Bt[t]<-out_bs$opt_AIC
    Bs_Bt[t]<-out_bs$opt_h
  }
  AIC_opt<-AIC_Bt[which.min(AIC_Bt)]
  bt_opt<-Bt[which.min(AIC_Bt)]
  bs_opt<-Bs_Bt[which.min(AIC_Bt)]
  return(list(AIC_opt=AIC_opt,bt_opt=bt_opt,bs_opt=bs_opt))
}
