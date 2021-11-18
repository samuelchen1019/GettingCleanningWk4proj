library(data.table)
library(dplyr)
library(tidyr)

##download and unzip the dataset
fileURL<-"http://archive.ics.uci.edu/ml/machine-learning-databases/00341/HAPT%20Data%20Set.zip"
download.file(fileURL,"HAPT.zip",method = "curl")
unzip("HAPT.zip")

##assign the data frames
activity_labels<-fread("activity_labels.txt",col.names = c("id","activity"))
features<-fread("features.txt",header=FALSE,col.names = "feature_name")
subject_id_test<-fread("Test/subject_id_test.txt",header=FALSE)
x_test<-fread("Test/X_test.txt",header = FALSE,col.names = features$feature_name)
y_test<-fread("Test/y_test.txt",header=FALSE,col.names = "code")
subject_id_train<-fread("Train/subject_id_train.txt",header=FALSE)
x_train<-fread("Train/X_train.txt",header = FALSE,col.names = features$feature_name)
y_train<-fread("Train/y_train.txt",header=FALSE,col.names = "code")

##combine those to one big dataset
X<-rbind(x_train,x_test)
y<-rbind(y_train,y_test)
subject<-rbind(subject_id_train,subject_id_test)
merged<-cbind(subject,X,y)

##Extracts only the measurements on the mean and standard deviation for each measurement.
tidydata<-select(merged,V1,code,contains("mean"),contains("std"))

##Uses descriptive activity names to name the activities in the data set
tidydata$code<-activity_labels[tidydata$code,2]

##Appropriately labels the data set with descriptive variable names.
names(tidydata)[1]="subject"
names(tidydata)[2]="activity"
names(tidydata)<-gsub("^t", "Time",names(tidydata))
names(tidydata)<-gsub("^f", "Frequency",names(tidydata))
names(tidydata)<-gsub("Acc","Accelerometer",names(tidydata))
names(tidydata)<-gsub("Gyro","Gyroscope",names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body",names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude",names(tidydata))
names(tidydata)<-gsub("-mean()", "Mean",names(tidydata),ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "STD",names(tidydata),ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "Frequency", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("angle", "Angle", names(tidydata))
names(tidydata)<-gsub("gravity", "Gravity", names(tidydata))

## From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
## for each activity and each subject.
summarisedata <- tidydata %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

write.table(summarisedata, "summarisedata.txt", row.name=FALSE)
