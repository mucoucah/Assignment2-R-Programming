library(tidyr)
library(dplyr)

get_data<- function() {
  url<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  
  setwd(Sys.getenv("HOME"))
  destfile<- "./HAR.zip"
  
  if(!file.exists(destfile)){
    download.file(url, destfile)
  }
  
  path<- "./UCI HAR Dataset/test"
  file_names_test<-list.files(path, pattern="_test.txt$", recursive=TRUE, full.names=TRUE)
  if(!dir.exists("./UCI HAR Dataset/full/Inertial Signals/")){
    dir.create("./UCI HAR Dataset/full/Inertial Signals/")
  }
  return(file_names_test)
}

group_data<- function(file_names_test){
  for(i in file_names_test){
    print("reading table 1")
    df<- read.delim(i, header = FALSE, sep = "", dec = ".")
    print("reading table 2")
    j<-gsub("test","train",i)
    df2<- read.delim(j, header = FALSE, sep = "", dec = ".")

    print("binding")
    df <- rbind(df,df2)
    
    print("writing new table")
    k<- gsub("train","full",j)
    k<- gsub(".txt",".csv",k)
    write.csv(df, k)
    
    #print mean and std dev per column transposed so it can be read on screen easier
    View(as.data.frame( t(sapply(df, function(cl) list(mean=mean(cl,na.rm=TRUE), std_dev=sd(cl,na.rm=TRUE))) )))
  }
  View(list.files("./UCI HAR Dataset", recursive=TRUE, full.names=TRUE))
}

row_names_features<- function(){
  features<- read.delim("./UCI HAR Dataset/features.txt", header = FALSE, sep = "", dec = ".", stringsAsFactors=FALSE)
  features$V2<- gsub("(", "", features$V2, fixed=TRUE)
  features$V2<- gsub(")", "", features$V2, fixed=TRUE)
  features$V2<- gsub("-", "_", features$V2, fixed=TRUE)
  features$V2<- gsub(",", "_", features$V2, fixed=TRUE)
  
  features_c<-as.character(unlist(features$V2))
  features_c<- append(features_c, "Activity", after=0)
  return (features_c)
}

load_full_list<- function(){
  path<- "./UCI HAR Dataset/full"
  file_names_full<-list.files(path, recursive=TRUE, full.names=TRUE)
  data_X_Y<-read.csv("./UCI HAR Dataset/full/X_full.csv", stringsAsFactors=FALSE)
  y_df<-read.csv("./UCI HAR Dataset/full/y_full.csv", stringsAsFactors=FALSE)
  data_X_Y$X<- y_df$V1
  key<- read.delim("./UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "", dec = ".", stringsAsFactors=FALSE)
  data_X_Y[["X"]] <- key[ match(data_X_Y[['X']], key[['V1']] ) , 'V2']
  #features_c <- row_names_features()
  #names(data_X_Y) <- features_c
  names(data_X_Y) <- row_names_features()
  names(data_X_Y) <- make.unique(names(data_X_Y), sep="_")
  View(data_X_Y)
  return (data_X_Y)
}



tidy_data <- function(data_X_Y){
  tb2 <- data_X_Y %>% gather(Measurement, Value, tBodyAcc_mean_X:angleZ_gravityMean,na.rm = TRUE)
  
  sum_df <- tb2 %>%   
    group_by(Activity, Measurement) %>%  
    summarize(mean = mean(Value,na.rm=TRUE),   
              std_dev = sd(Value,na.rm=TRUE)) %>% 
    ungroup()
  write.csv(sum_df, "./UCI HAR Dataset/full/tidy_set.csv")
  View(sum_df)
}


# 1. Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
group_data(get_data())

#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names.
data_X_Y <- load_full_list()

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data(data_X_Y)



