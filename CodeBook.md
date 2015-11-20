# Code Book

This code book explains input, run_Analysis.R, and output.

### Input (see in the directory UCI HAR Dataset)
* Activity name and code `UCI HAR Dataset\activity_labels.txt`
* Feature names `UCI HAR Dataset\features.txt`
* Test dataset `UCI HAR Dataset\test\X_test.txt`
* Test activity code `UCI HAR Dataset\test\y_test.txt`
* Train dataset `UCI HAR Dataset\train\X_train.txt`
* Train activity code `UCI HAR Dataset\train\y_train.txt`

### run_Analysis.R

1) Load nessessary package.

	library(data.table)
	library(dplyr)
	
2) Load dataset and name variables by feature names

	#Load train and test data set
	train <- fread("UCI HAR Dataset/train/X_train.txt")
	test <- fread("UCI HAR Dataset/test/X_test.txt")

	#Assign columns name to data set
	features <- fread("UCI HAR Dataset/features.txt")
	names(train) <- make.names(name = features[[2]], unique = TRUE, allow_ = TRUE)
	names(test) <- make.names(name = features[[2]], unique = TRUE, allow_ = TRUE)
	
	#Create data frame tbl
	train <- tbl_df(train)
	test <- tbl_df(test)
	
3) Select only columns on the mean and standard derivation and rename the variables.

	#Select only columns on the mean and standard derivation
	train <- select(train, contains(".mean."), contains(".std."))
	test <- select(test, contains(".mean."), contains(".std."))
	
	#rename column names
	cnames <- names(train)
	cnames <- gsub("\\.\\.\\.", "_", cnames)
	cnames <- gsub("\\.\\.", "", cnames)
	cnames <- gsub("\\.", "_", cnames)
	names(train) <- cnames
	names(test) <- cnames
	
4) Load activity data and map activity code to activity name.

	#Load activity for data set train and test
	activity_train <- fread("UCI HAR Dataset/train/y_train.txt")
	activity_train <- tbl_df(activity_train)
	activity_test <- fre
	
	ad("UCI HAR Dataset/test/y_test.txt")
	activity_test <- tbl_df(activity_test)
	names(activity_train) <- "activity_labels"
	names(activity_test) <- "activity_labels"
	
	#Map activity codes to activity names
	labels <- fread("UCI HAR Dataset/activity_labels.txt")
	labels <- labels[[2]]
	activity_train <- mutate(activity_train, activity_labels = labels[activity_labels])
	activity_test <- mutate(activity_test, activity_labels = labels[activity_labels])
	
5) Combine dataset test, train, and activity name into one table.

	#Combine dataset with activity
	train <- cbind(train, activity_train)
	test <- cbind(test, activity_test)
	
	#Combine dataset train and test
	data <- rbind(train, test)

6) Summarize data with the average for each variables, grouped by activity names and write the output file.
	
	#Summarize data with the average for each variables and grouped by activity names
	tidy <- data %>% group_by(activity_labels) %>% summarise_each(funs(mean))

	#Write final dataset to file tidy.txt
	write.table(tidy, file = "tidy.txt", row.names = FALSE)
	
### Output (see in this repo tidy.txt)

### Additional information

You can see detail of variables name in `UCI HAR Dataset\README.txt`

© Natdanai Pholphak 2015 All Rights reserved.