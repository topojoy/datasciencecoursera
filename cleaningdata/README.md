Getting and Cleaning data for wearable tech
===================

**Steps to execute the run analysis script.**

	- download and source the `run_analysis.R` file.
	- you should see two functions imported `merge_with_order` and `clean_data`, the first function is a wrapper on top of `merge` to keep order of rows of one of the dataframes, and the actual data analysis and cleaning function is `clean_data`.
	- the `clean_data` function takes two arguments: 
		- `base_path`: takes the base path of the directory which has the data unzipped, with the base data folder name also included, check code for the default 
		- `file_path`: takes the file path where the output file qwould be created, and if only file name is given, it creates it in the current working directory.

