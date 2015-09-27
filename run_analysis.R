#there are two files names ReadmeRun_analysis and codeBook supplemented to this code you can find them in my repository
#You will need these two libraries installed
library(dplyr)
library(reshape2)

#To run the code properly please change follwing directory  to directory where the project dataset is located
#Following is my main directory
setwd("C:/ch1/rf/UCI HAR Dataset")

#Following codes load the files to tables

y_train <- read.table("train/y_train.txt", quote="\"")
y_test <- read.table("test/y_test.txt", quote="\"")
X_train <- read.table("train/X_train.txt", quote="\"")
X_test <- read.table("test/X_test.txt", quote="\"")
features <- read.table("features.txt", quote="\"")
activity_labels <- read.table("activity_labels.txt", quote="\"")
subject_train <- read.table("train/subject_train.txt", quote="\"")
subject_test <- read.table("test/subject_test.txt", quote="\"")

#I have transposed the second column of features table and assigned it as X_train and X_test column names
colnames(X_train) <- t(features[2])
colnames(X_test) <- t(features[2])
#Following code creates a new column to y_test and y_train and assign descriptive activity names to activities 
activity_labels<-activity_labels[,2]
y_test[,2] = activity_labels[y_test[,1]]
y_train[,2] = activity_labels[y_train[,1]]

#First create two common columns between X_train and X_test and Merges the training and the test sets to create one data set
#I have changed subject to "participants"
X_train$participants <- subject_train[, 1]
X_train$activity_Type <- y_train[, 2]

X_test$participants <- subject_test[, 1]
X_test$activity_Type <- y_test[, 2]
DFTestTrain <- rbind(X_train, X_test)

#check to see if any duplicate column names
duplicated(colnames(DFTestTrain))
DFTestTrain <- DFTestTrain[, !duplicated(colnames(DFTestTrain))]

#Extract only the measurements on the participants ,activity,mean and standard deviation for each measurement
DFTestTrain2<-select(DFTestTrain,contains("participants"), contains("activity"),contains("mean"), contains("std"))

#which of the variables are ID variables and which are measure variables
id_variables   = c("participants", "activity_Type")
measure_variables = setdiff(colnames(DFTestTrain2), id_variables)

#Melt all the rest values based on id_variables
meltedDFTestTrain2  = melt(DFTestTrain2, id = id_variables, measure.vars = measure_variables)

#Recast the meltedDFTestTrain2 and Apply mean function to dataset 
TidyData   = dcast(meltedDFTestTrain2, participants + activity_Type ~ variable, mean)

write.table(TidyData, file = "Tidydata.txt", row.names = FALSE)
