# Zebrafish-Pollutant-Analysis
R functions to perform Fisher-exact tests on the behavioral data of zebrafish affected by pollution. Visualizes measured data, produces p-values for several test statistics, and creates null randomization distributions.

## fishanalysis() 
This function encapsulates several functions that visualize data and perform Fisher-exact tests. It performs each statistical test for each measured variable and creates a text file to print the p-values to.

fishanalysis <- function(randomizations = 100000, plots = FALSE, fisherplot = FALSE, file, path)

- randomizations: Integer parameter for the number of randomizations to be performed for each fisher-exact test. The default value is 100000. The ideal amount is N (total number of units) choose Nt (units that received active treatment) but the ideal amount is often too computationally intensive.

- plots: Boolean parameter to decide whether to produce descriptive line plots and boxplots for each behavior. The default value is false.

- fisherplot: Boolean parameter to decide whether to produce null randomization distribution plots for each Fisher-exact test. The default value is false.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

## plot.correctturn() Function details
This function creates line plots and boxplots for the proportion of correct turns of each fish across all coherences.

plot.correctturn <- function(color, file, path) 

- color: Color of the elements associated with the active treatment to be graphed.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

## plot.orientation() Function details
This function creates line plots and boxplots for the average orientation change of each fish across all coherences.

plot.orientation <- function(color, file, path) 

- color: Color of the elements associated with the active treatment to be graphed.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

## plot.boutrate() Function details
This function creates line plots and boxplots for the average bout rate of each fish across all coherences.

plot.boutrate <- function(color, file, path) 

- color: Color of the elements associated with the active treatment to be graphed.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

## fishertest.mean() Function details
This function performs a Fisher-exact test on a measured variable. It uses the difference in the mean of the measured variable between the active treatment and control treatment groups as the test statistic. It can also produce a null randomization distribution histogram.

fishertest.mean <- function(randomizations = 100000, measure, plot, file, path)

- randomizations: Integer parameter for the number of randomizations to be performed for each fisher-exact test. The default value is 100000. The ideal amount is N (total number of units) choose Nt (units that received active treatment) but the ideal amount is often too computationally intensive.

- measure: String parameter to indicate the behavior measure to be assessed.

- plot: Boolean parameter to decide whether to produce null randomization distribution plots for each Fisher-exact test.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

## fishertest.area() Function details
This function performs a Fisher-exact test on a measured variable. It uses the area between the line plots of the plotted medians of the measured variables for the active treatment and control treatment groups as the test statistic. It can also produce a null randomization distribution histogram.

fishertest.area <- function(randomizations = 100000, measure, plot, file, path)

- randomizations: Integer parameter for the number of randomizations to be performed for each fisher-exact test. The default value is 100000. The ideal amount is N (total number of units) choose Nt (units that received active treatment) but the ideal amount is often too computationally intensive.

- measure: String parameter to indicate the behavior measure to be assessed.

- plot: Boolean parameter to decide whether to produce null randomization distribution plots for each Fisher-exact test.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

## fishertest.mean.coherence() Function details
This function performs a Fisher-exact test on a measured variable. It uses the difference in the mean of the measured variable at a specified coherence between the active treatment and control treatment groups as the test statistic. It can also produce a null randomization distribution histogram.

fishertest.mean.coherence <- function(randomizations = 100000, measure, coherence, plot, file, path)

- randomizations: Integer parameter for the number of randomizations to be performed for each fisher-exact test. The default value is 100000. The ideal amount is N (total number of units) choose Nt (units that received active treatment) but the ideal amount is often too computationally intensive.

- measure: String parameter to indicate the behavior measure to be assessed.

- plot: Boolean parameter to decide whether to produce null randomization distribution plots for each Fisher-exact test.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

## fishertest.variance.coherence() Function details
This function performs a Fisher-exact test on a measured variable. It uses the difference in the variance of the measured variable at a specified coherence between the active treatment and control treatment groups as the test statistic. It can also produce a null randomization distribution histogram.

fishertest.variance.coherence <- function(randomizations = 100000, measure, coherence, plot, file, path)

- randomizations: Integer parameter for the number of randomizations to be performed for each fisher-exact test. The default value is 100000. The ideal amount is N (total number of units) choose Nt (units that received active treatment) but the ideal amount is often too computationally intensive.

- measure: String parameter to indicate the behavior measure to be assessed.

- plot: Boolean parameter to decide whether to produce null randomization distribution plots for each Fisher-exact test.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.
