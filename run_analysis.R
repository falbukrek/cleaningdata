# load the necessary libraries
library(readr)
library(dplyr)
library(stringr)

# set up locations of key directories and files
data_dir <- "UCI HAR Dataset"
test_dir <- file.path(data_dir, "test")
train_dir <- file.path(data_dir, "train")
features_file <- file.path(data_dir, "features.txt")
labels_file <- file.path(data_dir, "activity_labels.txt")
test_set_file <- file.path(test_dir, "X_test.txt")
test_label_file <- file.path(test_dir, "y_test.txt")
test_subject_file <- file.path(test_dir, "subject_test.txt")
train_set_file <- file.path(train_dir, "X_train.txt")
train_label_file <- file.path(train_dir, "y_train.txt")
train_subject_file <- file.path(train_dir, "subject_train.txt")

# read in the names of the feature columns
feature_columns <- read.delim(features_file, header = FALSE, sep = " ", col.names = c("id", "name"))

# read in the names of the activity labels
activity_labels <- read.delim(labels_file, header = FALSE, sep = " ", col.names = c("id", "activityname"))

# since we are working with fixed width files (16 char columns), compute a vector listing all the column positions
feature_column_positions <- fwf_widths(rep(16, nrow(feature_columns)), col_names = feature_columns$name)

# all columns are decimals, generate a col_types descriptor
feature_column_types <- strrep("d", nrow(feature_columns))


############################### 
# Process the test data
###############################

# read in the test dataset
test_set <-read_fwf(test_set_file, col_positions = feature_column_positions, col_types = feature_column_types)

# read in the test labels
test_labels <- read.delim(test_label_file, header = FALSE, sep = " ", col.names = "id", colClasses = "integer")

# match the ids to the English names
test_labels <- test_labels %>% left_join(activity_labels, by = c("id" = "id"))

# add the activity names to the test set as a column
test_set <- test_set %>% mutate(activityname = test_labels$activityname)

# read in the test subjects
test_subjects <- read.delim(test_subject_file, header = FALSE, sep = " ", col.names = "id", colClasses = "integer")

# add the subjects to the test set as a column
test_set <- test_set %>% mutate(subjectid = test_subjects$id)


###############################
# Process the train data
###############################

# read in the train dataset
train_set <-read_fwf(train_set_file, col_positions = feature_column_positions, col_types = feature_column_types)

# read in the train labels
train_labels <- read.delim(train_label_file, header = FALSE, sep = " ", col.names = "id", colClasses = "integer")

# match the ids to the English names
train_labels <- train_labels %>% left_join(activity_labels, by = c("id" = "id"))

# add the activity names to the test set as a column
train_set <- train_set %>% mutate(activityname = train_labels$activityname)

# read in the train subjects
train_subjects <- read.delim(train_subject_file, header = FALSE, sep = " ", col.names = "id", colClasses = "integer")

# add the subjects to the test set as a column
train_set <- train_set %>% mutate(subjectid = train_subjects$id)


###############################
# Merge sets and choose columns
###############################

# join the two sets of rows (Step 1 in assignment)
complete_set <- bind_rows(test_set, train_set)

# select subjectid, activity name and the required measurements (Step 2-4 in assignment)
requested_measurement_columns <-  str_which(names(complete_set), "mean\\(\\)|std\\(\\)")
requested_set <- select(complete_set, requested_measurement_columns, subjectid, activityname)

# summarize average of each measurement by subject and activity
# we rename the measurement columns with a prefix "avg_" in order to be clear that
# these are the summaries of the original measurements
summary <- requested_set %>% 
    group_by(activityname, subjectid) %>% 
    summarize_all(mean) %>% 
    rename_at(names(complete_set)[requested_measurement_columns], function(x) { paste("avg_", x, sep = "")})

# write the final file
write.table(summary, "summary.txt", row.name=FALSE)