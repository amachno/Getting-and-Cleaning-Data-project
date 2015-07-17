#set working directory to directory in which is directory "UCI HAR Dataset"

# import test data
test.object <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject" )
test.activity <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Class")
test.data <- read.table("UCI HAR Dataset/test/X_test.txt")

# import train data
train.object <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject" )
train.activity <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Class")
train.data <- read.table("UCI HAR Dataset/train/X_train.txt")

# import features descriptions 
description <- read.table ( "UCI HAR Dataset/features.txt" , col.names = c ( "Column", "Description"), stringsAsFactors=FALSE )[,2]

# add names of columns
colnames(test.data)<-description
colnames(train.data)<-description

# add subjectt numbers and activities
train.data<-cbind(train.object,train.activity,train.data)
test.data<-cbind(test.object,test.activity,test.data)

# bind test and train data
data<-rbind(train.data, test.data)
names(data[2])<- 'Activity'

# extract data of mean and std
data<-data[, c(1,2,2+grep('mean\\(\\)|std\\(\\)', description))]


