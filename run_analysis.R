run_analysis <- function(directory) {
#    Provide a tidy data set for future analysis of Human Activity as it was recorded by a smartphones accelerometer and gyroscope.  
#    Each participant attached their smartphone to their waste as they carrier out daily activites.  For additional information on 
#    the beginning data set see: [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://)
     
#    For the purpose of this analysis,  std(): Standard deviation and mean(): Mean value were extracted from the original source 
#    along with test subject and Activity.  The meanFreq()(Weighted average of the frequency components to obtain a mean frequency) 
#    has been excluded from the resultset as it was not necessary for our analysis.
 
     
#Get the column headers File

CHFile<-paste(directory,"\\UCI HAR Dataset\\","features.txt", sep="")
#=directory"features.txt"
#file<-paste(directory,"\\",Filename,".csv", sep="")

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

#Set teh File names for each file
TestSubjectsFile<-paste(directory,"\\UCI HAR Dataset\\test\\subject_test.txt", sep="")
TrainSubjectsFile<-paste(directory,"\\UCI HAR Dataset\\train\\subject_train.txt", sep="")
TrainDataFile<-paste(directory,"\\UCI HAR Dataset\\train\\X_train.txt", sep="")
TestDataFile<-paste(directory,"\\UCI HAR Dataset\\test\\X_test.txt", sep="")
TrainActivityFile<-paste(directory,"\\UCI HAR Dataset\\train\\y_train.txt", sep="")
TestActivityFile<-paste(directory,"\\UCI HAR Dataset\\test\\y_test.txt", sep="")

#load the Test File
TrainTestSubjects<-read.table(TrainSubjectsFile, header=FALSE)
TrainActivity<-read.table(TrainActivityFile, header=FALSE)
TrainData<-read.table(TrainDataFile, header=FALSE)
TestTestSubjects<-read.table(TestSubjectsFile, header=FALSE)
TestActivity<-read.table(TestActivityFile, header=FALSE)
TestData<-read.table(TestDataFile, header=FALSE)

#Rename the Activity and TestSubject Columns
colnames(TrainTestSubjects)<-c("TestSubjectID")
colnames(TestTestSubjects)<-c("TestSubjectID")
colnames(TrainActivity)<-c("ActivityID")
colnames(TestActivity)<-c("ActivityID")


#Get the Data set to classify the activity by name
ActLabelsFile<-paste(directory,"\\UCI HAR Dataset\\activity_labels.txt", sep="")
Activity<-read.table(ActLabelsFile, header=FALSE)
            

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
CleanDataFile<-paste(directory,"\\HumanActivity.txt", sep="")
write.table(FinalData, file=CleanDataFile, col.names=TRUE, row.names = FALSE, sep = " ")


#Get the Measure Names
ColNames<-colnames(AllData[ , grep( "-mean\\(\\)|std" , names(AllData) ) ])

#Melt the data to prepare it for Casting
x<-melt(FinalData, id=c("TestSubjectId", "ActivityDesc"), measure.vars=ColNames)

#Get the Avg
TidyData<-dcast(x, TestSubjectId + ActivityDesc ~ variable, mean)


#Clean up the Column Names
names(TidyData) <- gsub("mean", "Mean", names(TidyData)) # capitalize M
names(TidyData) <- gsub("std", "Std", names(TidyData)) # capitalize S
names(TidyData) <- gsub("tBody", "Avg_tBody", names(TidyData)) # Add Avg in the front
names(TidyData) <- gsub("tGravity", "Avg_tGravity", names(TidyData)) # Add Avg in the front
names(TidyData) <- gsub("fGravity", "Avg_Gravity", names(TidyData)) # Add Avg in the front
names(TidyData) <- gsub("fBody", "Avg_fBody", names(TidyData)) # Add Avg in the front


#Write the TidayDate set out
TidyDataFile<-paste(directory,"\\AvgHumanActivity.txt", sep="")
write.table(TidyData, file=TidyDataFile, col.names=TRUE, row.names = FALSE, sep = "", quote= FALSE)

rm(AllData)
rm(FinalData)
rm(x)
rm(TidyData)
rm(ColNames)
}
