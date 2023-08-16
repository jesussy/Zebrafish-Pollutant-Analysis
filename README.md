# Zebrafish-Pollutant-Analysis
Performs Fisher-exact tests on the behavioral data of zebrafish affected by pollution. Visualizes measured data, produces p-values for several test statistics, and creates null randomization distributions.

## fishanalysis() Function details
This function encapsulates several functions that visualize data and perform Fisher-exact tests. It performs each statistical test for each measured variable and creates a text file to print the p-values to.

fishanalysis <- function(randomizations = 100000, plots = FALSE, fisherplot = FALSE, file, path)

randomizations: 
Integer parameter for the number of randomizations to be performed for each fisher-exact test. The ideal amount is N (total number of units) choose Nt (units that received active treatment) but the ideal amount is often too computationally intensive.

plots: 
Boolean parameter to decide whether to produce descriptive line plots and boxplots for each behavior.

fisherplot: 
Boolean parameter to decide whether to produce null randomization distribution plots for each Fisher-exact test.

file: 
String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

path: 
String parameter containing the path to the provided file.

## plot.correctturn() Function details
plot.correctturn <- function(color, file, path) 

color:
Color of the elements associated with the active treatment to be graphed.

file: 
String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". 

path: 
String parameter containing the path to the provided file.



