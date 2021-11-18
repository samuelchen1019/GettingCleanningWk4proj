1. Download and unzip the data set from http://archive.ics.uci.edu/ml/machine-learning-databases/00341/HAPT%20Data%20Set.zip.

2. Assign the data sets to several data tables.

  activity_labels<-fread("activity_labels.txt",col.names = c("id","activity"))
    12 rows, 2 columns. The activity list.
    
  features<-fread("features.txt",header=FALSE,col.names = "feature_name")
    561 rows, 1 column. Feature names.

  subject_id_test<-fread("Test/subject_id_test.txt",header=FALSE)
    3162 rows, 1 column. Data set contains only the subjects' ids.

  x_test<-fread("Test/X_test.txt",header = FALSE,col.names = features$feature_name)
    3162 rows, 561 columns. Contains the test data of the features.

  y_test<-fread("Test/y_test.txt",header=FALSE,col.names = "code")
    3162 rows, 1 column. Contains the activity ids for the x test data.

  subject_id_train<-fread("Train/subject_id_train.txt",header=FALSE)
    7767 rows, 1 column. Contains the subjects' id of the train data.

  x_train<-fread("Train/X_train.txt",header = FALSE,col.names = features$feature_name)
    7767 rows, 561 column. Contains the train data of the features.

  y_train<-fread("Train/y_train.txt",header=FALSE,col.names = "code")
    7767 rows, 1 column. Contains the activity ids for the x train data.

3. Merges the training and the test sets to create one data set.
  Using rbind() and cbind(), merged x_test, x_train, y_test, y_train, subject_id_test, subject_id_train to one data set named "merged".
  merged contains 10929 rows, 563 variables.
  
4. Extracts only the measurements on the mean and standard deviation for each measurement.
  Using select() to finish the extraction. I accidentally name the column of subjects as "V1". The column name will be changed in the next step. The tidy data set contains 10929 rows and 81 columns

5. Uses descriptive activity names to name the activities in the data set.
  tidydata$code<-activity_labels[tidydata$code,2]

6. Appropriately labels the data set with descriptive variable names.
  Using gsub() to rename the columns of the tidy data set.
  
7. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
  Using summarise_all(), group_by() to finish this step. The final data set contains 349 rows and 81 variables.