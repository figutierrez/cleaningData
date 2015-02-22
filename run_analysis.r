### Proyecto - Getting and Cleaning Data

# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.

# Primero cargamos todos los datos del directorio HAR
# El Working Directory debe ser su padre.
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Unimos test con train
x.df <- rbind(x_test, x_train)
y.df <- rbind(y_test, y_train)
subject.df <- rbind(subject_test, subject_train)

# 4. Appropriately labels the data set with descriptive variable names. 
data_labels = sapply(features$V2, function(x) {gsub('[-(),]+','_', x)})
colnames(x.df) <- data_labels

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_and_std_features <- grep('mean|std', features$V2, ignore.case=TRUE)
x.df <- x.df[,mean_and_std_features]

# 3. Uses descriptive activity names to name the activities in the data set
for (i in 1:6) {
  x.df$activity[y.df$V1 == i] <- as.character(activity_labels[i,2])  
}

# 5. Creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject. 

# Primero, asociamos los subjects a x.df y agregamos por mean
x.df$subject <- as.factor(subject.df$V1)
dy <- aggregate(. ~ subject+activity, data=x.df, FUN=mean)

# Obtencion del dataset ordenado
write.table(tidy, "tidy.txt", sep="\t")
