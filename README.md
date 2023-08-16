# Zebrafish-Pollutant-Analysis
Performs Fisher-exact tests on the behavioral data of zebrafish affected by pollution. Visualizes measured data, produces p-values for several test statistics, and creates null randomization distributions.

## Function details
fishanalysis <- function(randomizations = 100000, plots = FALSE, fisherplot = FALSE, file, path)

randomizations: Integer parameter for the number of randomizations to be performed for each fisher-exact test. The ideal amount is N (total number of units) choose Nt (units that received active treatment) but the ideal amount is often too computationally intensive.

plots: Boolean parameter to decide whether to produce descriptive line plots and boxplots for each behavior.

fisherplot: Boolean parameter to decide whether to produce null randomization distribution plots for each Fisher-exact test.

file: String parameter ending with ".txt" for the text file containing the behavioral data. The file contents are required to be delimited by spaces with columnar data and headings for at least "Condition", "Coherence", "CorrectTurn", "AverageOrientation", and "AverageBouts". For example:

#yuh

path: String parameter containing the path to the provided file.
