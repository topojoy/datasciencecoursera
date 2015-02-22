
# code taken from: http://www.r-statistics.com/2012/01/merging-two-data-frame-objects-while-preserving-the-rows-order/
############## function:
merge_with_order <- function(x,y, ..., sort = T, keep_order)
{
  # this function works just like merge, only that it adds the option to return the merged data.frame ordered by x (1) or by y (2)
  add.id.column.to.data <- function(DATA)
  {
    data.frame(DATA, id... = seq_len(nrow(DATA)))
  }
  # add.id.column.to.data(data.frame(x = rnorm(5), x2 = rnorm(5)))
  order.by.id...and.remove.it <- function(DATA)
  {
    # gets in a data.frame with the "id..." column.  Orders by it and returns it
    if(!any(colnames(DATA)=="id...")) stop("The function order.by.id...and.remove.it only works with data.frame objects which includes the 'id...' order column")
    
    ss_r <- order(DATA$id...)
    ss_c <- colnames(DATA) != "id..."
    DATA[ss_r, ss_c]
  }
  
  # tmp <- function(x) x==1; 1	# why we must check what to do if it is missing or not...
  # tmp()
  
  if(!missing(keep_order))
  {
    if(keep_order == 1) return(order.by.id...and.remove.it(merge(x=add.id.column.to.data(x),y=y,..., sort = FALSE)))
    if(keep_order == 2) return(order.by.id...and.remove.it(merge(x=x,y=add.id.column.to.data(y),..., sort = FALSE)))
    # if you didn't get "return" by now - issue a warning.
    warning("The function merge.with.order only accepts NULL/1/2 values for the keep_order variable")
  } else {return(merge(x=x,y=y,..., sort = sort))}
}
clean_data=function(base_path="/home/topojoy/rstudio-0.98.1091/UCI HAR Dataset/",file_path="total_table"){
  features_table=read.table(paste(base_path,"features.txt",sep=""),sep=" ")
  features_table=mutate(features_table,description=as.character(V2))
  test_subject_column=read.table(paste(base_path,"test/subject_test.txt",sep=""),sep=" ")
  test_features=read.table(paste(base_path,"test/X_test.txt",sep=""))
  train_features=read.table(paste(base_path,"train/X_train.txt",sep=""))
  train_outcome=read.table(paste(base_path,"train/y_train.txt",sep=""))
  test_outcome=read.table(paste(base_path,"test/y_test.txt",sep=""))
  train_subject_column=read.table(paste(base_path,"train/subject_train.txt",sep=""),sep=" ")
  activity_column=read.table(paste(base_path,"activity_labels.txt",sep=""))
  desc_test_outcome=merge_with_order(test_outcome,activity_column,keep_order=1)
  mean_std_features_table=features_table[grep("(mean|Mean|std)",features_table$V2),]
  mean_test_features=test_features[,mean_std_features_table$V1]
  mean_train_features=train_features[,mean_std_features_table$V1]
  mean_std_features_table=mutate(mean_std_features_table,columnIndices=paste("V",as.character(V1),sep=""))
  temp_features_column_names=names(mean_test_features)
  temp_features_column_names=data.frame(temp_features_column_names)
  temp_features_column_names=merge_with_order(temp_features_column_names,mean_std_features_table,by.x="temp_features_column_names",by.y="columnIndices",keep_order=1)
  attributes(mean_test_features)$names=temp_features_column_names$description
  attributes(mean_train_features)$names=temp_features_column_names$description
  attributes(test_subject_column)$names=c("SubjectId")
  attributes(train_subject_column)$names=c("SubjectId")
  train_outcome=merge_with_order(train_outcome,activity_column,keep_order=1)
  test_outcome=merge_with_order(test_outcome,activity_column,keep_order=1)
  descriptive_test_outcome=transmute(test_outcome,OutcomeActivity=V2)
  descriptive_train_outcome=transmute(train_outcome,OutcomeActivity=V2)
  train_total_table=cbind(train_subject_column,mean_train_features,descriptive_train_outcome)
  test_total_table=cbind(test_subject_column,mean_test_features,descriptive_test_outcome)
  total_table=rbind(train_total_table,test_total_table)
  write.table(total_table,paste(file_path,".txt",sep=""),row.names=FALSE)
  str(total_table)
}
