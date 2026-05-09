
N<-3600; T<-8; T.lag <- 5; loop <-100
u<-(seq(1:N)-1)%%sqrt(N)/(sqrt(N)-1)
v<-(seq(1:N)-1)%/%sqrt(N)/(sqrt(N)-1)
t<-(seq(1:N)-1)%%T 
beta0 <- 4;
beta1 <- (u+v)*exp(t/10)
beta2 <- 2+ 2*sin(pi*u*exp(t/4))
beta_true=cbind(beta0,beta1,beta2)

data_all=list()
if (!exists("generated_data_dir")) {
  generated_data_dir <- file.path(getwd(), "generated_data")
}
dir.create(generated_data_dir, recursive = TRUE, showWarnings = FALSE)

for(l in 1:loop){
  seed<-123456789+10*l
  X0_simu<-rep(1,N)
  set.seed(seed+1); X1_simu<-runif(N,0,1)
  set.seed(seed+2); X2_simu<-runif(N,0,1)
  set.seed(seed+3); EPS=rnorm(N,0,1)
  X<-cbind(X0_simu,X1_simu,X2_simu)
  Y<-beta0*X0_simu+beta1*X1_simu+beta2*X2_simu+EPS
  data_all[[l]]<-cbind(u,v,t,Y,X,EPS)
  name = paste0("data_N=", N, "_test", l, ".csv")
  road_file <- file.path(generated_data_dir, name)
  write.csv(data_all[[l]],road_file)
  
}
