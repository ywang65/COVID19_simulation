infect<-function(infect_matrix,social_matrix,pt,p_close,isolate_vector,stranger_degree=10,p_symptoms=0.8,
    p_close_infect=0.8,p_stranger_infect=0.6,social_distance=FALSE,social_loss=0.5){
    close_degree<-round((dim(social_matrix)[1]-1)*p_close/2)
    for(i in pt){
        family_nodes<-intersect(which(social_matrix[i,]==1),which(isolate_vector>=0))
        close_nodes<-intersect(which(social_matrix[i,]==2),which(isolate_vector>=0))
        stranger_nodes<-intersect(which(social_matrix[i,]==0),which(isolate_vector>=0))
        stranger_nodes<-stranger_nodes[stranger_nodes!=i]

        close_nodes<-sample(close_nodes,round(min(close_degree,length(close_nodes))*0.1))
        stranger_nodes<-sample(stranger_nodes,min(stranger_degree,length(stranger_nodes)))
        
        family_infect<-rbinom(length(family_nodes),1,p_symptoms)
        close_infect<-rbinom(length(close_nodes), 1, p_close_infect)*rbinom(length(close_nodes),1,p_symptoms)
        stranger_infect<-rbinom(length(stranger_nodes), 1, p_stranger_infect)*rbinom(length(stranger_nodes),1,p_symptoms)
        if(social_distance){
            close_infect<-rep(0,length(close_infect))
            stranger_infect<-stranger_infect*ifelse(runif(length(stranger_nodes), min=0, max=1)>=social_loss,1,0)
        }
        
        infect_matrix[i,family_nodes]<-pmax(family_infect,infect_matrix[i,family_nodes])
        infect_matrix[family_nodes,i]<-pmax(family_infect,infect_matrix[family_nodes,i])
       
        infect_matrix[i,close_nodes]<-pmax(close_infect,infect_matrix[i,close_nodes])
        infect_matrix[close_nodes,i]<-pmax(close_infect,infect_matrix[close_nodes,i])
        
        infect_matrix[i,stranger_nodes]<-pmax(stranger_infect,infect_matrix[i,stranger_nodes])
        infect_matrix[stranger_nodes,i]<-pmax(stranger_infect,infect_matrix[stranger_nodes,i])
    }
    return(infect_matrix)
}
