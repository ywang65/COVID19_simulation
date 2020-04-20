generate_family<-function(f_n,f_mean=3.14,f_sd=0.1){
    f_group<-round(rnorm(f_n,f_mean,f_sd))
    i<-1
    family<-matrix(0,nrow=sum(f_group),ncol=sum(f_group))
    for(j in f_group){
        family[i:(i+j-1),i:(i+j-1)]<-1
        i=i+j
        }
    diag(family)<-0
    return(list(matrix=family,num=sum(f_group)))
}
