library(ergm)
library(statnet)
library(igraph)
library(intergraph)
library(psych)

print('social distancing')
social_matrix <- social_conn(f_n=1000,f_sd=1.5,p_close=0.05)
n<-dim(social_matrix)[1]
infect_matrix <- matrix(0,n,n)
pt_vector<-rep(0,n)
p_immune<-0.6
isolate_vector<-sample(c(0,1),n,replace = T,c(1-p_immune,p_immune))
pt_vector[which(isolate_vector==1)]<--1
pt_initial<-which(pt_vector==-1)
hospital_burden<-500
fatality_rate<-0.04
pt<-sample(n,10)
n_day<-50
active_case<-numeric(0)
recovery<-numeric(0)
death<-numeric(0)
total_case<-numeric(0)
for(i in 1:n_day){
    print(i)
    pt_vector[which(pt_vector>0)]=pt_vector[which(pt_vector>0)]+1 
    infect_matrix<-infect(infect_matrix,social_matrix,pt,p_close=0.05,isolate_vector,social_distance = T,stranger_degree = 5)
    pt<-intersect(which(rowSums(infect_matrix)!=0),which(pt_vector>=0)) #no 2nd time infection
    pt_vector[pt]<-(pt_vector[pt]==0)+pt_vector[pt]
    pt_new<-quarantine(pt_vector,isolate_vector,fatality_rate = fatality_rate)
    pt_vector<-pt_new$pt_vector
    isolate_vector<-pt_new$isolate_vector
    pt<-pt[!pt %in% union(which(pt_vector==-1),which(isolate_vector==-1))]
    active_case<-append(active_case,sum(isolate_vector==-1))
    print(paste('total hospitalized numbers:',active_case[i]))
    death<-append(death,sum(isolate_vector==-2))
    print(paste('total death numbers:',death[i]))
    fatality_rate=min(fatality_rate*max(1,floor(active_case[i]/hospital_burden)),0.1)
    if(length(pt_initial)!=0){
        recovery<-append(recovery,sum(pt_vector[-pt_initial]==-1))
        print(paste('total recovered numbers:',recovery[i]))
        total_case<-append(total_case, sum(colSums(infect_matrix[-pt_initial,-pt_initial])!=0))
        print(paste('total infected numbers:',total_case[i]))
    }else{
        recovery<-append(recovery,sum(pt_vector==-1))
        print(paste('total recovered numbers:',recovery[i]))
        total_case<-append(total_case, sum(colSums(infect_matrix)!=0))
        print(paste('total infected numbers:',total_case[i]))
    }
}
infect_net <- as.network(x =infect_matrix, directed = F, loops = FALSE, matrix.type = "adjacency")
plot(infect_net, cex.main = 0.8)

plot('n',xlim=c(1,n_day+3),ylim=c(0,n),xlab='day',ylab='number of cases')
lines(active_case,col='blue',lwd=2)
lines(death,col = 'red',lwd=2)
lines(recovery,col = 'green',lwd=2)
lines(total_case,lwd=2)
legend("topright", legend=c('active_case', 'death','recovery','total_case'), 
col=c('blue','red','green','black'), lty = 1, cex=1,,lwd=2)
title('social distancing + 60% population get immunized')
