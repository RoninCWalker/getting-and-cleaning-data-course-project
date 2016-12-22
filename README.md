# Getting And Cleaning Data Course Project

1. Run the script by using the following command in the command line:

 ```
 RScript run_analysis.R
 ```

2. The run_analysis.R will perform the following task:
    * Download the dataset zip file.
    * Unzip the downloaded dataset zip file.
    * Load the Features, Activities, Training and Testing data files.
    * Merge all the file.
    * Group by Subject and Activity.
    * Summarize all the measurements.
    * Rename the columns by appending ```MEAN-``` in the prefix. 
    * Write the result into ```tidyResult.txt```.

3. Once the run_analysis.R completed running, the result can be loaded into R with the following steps:
    * Open R
    * set the Working Directory to the directory of tidyResult.txt
    * Load the result with the following command in R:
    
        ``` r
        result <- read.table("tidyResult.txt", header=TRUE)
        View(result)
        ```
