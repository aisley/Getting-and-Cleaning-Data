#Get the column headers File
CHFile="./Data/UCI HAR Dataset/features.txt"

#Read the Column Headers 2nd column will contain the Columnnames
ColumnHeaders<-read.csv(CHFile, header=FALSE, sep=" ")

#Add 2 new row to the Column Headers for Test Subject and Activity
NewRow<-data.frame(V1=1, V2="TestSubjectId")
NewRow1<-data.frame(V1=1, V2="ActivityID")
NewRow2<-data.frame(V1=1, V2="ActivityDesc")
ColumnHeaders<- rbind(NewRow1, NewRow, ColumnHeaders, NewRow2)

#Create a matrix with the same number of records in the ColumHeader File
temprow <- matrix(c(rep.int(NA,nrow(ColumnHeaders))),nrow=1,ncol=nrow(ColumnHeaders))

#convert the Matric to a DF                  
ColumnNames <- data.frame(temprow)

#Set the Columnnames to the VAlues from the File
colnames(ColumnNames)<-ColumnHeaders$V2

#Clean up teh memory
rm(NewRow)
rm(NewRow1)
rm(NewRow2)
rm(ColumnHeaders)
rm(temprow)
rm(CHFile)

#load the Test File
TrainTestSubjects<-read.table("./data/UCI HAR Dataset/train/subject_train.txt", header=FALSE)
TrainActivity<-read.table("./data/UCI HAR Dataset/train/y_train.txt", header=FALSE)
TrainData<-read.table("./data/UCI HAR Dataset/train/X_train.txt", header=FALSE)
TestTestSubjects<-read.table("./data/UCI HAR Dataset/test/subject_test.txt", header=FALSE)
TestActivity<-read.table("./data/UCI HAR Dataset/test/y_test.txt", header=FALSE)
TestData<-read.table("./data/UCI HAR Dataset/test/X_test.txt", header=FALSE)

#Rename the Activity and TestSubject Columns
colnames(TrainTestSubjects)<-c("TestSubjectID")
colnames(TestTestSubjects)<-c("TestSubjectID")
colnames(TrainActivity)<-c("ActivityID")
colnames(TestActivity)<-c("ActivityID")


#Get the Data set to classify the activity by name
Activity<-read.table("./data/UCI HAR Dataset/activity_labels.txt", header=FALSE)
            

#Cbind the Test Subjects and Activitys to the test and Traing DF
TrainData<-cbind( TrainTestSubjects, TrainActivity, TrainData)
TestData<-cbind( TestTestSubjects, TestActivity, TestData)

#Merge the Activity with the Desc
TrainData<-merge(TrainData, Activity, by.x="ActivityID", by.y="V1", all=TRUE, sort=FALSE)
TestData<-merge(TestData, Activity, by.x="ActivityID", by.y="V1", all=TRUE, sort=FALSE)

#Set the Names to the the Same
names(TrainData) <- names(ColumnNames) 
names(TestData) <- names(ColumnNames) 

#Combine all into a single data set
AllData<-rbind(TestData, TrainData)

#clean up the memory
rm(TestData)
rm(TrainData)
rm(ColumnNames)
rm(TestActivity)
rm(TestTestSubjects)
rm(TrainActivity)
rm(TrainTestSubjects)
rm(Activity)

#Get all the columns we need for the final data Set
FinalData<-AllData[ , grep( "-mean\\(\\)|std|TestSubjectId|ActivityDesc" , names(AllData) ) ]
write.table(FinalData, file="./Getting-and-Cleaning-Data/HumanActivity.txt", col.names=TRUE, row.names = FALSE, sep = " ")


#Get the Measure Names
ColNames<-colnames(AllData[ , grep( "-mean\\(\\)|std" , names(AllData) ) ])

#Melt the data to prepare it for Casting
x<-melt(FinalData, id=c("TestSubjectId", "ActivityDesc"), measure.vars=ColNames)

#Get the Avg
TidyData<-dcast(x, TestSubjectId + ActivityDesc ~ variable, mean)


colnames(TidyData)<- (c("TestSubjectId", "ActivityDesc", "avg_tBodyAcc-mean()-X","avg_tBodyAcc-mean()-Y", "avg_tBodyAcc-mean()-Z", "avg_tBodyAcc-std()-X", "avg_tBodyAcc-std()-Y", "avg_tBodyAcc-std()-Z", "avg_tGravityAcc-mean()-X", "avg_tGravityAcc-mean()-Y", "avg_tGravityAcc-mean()-Z", "avg_tGravityAcc-std()-X", "avg_tGravityAcc-std()-Y", "avg_tGravityAcc-std()-Z", "avg_tBodyAccJerk-mean()-X", "avg_tBodyAccJerk-mean()-Y", "avg_tBodyAccJerk-mean()-Z", "avg_tBodyAccJerk-std()-X", "avg_tBodyAccJerk-std()-Y", "avg_tBodyAccJerk-std()-Z", "avg_tBodyGyro-mean()-X" , "avg_tBodyGyro-mean()-Y", "avg_tBodyGyro-mean()-Z" , "avg_tBodyGyro-std()-X", "avg_tBodyGyro-std()-Y", "avg_tBodyGyro-std()-Z", "avg_tBodyGyroJerk-mean()-X", "avg_tBodyGyroJerk-mean()-Y", "avg_tBodyGyroJerk-mean()-Z", "avg_tBodyGyroJerk-std()-X", "avg_tBodyGyroJerk-std()-Y", "avg_tBodyGyroJerk-std()-Z", "avg_tBodyAccMag-mean()" , "avg_tBodyAccMag-std()", "avg_tGravityAccMag-mean()", "avg_tGravityAccMag-std()", "avg_tBodyAccJerkMag-mean()", "avg_tBodyAccJerkMag-std()", "avg_tBodyGyroMag-mean()", "avg_tBodyGyroMag-std()" , "avg_tBodyGyroJerkMag-mean()", "avg_tBodyGyroJerkMag-std()", "avg_fBodyAcc-mean()-X", "avg_fBodyAcc-mean()-Y", "avg_fBodyAcc-mean()-Z", "avg_fBodyAcc-std()-X" , "avg_fBodyAcc-std()-Y", "avg_fBodyAcc-std()-Z" , "avg_fBodyAccJerk-mean()-X", "avg_fBodyAccJerk-mean()-Y", "avg_fBodyAccJerk-mean()-Z", "avg_fBodyAccJerk-std()-X", "avg_fBodyAccJerk-std()-Y", "avg_ffBodyAccJerk-std()-Z", "avg_ffBodyGyro-mean()-X"  , "avg_ffBodyGyro-mean()-Y"  , "avg_ffBodyGyro-mean()-Z", "avg_fBodyGyro-std()-X", "avg_fBodyGyro-std()-Y", "avg_fBodyGyro-std()-Z", "avg_fBodyAccMag-mean()"  , "avg_ffBodyAccMag-std()", "avg_fBodyBodyAccJerkMag-mean()", "avg_fBodyBodyAccJerkMag-std()" , "avg_fBodyBodyGyroMag-mean()"   , "avg_fBodyBodyGyroMag-std()"    , "avg_fBodyBodyGyroJerkMag-mean()", "avg_fBodyBodyGyroJerkMag-std()" ))

#Write the TidayDate set out
write.table(TidyData, file="./Getting-and-Cleaning-Data/AvgHumanActivity.txt", col.names=TRUE, row.names = FALSE, sep = " ")

rm(AllData)
rm(FinalData)
rm(x)
rm(TidyData)
rm(ColNames)

