# Code Book

This code book explains input, run_Analysis.R, and output.

## Input (see in the directory UCI HAR Dataset)
* Activity name and code 'UCI HAR Dataset\activity_labels.txt
* Feature names 'UCI HAR Dataset\features.txt
* Test dataset 'UCI HAR Dataset\test\X_test.txt'
* Test activity code 'UCI HAR Dataset\test\y_test.txt'
* Train dataset 'UCI HAR Dataset\train\X_train.txt'
* Train activity code 'UCI HAR Dataset\train\y_train.txt'

## run_Analysis.R

1) Load dataset and name variables by feature names

	#Load train and test data set
	train <- fread("UCI HAR Dataset/train/X_train.txt")
	test <- fread("UCI HAR Dataset/test/X_test.txt")

	#Assign columns name to data set
	features <- fread("UCI HAR Dataset/features.txt")
	names(train) <- make.names(name = features[[2]], unique = TRUE, allow_ = TRUE)
	names(test) <- make.names(name = features[[2]], unique = TRUE, allow_ = TRUE)
	rm("features")
	
	#Create data frame tbl
	train <- tbl_df(train)
	test <- tbl_df(test)
	
2) Select only columns on the mean and standard derivation and rename the variables.

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
	rm("cnames")
	
3) 