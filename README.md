# Getting and Cleaning Data Course Project

In this project we clean up and summarize data from the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) into a tidy dataset.

The [run_analysis.R](./run_analysis.R) script executes in the following sequence:
1. Reads in all the reference data consisting of column names and activity names.
1. Reads in the test data set, adds test subjects, labels the columns and activity names as appropriate.
1. Reads in the training data set, adds test subjects, labels the columns and activity names as appropriate.
1. Merges the test and training data sets into one data frame.
1. Selects the mean and the standard deviation measures.
1. Summarizes an average for each selected measure by subject and activity name.
1. Writes out the final result to `summary.txt`.

Instructions and notes:
* Use `source('run_analysis.R')` to execute the analysis script.
* To read `summary.txt` back into the environment use `read.table("summary.txt", header = TRUE)`.
* For details on the contents of summary.txt review the [codebook](./CodeBook.md) provided.