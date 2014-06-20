#Get the column headers File
CHFile="./Data/UCI HAR Dataset/features.txt"

#Read the Column Headers 2nd column will contain the Columnnames
ColumnHeaders<-read.csv(CHFile, header=FALSE, sep=" ")

#Add 2 new row to the Column Headers for Test Subject and Activity
NewRow<-data.frame(V1=1, V2="TestSubjectId")
NewRow2<-data.frame(V1=1, V2="ActivityDesc")
ColumnHeaders<- rbind(NewRow, NewRow2, ColumnHeaders)

#Create a matrix with the same number of records in the ColumHeader File
temprow <- matrix(c(rep.int(NA,nrow(ColumnHeaders))),nrow=1,ncol=nrow(ColumnHeaders))

#convert the Matric to a DF                  
ColumnNames <- data.frame(temprow)

#Set the Columnnames to the VAlues from the File
colnames(ColumnNames)<-ColumnHeaders$V2

#Clean up teh memory
rm(NewRow)
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

#Get the Data set to classify the activity by name
Activity<-read.table("./data/UCI HAR Dataset/activity_labels.txt", header=FALSE)
#Merge the Activity with the Desc
TrainActivity<-merge(TrainActivity, Activity, by.x="V1", by.y="V1", all=TRUE)
TestActivity<-merge(TestActivity, Activity, by.x="V1", by.y="V1", all=TRUE)

#Cbind the Test Subjects and Activitys to the test and Traing DF
TrainData<-cbind( TrainTestSubjects, TrainActivity$V2, TrainData)
TestData<-cbind( TestTestSubjects, TestActivity$V2, TestData)

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

#Get the Measure Names
ColNames<-colnames(AllData[ , grep( "-mean\\(\\)|std" , names(AllData) ) ])

#Melt the data to prepare it for Casting
x<-melt(FinalData, id=c("TestSubjectId", "ActivityDesc"), measure.vars=ColNames)

#Get teh Avg
TidyData<-dcast(x, TestSubjectId + ActivityDesc ~ variable, mean)


