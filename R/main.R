library(ergm)
library(statnet)
library(igraph)
library(intergraph)
library(psych)

print('social distancing')
social_matrix <- social_conn(f_n=100,f_sd=1.5,p_close=0.05)
n<-dim(social_matrix)[1]
infect_matrix <- matrix(0,n,n)
pt_vector<-rep(0,n)
p_immune<-0
isolate_vector<-sample(c(0,1),n,replace = T,c(1-p_immune,p_immune))
pt_vector[which(isolate_vector==1)]<--1
pt_initial<-which(pt_vector==-1)
pt<-sample(n,1)
n_day<-5
active_case<-character(0)
recovery<-character(0)
death<-character(0)
total_case<-character(0)
for(i in 1:n_day){
    print(i)
    pt_vector[which(pt_vector>0)]=pt_vector[which(pt_vector>0)]+1 
    infect_matrix<-infect(infect_matrix,social_matrix,pt,p_close=0.05,isolate_vector,social_distance = T,stranger_degree = 10)
    pt<-intersect(which(rowSums(infect_matrix)!=0),which(pt_vector>=0)) #no 2nd time infection
    pt_vector[pt]<-(pt_vector[pt]==0)+pt_vector[pt]
    pt_new<-quarantine(pt_vector,isolate_vector)
    pt_vector<-pt_new$pt_vector
    isolate_vector<-pt_new$isolate_vector
    pt<-pt[!pt %in% union(which(pt_vector==-1),which(isolate_vector==-1))]
    print(paste('total hospitalized numbers:',sum(isolate_vector==-1)))
    active_case<-append(active_case,sum(isolate_vector==-1))
    print(paste('total death numbers:',sum(isolate_vector==-2)))
    death<-append(death,sum(isolate_vector==-2))
    if(length(pt_initial)!=0){
        print(paste('total recovered numbers:',sum(pt_vector[-pt_initial]==-1)))
        recovery<-append(recovery,sum(pt_vector[-pt_initial]==-1))
        print(paste('total infected numbers:',sum(colSums(infect_matrix[-pt_initial,-pt_initial])!=0)))
        total_case<-append(total_case, sum(colSums(infect_matrix[-pt_initial,-pt_initial])!=0))
    }else{
        print(paste('total recovered numbers:',sum(pt_vector==-1)))
        recovery<-append(recovery,sum(pt_vector==-1))
        print(paste('total infected numbers:',sum(colSums(infect_matrix)!=0)))
        total_case<-append(total_case, sum(colSums(infect_matrix)!=0))
    }
}
infect_net <- as.network(x =infect_matrix, directed = F, loops = FALSE, matrix.type = "adjacency")
plot(infect_net, cex.main = 0.8)
