#Load packages data.table, dplyr,and tidyr
library(data.table)
library(dplyr)

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

#Load activity for data set train and test
activity_train <- fread("UCI HAR Dataset/train/y_train.txt")
activity_train <- tbl_df(activity_train)
activity_test <- fread("UCI HAR Dataset/test/y_test.txt")
activity_test <- tbl_df(activity_test)
names(activity_train) <- "activity_labels"
names(activity_test) <- "activity_labels"

#Map activity codes to activity names
labels <- fread("UCI HAR Dataset/activity_labels.txt")
labels <- labels[[2]]
activity_train <- mutate(activity_train, activity_labels = labels[activity_labels])
activity_test <- mutate(activity_test, activity_labels = labels[activity_labels])

#Combine dataset with activity
train <- cbind(train, activity_train)
test <- cbind(test, activity_test)

#Combine dataset train and test
data <- rbind(train, test)

#Summarize data with the average for each variables and grouped by activity names
tidy <- data %>% group_by(activity_labels) %>% summarise_each(funs(mean))

#Write final dataset to file tidy.txt
write.table(tidy, file = "tidy.txt", row.names = FALSE)
