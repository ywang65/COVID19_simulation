social_conn<-function(f_n,p_close,...){
    my_family<-generate_family(f_n,...)
    n<-my_family$num
    net<- matrix(0, n, n)
    net[upper.tri(net, diag=FALSE)]<-sample(c(0,2),n*(n-1)/2,replace=TRUE,c(1-p_close,p_close))
    net<-net+t(net)
    net<-(1-(my_family$matrix==1))*net+my_family$matrix
    return(net)
}
