#Get the column headers File
CHFile="./Data/UCI HAR Dataset/features.txt"

#Read the Column Headers 2nd column will contain the Columnnames
ColumnHeaders<-read.csv(CHFile, header=FALSE, sep=" ")

#Create a matrix with teh same number of records in the ColumHeader File
temprow <- matrix(c(rep.int(NA,nrow(ColumnHeaders))),nrow=1,ncol=nrow(ColumnHeaders))

#convert the Matric to a DF                  
ColumnNames <- data.frame(temprow)

#Set teh Columnnames to the VAlues from the File
colnames(ColumnNames)<-ColumnHeaders$V2

#Clean up teh memory
rm(ColumnHeaders)
rm(temprow)
rm(CHFile)

#load the Test File
TrainData<-read.table("./data/UCI HAR Dataset/train/X_train.txt", header=FALSE)
TestData<-read.table("./data/UCI HAR Dataset/test/X_test.txt", header=FALSE)

#Set the Names to the the Same
names(TrainData) <- names(ColumnNames) 
names(TestData) <- names(ColumnNames) 

#Combine all the data
AllData<-rbind(TestData, TrainData)

#clean up the memory
rm(TestData)
rm(TrainData)
rm(ColumnNames)

#test change

