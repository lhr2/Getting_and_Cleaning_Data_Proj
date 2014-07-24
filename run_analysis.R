## set working directory of file location
setwd("C:\\Courses\\Getting_and_Cleaning_Data")

## read in the files needed
testx = read.table("UCI HAR Dataset/test/X_test.txt")
testy = read.table("UCI HAR Dataset/test/y_test.txt")

trainx = read.table("UCI HAR Dataset/train/X_train.txt")
trainy = read.table("UCI HAR Dataset/train/y_train.txt")

test_sub = read.table("UCI HAR Dataset/test/subject_test.txt")
train_sub = read.table("UCI HAR Dataset/train/subject_train.txt")

features = read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
labels = read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)

## create one data set of test/train files
df = rbind(cbind(test_sub,testy,testx),cbind(train_sub,trainy,trainx))

## set column names
colnames(df) = c("subject","activity",features[[2]])

## get mean and standard dev columns
data_points = df[,grep("(^activity$)|(^subject$)|(mean[(][)])|(std[(][)])",names(df))]

## change names to be more readable
names(data_points) = gsub("[-()]","",names(data_points))
names(data_points) = sub("^f","Freq_",names(data_points))
names(data_points) = sub("^t","Time_",names(data_points))
names(data_points) = sub("mean","_Mean",names(data_points))
names(data_points) = sub("std","_StdDev",names(data_points))
names(data_points) = sub("BodyBody","Body",names(data_points))

## Uses descriptive activity names to name the activities in the data set.
df$activity = labels[[2]][df$activity]

## create new dataset with averages
library("plyr")
df2 = ddply(data_points,.(subject, activity),numcolwise(mean))
df2$activity = labels[[2]][df2$activity]
write.table(df2, file="Project2_Results.txt",row.names=FALSE)