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
names(data)[2]<- 'Activity'

# activities: class numbers and labels
labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c ("Class", "Label") )
data$Activity <- labels$Label[match(data$Activity,labels$Class)]

# extract columns which contain mean and std values -- ignore letter case
measures.mean.index <- grep ( "mean\\(\\)", colnames(data), ignore.case = TRUE )
measures.std.index <- grep ( "std\\(\\)", colnames(data), ignore.case = TRUE)
data.sub <- data[ c ( 1:2, measures.mean.index, measures.std.index ) ]

# reshape2
library (reshape2)

# melt data set
data.sub.melt <- melt(data.sub, id = c ("Subject", "Activity") , measure.vars = c(3:68), variable.name = "Features", value.name = "Signals" )

# dcast by Subject & Activity, drop "Class", derive mean for Signals & adjust variable names appropriately
data.tidy <- dcast (data.sub.melt, Subject + Activity ~ Features, mean, value.var = "Signals")
#save the result
write.table(data.tidy, 'tidy_data.txt', row.names=F)
