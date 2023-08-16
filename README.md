# Zebrafish-Pollutant-Analysis
R toolkit to perform Fisher-exact tests on the behavioral data of zebrafish treated with pollutants. Visualizes measured data, produces p-values for several test statistics, and creates null randomization distributions. 

The purpose of this analysis is to causally assess whether chronic low-level exposure to pollution has an effect on the behavior of zebrafish. This is done with the Fisher-exact test, which constructs a null randomization distribution for the observed data to be tested against. Several test statistics are used to better capture the data between treatment groups: the difference in means, the area between line plot curves, the difference in means at a single coherence, and the difference in variances at a single coherence. These tests can be performed for each measured behavior: proportion of correct turns, average orientation change, and average bout rate. A text file with p-values is created and JPG files of the null randomization distributions can also be created. Additionally, JPG files with line plots and boxplots summarizing each measured variable can be produced. 

A primary focus in creating this toolkit was to make the code modular for smaller and more specific analyses. So, the individual functions nested within the fishanalysis() function can be used on their own.

## Required Packages
The packages "ggplot2", "cowplot", and "plyr" are used within the code. These may need to be installed first. This can be done in the R console via install.packages().

## fishanalysis() 
This function encapsulates several functions that visualize data and perform Fisher-exact tests. It performs each statistical test for each measured variable and creates a text file to print the p-values to.

fishanalysis <- function(randomizations = 100000, plots = FALSE, fisherplot = FALSE, file, path)

- randomizations: Integer parameter for the number of randomizations to be performed for each fisher-exact test. The default value is 100000. The ideal amount is N (total number of units) choose Nt (units that received active treatment) but the ideal amount is often too computationally intensive.

- plots: Boolean parameter to decide whether to produce descriptive line plots and boxplots for each behavior. The default value is false.

- fisherplot: Boolean parameter to decide whether to produce null randomization distribution plots for each Fisher-exact test. The default value is false.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

Example: fishanalysis(100000, TRUE, FALSE, "PFOS_30_1.txt", "C:/Users/Jesus Lopez/Desktop/Zebrafish Data/August15_2023")

## plot.correctturn()
This function creates line plots and boxplots for the proportion of correct turns of each fish across all coherences.

plot.correctturn <- function(color, file, path) 

- color: Color of the elements associated with the active treatment to be graphed.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

Example: plot.correctturn("green", "PFOS_30_1.txt", "C:/Users/Jesus Lopez/Desktop/Zebrafish Data/August15_2023")

## plot.orientation()
This function creates line plots and boxplots for the average orientation change of each fish across all coherences.

plot.orientation <- function(color, file, path) 

- color: Color of the elements associated with the active treatment to be graphed.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

Example: plot.orientation("#F20219", "PFOS_30_1.txt", "C:/Users/Jesus Lopez/Desktop/Zebrafish Data/August15_2023")

## plot.boutrate() 
This function creates line plots and boxplots for the average bout rate of each fish across all coherences.

plot.boutrate <- function(color, file, path) 

- color: Color of the elements associated with the active treatment to be graphed.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

Example: plot.boutrate("orange", "PFOS_30_1.txt", "C:/Users/Jesus Lopez/Desktop/Zebrafish Data/August15_2023")

## fishertest.mean()
This function performs a Fisher-exact test on a measured variable. It uses the difference in the mean of the measured variable between the active treatment and control treatment groups as the test statistic. It can also produce a null randomization distribution histogram.

fishertest.mean <- function(randomizations = 100000, measure, plot, file, path)

- randomizations: Integer parameter for the number of randomizations to be performed for each fisher-exact test. The default value is 100000. The ideal amount is N (total number of units) choose Nt (units that received active treatment) but the ideal amount is often too computationally intensive.

- measure: String parameter to indicate the behavior measure to be assessed.

- plot: Boolean parameter to decide whether to produce null randomization distribution plots for each Fisher-exact test.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

Example: fishertest.mean(90000, "CorrectTurn", TRUE, "PFOS_30_1.txt", "C:/Users/Jesus Lopez/Desktop/Zebrafish Data/August15_2023")

## fishertest.area()
This function performs a Fisher-exact test on a measured variable. It uses the area between the line plots of the plotted medians of the measured variables for the active treatment and control treatment groups as the test statistic. It can also produce a null randomization distribution histogram.

fishertest.area <- function(randomizations = 100000, measure, plot, file, path)

- randomizations: Integer parameter for the number of randomizations to be performed for each fisher-exact test. The default value is 100000. The ideal amount is N (total number of units) choose Nt (units that received active treatment) but the ideal amount is often too computationally intensive.

- measure: String parameter to indicate the behavior measure to be assessed.

- plot: Boolean parameter to decide whether to produce null randomization distribution plots for each Fisher-exact test.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

Example: fishertest.area(100000, "AverageOrientation", FALSE, "PFOS_30_1.txt", "C:/Users/Jesus Lopez/Desktop/Zebrafish Data/August15_2023")

## fishertest.mean.coherence()
This function performs a Fisher-exact test on a measured variable. It uses the difference in the mean of the measured variable at a specified coherence between the active treatment and control treatment groups as the test statistic. It can also produce a null randomization distribution histogram.

fishertest.mean.coherence <- function(randomizations = 100000, measure, coherence, plot, file, path)

- randomizations: Integer parameter for the number of randomizations to be performed for each fisher-exact test. The default value is 100000. The ideal amount is N (total number of units) choose Nt (units that received active treatment) but the ideal amount is often too computationally intensive.

- measure: String parameter to indicate the behavior measure to be assessed.

- plot: Boolean parameter to decide whether to produce null randomization distribution plots for each Fisher-exact test.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

Example: fishertest.mean.coherence(250000, "AverageBouts", 50, TRUE, "PFOS_30_1.txt", "C:/Users/Jesus Lopez/Desktop/Zebrafish Data/August15_2023")

## fishertest.variance.coherence()
This function performs a Fisher-exact test on a measured variable. It uses the difference in the variance of the measured variable at a specified coherence between the active treatment and control treatment groups as the test statistic. It can also produce a null randomization distribution histogram.

fishertest.variance.coherence <- function(randomizations = 100000, measure, coherence, plot, file, path)

- randomizations: Integer parameter for the number of randomizations to be performed for each fisher-exact test. The default value is 100000. The ideal amount is N (total number of units) choose Nt (units that received active treatment) but the ideal amount is often too computationally intensive.

- measure: String parameter to indicate the behavior measure to be assessed.

- plot: Boolean parameter to decide whether to produce null randomization distribution plots for each Fisher-exact test.

- file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

- path: String parameter containing the path to the provided file.

Example: fishertest.variance.coherence(100000, "AverageBouts", 100, FALSE, "PFOS_30_1.txt", "C:/Users/Jesus Lopez/Desktop/Zebrafish Data/August15_2023")
