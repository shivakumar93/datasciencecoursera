library(reshape2)
filename<-"getdata_har.zip"
#download and unzip the zip file
if(!file.exists(filename)){
  URL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, filename,mode="wb")
}
#unzips the zip file
if(!file.exists("UCI Har Dataset")){
  unzip(filename)
}
#subset only the mean and std variables 
activity_labels<-read.table("UCI Har Dataset/activity_labels.txt")
features<-read.table("UCI Har Dataset/features.txt")
features[,2]<-as.character(features[,2])
featuresReq<-grep(".*mean.*|.*std.*",features[,2])
featuresReq.Variables<-features[featuresReq,2]
featuresReq.Variables <- gsub('-mean', '-MEAN-', featuresReq.Variables)
featuresReq.Variables <- gsub("-std","-STD-",featuresReq.Variables)
featuresReq.Variables <- gsub("[-()]","",featuresReq.Variables)
featuresReq.Variables<-gsub("^f","frequency",featuresReq.Variables)
featuresReq.Variables<-gsub("Gyro","Gyroscope",featuresReq.Variables)
featuresReq.Variables<-gsub("Acc","Accelerometer",featuresReq.Variables)
featuresReq.Variables<-gsub("Mag","Magnitude",featuresReq.Variables)
featuresReq.Variables<-gsub("BodyBody","Body",featuresReq.Variables)
featuresReq.Variables<-gsub("X","-Xaxis",featuresReq.Variables)
featuresReq.Variables<-gsub("Y","-Yaxis",featuresReq.Variables)
featuresReq.Variables<-gsub("Z","-Zaxis",featuresReq.Variables)
featuresReq.Variables<-gsub("^t","time",featuresReq.Variables)
featuresReq.Variables<-gsub("Freq","Frequency",featuresReq.Variables)







#load the train test data set
trainSubID<-read.table("UCI HAR Dataset/train/subject_train.txt")
trainactlabels<-read.table("UCI HAR Dataset/train/y_train.txt")
trainx<-read.table("UCI HAR Dataset/train/X_train.txt")[featuresReq]


#merge the train data columns
traindata<-cbind(trainSubID,trainactlabels,trainx)

#load the test data set
testSubID<-read.table("UCI HAR Dataset/test/subject_test.txt")
testactlabels<-read.table("UCI HAR Dataset/test/y_test.txt")
testx<-read.table("UCI HAR Dataset/test/X_test.txt")[featuresReq]

#merge test data columns
testdata<-cbind(testSubID,testactlabels,testx)

#merge testdata and traindata into a single table
MergedData<-rbind(traindata,testdata)

#rename columns of MergedData into descriptive variable names
colnames(MergedData)<-c("SubjectID","Activity",featuresReq.Variables)

#make SubjectID and Activity into factors for melting and casting
MergedData$SubjectID<-as.factor(MergedData$SubjectID)
MergedData$Activity <-factor(MergedData$Activity, levels= activity_labels[,1], labels=activity_labels[,2])
MeltedData<-melt(MergedData, id.vars=c("SubjectID","Activity"))
CastedData<-dcast(MeltedData, SubjectID + Activity ~ variable,mean)

#creation of  independent tidy data set with the average of each variable for each activity and each subject
write.table(CastedData, "Tidy-Data.txt", row.names = F)