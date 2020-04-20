quarantine<-function(pt_vector,isolate_vector,start_day=3,mild_end_day=14,severe_end_day=21,severe_rate=0.2,fatality_rate=0.04){
    pt_list<-which(pt_vector!=0)
    if(length(pt_list)==0){
      
    }else{
        for(pt in pt_list){
            if(pt_vector[pt]==start_day)
                  isolate_vector[pt]<--1 #isolation
            if(pt_vector[pt]==mild_end_day && runif(1, min=0, max=1)>=severe_rate){
                  isolate_vector[pt]<-1 #heal
                  pt_vector[pt]<--1
            }
            if(pt_vector[pt]==severe_end_day){
                if(runif(1, min=0, max=1)>=fatality_rate){
                    isolate_vector[pt]<-1 #heal
                    pt_vector[pt]<--1
                }else{
                isolate_vector[pt]<--2 #death
                pt_vector[pt]<--1
                }
            }
        }
    }
    return(list(pt_vector=pt_vector,isolate_vector=isolate_vector))
}
