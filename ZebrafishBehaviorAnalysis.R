## Zebrafish Behavior Analysis ## 
fishanalysis <- function(randomizations = 100000, plots = FALSE, fisherplot = FALSE, file, path) {
  ## Create functions to visualize data for each measured behavior ##
  if(plots) {
    plot.correctturn <- function(color, file, path) {
      library(ggplot2)
      library(cowplot)
      
      # Create summary statistics function (modified from cookbook-r.com by Winston Chang)
      summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,conf.interval=.95, .drop=TRUE) {
        library(plyr)
        # New version of length which can handle NA's: if na.rm==T, don't count them
        length2 <- function (x, na.rm=FALSE) {
          if (na.rm) sum(!is.na(x))
          else length(x)
        }
        
        # This does the summary. For each group's data frame, return a vector with
        # N, mean, and sd
        datac <- ddply(data, groupvars, .drop=.drop,.fun = function(xx, col) {
          c(N = length2(xx[[col]], na.rm=na.rm),
            median = median(xx[[col]], na.rm=na.rm),
            sd = sd(xx[[col]], na.rm=na.rm))
        },measurevar)
        
        # Rename the "mean" column    
        datac <- rename(datac, c("median" = measurevar))
        
        datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
        
        # Confidence interval multiplier for standard error
        # Calculate t-statistic for confidence interval: 
        # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
        ciMult <- qt(conf.interval/2 + .5, datac$N-1)
        datac$ci <- datac$se * ciMult
        
        return(datac)
      }
      
      # Read in fish data
      setwd(path)
      fish <- read.table(file, header = T)
      
      # Identify control and treatment variables (assumes that control begins with "WT")
      conditions <- unique(fish$Condition)
      for(c in conditions) {
        condition <- substr(c, start = 1, stop = 2)
        if(condition == "WT") {
          control <- c
        }
        else {
          active <- c
        }
        if(exists("control") && exists("active")) {
          break
        }
      }
      
      # Seperate data based on treatment
      fish0 <- fish[fish$Condition == control,]
      fish1 <- fish[fish$Condition == active,]
      
      # Create variable with summary statistics
      sumfish <- summarySE(fish, measurevar = "CorrectTurn", groupvars = c("Condition","Coherence"))
      
      ## Create lineplot ##
      lineplot <- ggplot(sumfish, aes(x=Coherence, y=CorrectTurn, colour=Condition)) + 
        geom_errorbar(aes(ymin = CorrectTurn - se, ymax= CorrectTurn + se), width=2) +
        geom_line(linewidth = 1.2) +
        geom_point(size = 2) +
        scale_y_continuous(limits = c(0,1)) +
        scale_colour_manual(values = c(color, "#d0e0e3ff")) +
        theme_minimal() +
        theme(legend.position = "top") + theme(legend.position="none")
      
      ## Prepare Data for Boxplots 
      fish0$Coherence <- factor(fish0$Coherence, levels = c(0,25,50,100))
      fish1$Coherence <- factor(fish1$Coherence, levels = c(0,25,50,100))
      combined_fish <- rbind(fish0, fish1)
      
      # Combine the datasets
      combineddata <- rbind(fish0, fish1)
      
      ## Create Boxplots ##
      boxplot <- ggplot(combineddata, aes(x = Coherence, y = CorrectTurn, fill = Condition)) +
        geom_boxplot() +
        scale_fill_manual(values = c(color, "#d0e0e3ff")) +
        theme_minimal() + theme(legend.position="none")
      
      # Combine plots horizontally
      combined <- plot_grid(lineplot,boxplot, ncol = 2)
      
      # Extract a legend that is laid out horizontally
      legend <- get_legend(
        boxplot + 
          guides(color = guide_legend(nrow = 1)) +
          theme(legend.position = "bottom")
      )
      
      # Add the legend to the bottom of the plots
      final <- plot_grid(combined, legend, ncol = 1, rel_heights = c(1, .1))
      
      # Save plot image
      imagename <- paste(active,"correctturns.jpg",sep="_")
      ggsave(imagename, plot = final, width = 7, height = 3)
    }
    plot.orientation <- function(color, file, path) {
      library(ggplot2)
      library(cowplot)
      
      # Create summary statistics function (modified from cookbook-r.com by Winston Chang)
      summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,conf.interval=.95, .drop=TRUE) {
        library(plyr)
        # New version of length which can handle NA's: if na.rm==T, don't count them
        length2 <- function (x, na.rm=FALSE) {
          if (na.rm) sum(!is.na(x))
          else length(x)
        }
        
        # This does the summary. For each group's data frame, return a vector with
        # N, mean, and sd
        datac <- ddply(data, groupvars, .drop=.drop,.fun = function(xx, col) {
          c(N = length2(xx[[col]], na.rm=na.rm),
            median = median(xx[[col]], na.rm=na.rm),
            sd = sd(xx[[col]], na.rm=na.rm))
        },measurevar)
        
        # Rename the "mean" column    
        datac <- rename(datac, c("median" = measurevar))
        
        datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
        
        # Confidence interval multiplier for standard error
        # Calculate t-statistic for confidence interval: 
        # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
        ciMult <- qt(conf.interval/2 + .5, datac$N-1)
        datac$ci <- datac$se * ciMult
        
        return(datac)
      }
      
      # Read in fish data
      setwd(path)
      fish <- read.table(file, header = T)
      
      # Identify control and treatment variables (assumes that control begins with "WT")
      conditions <- unique(fish$Condition)
      for(c in conditions) {
        condition <- substr(c, start = 1, stop = 2)
        if(condition == "WT") {
          control <- c
        }
        else {
          active <- c
        }
        if(exists("control") && exists("active")) {
          break
        }
      }
      
      # Seperate data based on treatment
      fish0 <- fish[fish$Condition == control,]
      fish1 <- fish[fish$Condition == active,]
      
      # Create variable with summary statistics
      sumfish <- summarySE(fish, measurevar = "AverageOrientation", groupvars = c("Condition","Coherence"))
      
      # Find minimum and maximum values for y-axis
      plotmax <- ceiling(max(fish$AverageOrientation))
      plotmin <- floor(min(fish$AverageOrientation))
      
      ## Create lineplot ##
      lineplot <- ggplot(sumfish, aes(x=Coherence, y=AverageOrientation, colour=Condition)) + 
        geom_errorbar(aes(ymin = AverageOrientation - se, ymax= AverageOrientation + se), width=2) +
        geom_line(linewidth = 1.2) +
        geom_point(size = 2) +
        scale_y_continuous(limits = c(plotmin,plotmax)) +
        scale_colour_manual(values = c(color, "#d0e0e3ff")) +
        theme_minimal() +
        theme(legend.position = "top") + theme(legend.position="none")
      
      ## Prepare Data for Boxplots 
      fish0$Coherence <- factor(fish0$Coherence, levels = c(0,25,50,100))
      fish1$Coherence <- factor(fish1$Coherence, levels = c(0,25,50,100))
      combined_fish <- rbind(fish0, fish1)
      
      # Combine the datasets
      combineddata <- rbind(fish0, fish1)
      
      ## Create Boxplots ##
      boxplot <- ggplot(combineddata, aes(x = Coherence, y = AverageOrientation, fill = Condition)) +
        geom_boxplot() +
        scale_y_continuous(limits = c(plotmin,plotmax)) +
        scale_fill_manual(values = c(color, "#d0e0e3ff")) +
        theme_minimal() + theme(legend.position="none")
      
      # Combine plots horizontally
      combined <- plot_grid(lineplot,boxplot, ncol = 2)
      
      # Extract a legend that is laid out horizontally
      legend <- get_legend(
        boxplot + 
          guides(color = guide_legend(nrow = 1)) +
          theme(legend.position = "bottom")
      )
      
      # Add the legend to the bottom of the plots
      final <- plot_grid(combined, legend, ncol = 1, rel_heights = c(1, .1))
      
      # Save plot image
      imagename <- paste(active,"orientationchange.jpg",sep="_")
      ggsave(imagename, plot = final, width = 7, height = 3)
    }
    plot.boutrate <- function(color, file, path) {
      library(ggplot2)
      library(cowplot)
      
      # Create summary statistics function (modified from cookbook-r.com by Winston Chang)
      summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,conf.interval=.95, .drop=TRUE) {
        library(plyr)
        # New version of length which can handle NA's: if na.rm==T, don't count them
        length2 <- function (x, na.rm=FALSE) {
          if (na.rm) sum(!is.na(x))
          else length(x)
        }
        
        # This does the summary. For each group's data frame, return a vector with
        # N, mean, and sd
        datac <- ddply(data, groupvars, .drop=.drop,.fun = function(xx, col) {
          c(N = length2(xx[[col]], na.rm=na.rm),
            median = median(xx[[col]], na.rm=na.rm),
            sd = sd(xx[[col]], na.rm=na.rm))
        },measurevar)
        
        # Rename the "mean" column    
        datac <- rename(datac, c("median" = measurevar))
        
        datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
        
        # Confidence interval multiplier for standard error
        # Calculate t-statistic for confidence interval: 
        # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
        ciMult <- qt(conf.interval/2 + .5, datac$N-1)
        datac$ci <- datac$se * ciMult
        
        return(datac)
      }
      
      # Read in fish data
      setwd(path)
      fish <- read.table(file, header = T)
      
      # Identify control and treatment variables (assumes that control begins with "WT")
      conditions <- unique(fish$Condition)
      for(c in conditions) {
        condition <- substr(c, start = 1, stop = 2)
        if(condition == "WT") {
          control <- c
        }
        else {
          active <- c
        }
        if(exists("control") && exists("active")) {
          break
        }
      }
      
      # Seperate data based on treatment
      fish0 <- fish[fish$Condition == control,]
      fish1 <- fish[fish$Condition == active,]
      
      # Create variable with summary statistics
      sumfish <- summarySE(fish, measurevar = "AverageBouts", groupvars = c("Condition","Coherence"))
      
      # Find maximum value for y-axis
      plotmax <- ceiling(max(fish$AverageBouts))
      
      ## Create lineplot ##
      lineplot <- ggplot(sumfish, aes(x=Coherence, y=AverageBouts, colour=Condition)) + 
        geom_errorbar(aes(ymin = AverageBouts - se, ymax= AverageBouts + se), width=2) +
        geom_line(linewidth = 1.2) +
        geom_point(size = 2) +
        scale_y_continuous(limits = c(0,plotmax)) +
        scale_colour_manual(values = c(color, "#d0e0e3ff")) +
        theme_minimal() +
        theme(legend.position = "top") + theme(legend.position="none")
      
      ## Prepare Data for Boxplots 
      fish0$Coherence <- factor(fish0$Coherence, levels = c(0,25,50,100))
      fish1$Coherence <- factor(fish1$Coherence, levels = c(0,25,50,100))
      combined_fish <- rbind(fish0, fish1)
      
      # Combine the datasets
      combineddata <- rbind(fish0, fish1)
      
      ## Create Boxplots ##
      boxplot <- ggplot(combineddata, aes(x = Coherence, y = AverageBouts, fill = Condition)) +
        geom_boxplot() +
        scale_y_continuous(limits = c(0,plotmax)) +
        scale_fill_manual(values = c(color, "#d0e0e3ff")) +
        theme_minimal() + theme(legend.position="none")
      
      # Combine plots horizontally
      combined <- plot_grid(lineplot,boxplot, ncol = 2)
      
      # Extract a legend that is laid out horizontally
      legend <- get_legend(boxplot + 
                             guides(color = guide_legend(nrow = 1)) +
                             theme(legend.position = "bottom")
      )
      
      # Add the legend to the bottom of the plots
      final <- plot_grid(combined, legend, ncol = 1, rel_heights = c(1, .1))
      
      # Save plot image
      imagename <- paste(active,"boutrate.jpg",sep="_")
      ggsave(imagename, plot = final, width = 7, height = 3)
    }
  }
  
  ## Create functions to perform Fisher's test via several t-statistics ##
  fishertest.mean <- function(randomizations = 100000, measure, plot, file, path) {
    library(ggplot2)
    
    # Read in fish data
    setwd(path)
    fish <- read.table(file, header = T)
    
    # Identify control and treatment variables (assumes that control begins with "WT")
    conditions <- unique(fish$Condition)
    for(c in conditions) {
      condition <- substr(c, start = 1, stop = 2)
      if(condition == "WT") {
        control <- c
      }
      else {
        active <- c
      }
      if(exists("control") && exists("active")) {
        break
      }
    }
    
    # Replace control treatment with 0 and active treatment with 1
    fish$Condition[fish$Condition == control] <- 0
    fish$Condition[fish$Condition == active] <- 1
    
    # Calculates ideal randomizations (using ideal is often too computationally intensive)
    #idealrandomizations <- choose(length(fish$Condition),length(fish$Condition[fish$Condition == 1]))
    #cat("n:",length(fish$Condition),"\nk:",length(fish$Condition[fish$Condition == 1]),"\nidealrandomizations:",idealrandomizations)
    
    # Create a science table
    fishN <- length(fish$Condition)
    sciencefish <- data.frame(i = c(1:fishN),
                              W.obs = fish$Condition,
                              Y.obs = fish[[measure]],
                              Y.0 = rep(c(NA), times = fishN),
                              Y.1 = rep(c(NA), times = fishN))
    
    # Assign observed values to corresponding treatment columns
    for (i in sciencefish$i) {
      if (sciencefish$W.obs[i] == 0) {
        sciencefish$Y.0[i] <- sciencefish$Y.obs[i]
      } else {
        sciencefish$Y.1[i] <- sciencefish$Y.obs[i]
      }
    }
    
    # Calculate observed test statistic
    Tobs <- mean(sciencefish$Y.1, na.rm = T) - mean(sciencefish$Y.0, na.rm = T)
    
    # Create matrix to store treatment randomizations
    randomizationsmatrix <- matrix(NA,fishN,randomizations)
    
    # Fill matrix with unique randomizations
    for (i in 1:randomizations) {
      randomizationsmatrix[,i] <- sample(sciencefish$W.obs)
    }
    randomizationsmatrix <- unique(randomizationsmatrix)
    
    # Create list to store test statistics
    tstats <- rep(NA, length = length(randomizationsmatrix[1,]))
    
    # Calculate test statistic for each permutation
    for(i in 1:randomizations){
      tstats[i] <- mean(sciencefish$Y.obs[randomizationsmatrix[, i] == 1]) -
        mean(sciencefish$Y.obs[randomizationsmatrix[, i] == 0])
    }
    
    # Convert list to dataframe
    tstatsframe <- data.frame(stats=tstats)
    
    if(plot) {
      # Create plot title
      plottitle <- paste("Null randomization distribution for the diference in means between\n",
                         measure, " in ", active, " vs ", control, " fish", sep = "")
      
      ## Create null randomization distribution histogram
      nullrandomization <- ggplot(tstatsframe, aes(x=stats)) +
        geom_histogram(color="black",fill="gray", bins = 50) +
        labs(title = plottitle, y = "Frequency", x = "Null randomization of the t-statistic") +
        geom_vline(aes(xintercept=Tobs), color="red",linewidth=1.5)
      
      # Save plot image
      imagename <- paste(active,measure,"mean.jpg",sep="_")
      ggsave(imagename, plot = nullrandomization, width = 7, height = 5)
    }
    
    # Calculate and print p-value (if 0, print as less than 1/randomizations)
    pval <- sum(tstats <= Tobs)/length(tstats)
    if(pval == 0) {
      cat("T = Mean: <",(1/randomizations),"\n")
    } else {
      cat("T = Mean:",pval,"\n")
    }
  }
  fishertest.area <- function(randomizations = 100000, measure, plot, file, path) {
    library(ggplot2)
    
    # Read in fish data
    setwd(path)
    fish <- read.table(file, header = T)
    
    # Identify control and treatment variables (assumes that control begins with "WT")
    conditions <- unique(fish$Condition)
    for(c in conditions) {
      condition <- substr(c, start = 1, stop = 2)
      if(condition == "WT") {
        control <- c
      }
      else {
        active <- c
      }
      if(exists("control") && exists("active")) {
        break
      }
    }
    
    # Separate data based on treatment
    fish0 <- fish[fish$Condition == control,]
    fish1 <- fish[fish$Condition == active,]
    
    # Replace control treatment with 0 and active treatment with 1
    fish$Condition[fish$Condition == control] <- 0
    fish$Condition[fish$Condition == active] <- 1
    
    # Create a science table
    fishN <- length(fish$Condition)
    sciencefish <- data.frame(i = c(1:fishN),
                              W.obs = fish$Condition,
                              Y.obs = fish[[measure]],
                              Y.0 = rep(c(NA), times = fishN),
                              Y.1 = rep(c(NA), times = fishN))
    
    # Assign observed values to corresponding treatment columns
    for (i in sciencefish$i) {
      if (sciencefish$W.obs[i] == 0) {
        sciencefish$Y.0[i] <- sciencefish$Y.obs[i]
      } else {
        sciencefish$Y.1[i] <- sciencefish$Y.obs[i]
      }
    }
    
    # Calculate median for each coherence within control fish
    coh0 <- median(fish0[[measure]][fish0$Coherence == 0])
    coh25 <- median(fish0[[measure]][fish0$Coherence == 25])
    coh50 <- median(fish0[[measure]][fish0$Coherence == 50])
    coh100 <- median(fish0[[measure]][fish0$Coherence == 100])
    
    # Calculate median for each coherence within treated fish
    coh1.0 <- median(fish1[[measure]][fish1$Coherence == 0])
    coh1.25 <- median(fish1[[measure]][fish1$Coherence == 25])
    coh1.50 <- median(fish1[[measure]][fish1$Coherence == 50])
    coh1.100 <- median(fish1[[measure]][fish1$Coherence == 100])
    
    # Create list of coherences 
    coherences <- c(0,25,50,100)
    
    # Create list of median values for each coherence
    fish0turns <- c(coh0,coh25, coh50, coh100)
    fish1turns <- c(coh1.0, coh1.25, coh1.50, coh1.100)
    
    # Define the functions representing the lines
    line0 <- approxfun(as.numeric(coherences), fish0turns)
    line1 <- approxfun(as.numeric(coherences), fish1turns)
    
    # Define the function to calculate the difference between the two lines
    difference <- function(x) {
      line1(x) - line0(x)
    }
    
    # Find the area between the lines using numerical integration
    # Set as observed statistic
    area <- integrate(difference, lower = 0, upper = 100)$value
    Tobs <- area
    
    # Create matrix to store treatment randomizations
    randomizationsmatrix <- matrix(NA,fishN,randomizations)
    
    # Fill matrix with unique randomizations
    for (i in 1:randomizations) {
      randomizationsmatrix[,i] <- sample(sciencefish$W.obs)
    }
    randomizationsmatrix <- unique(randomizationsmatrix)
    
    # Create list to store test statistics
    tstats <- rep(NA, length = length(randomizationsmatrix[1,]))
    
    # Calculate test statistic for each randomization 
    for(i in 1:randomizations) {
      fishtemp <- fish
      fishtemp$Condition <- randomizationsmatrix[,i]
      fish0 <- fishtemp[fishtemp$Condition == 0,]
      fish1 <- fishtemp[fishtemp$Condition == 1,]
      
      #calculate median for each coherence within control fish
      coh0 <- median(fish0[[measure]][fish0$Coherence == 0])
      coh25 <- median(fish0[[measure]][fish0$Coherence == 25])
      coh50 <- median(fish0[[measure]][fish0$Coherence == 50])
      coh100 <- median(fish0[[measure]][fish0$Coherence == 100])
      
      #calculate median for each coherence within treated fish
      coh1.0 <- median(fish1[[measure]][fish1$Coherence == 0])
      coh1.25 <- median(fish1[[measure]][fish1$Coherence == 25])
      coh1.50 <- median(fish1[[measure]][fish1$Coherence == 50])
      coh1.100 <- median(fish1[[measure]][fish1$Coherence == 100])
      
      # Create list of median values for each coherence
      fish0points <- c(coh0,coh25, coh50, coh100)
      fish1points <- c(coh1.0, coh1.25, coh1.50, coh1.100)
      
      # Define the functions representing the lines
      line0 <- approxfun(as.numeric(coherences), fish0points)
      
      line1 <- approxfun(as.numeric(coherences), fish1points)
      
      # Define the function to calculate the difference between the two lines
      difference <- function(x) {
        line1(x) - line0(x)
      }
      
      # Find the area between the lines using numerical integration
      area <- integrate(difference, lower = 0, upper = 100)$value
      tstats[i] <- area
    }
    
    # Convert list to dataframe 
    tstatsframe <- data.frame(stats=tstats)
    
    if(plot) {
      # Create plot title
      plottitle <- paste("Null randomization distribution for the area between\n",
                         measure, " in ", active, " vs ", control, " fish", sep = "")
      
      # Create null randomization distribution histogram
      nullrandomization <- ggplot(tstatsframe, aes(x=stats)) +
        geom_histogram(color="black",fill="gray", bins = 30) +
        labs(title = plottitle, y = "Frequency", x = "Null randomization of the t-statistic") +
        geom_vline(aes(xintercept=Tobs), color="red",linewidth=1.5)
      
      # Save plot image
      imagename <- paste(active,measure,"area.jpg",sep="_")
      ggsave(imagename, plot = nullrandomization, width = 7, height = 5)
    }
    
    # Calculate and print p-value (if 0, print as less than 1/randomizations)
    pval <- sum(tstats <= Tobs)/length(tstats)
    if(pval == 0) {
      cat("T = Area: <",(1/randomizations),"\n")
    } else {
      cat("T = Area:",pval,"\n")
    }
    
  }
  fishertest.mean.coherence <- function(randomizations = 100000, measure,coherence, plot, file, path) {
    library(ggplot2)
    
    # Read in fish data
    setwd(path)
    fish <- read.table(file, header = T)
    
    # Identify control and treatment variables (assumes that control begins with "WT")
    conditions <- unique(fish$Condition)
    for(c in conditions) {
      condition <- substr(c, start = 1, stop = 2)
      if(condition == "WT") {
        control <- c
      }
      else {
        active <- c
      }
      if(exists("control") && exists("active")) {
        break
      }
    }
    
    # Select data at provided coherence
    fish <- fish[fish$Coherence == coherence,]
    
    # Remove columns other than treatment and measures
    fish <- fish[, -c(1, 3)]
    
    # Replace control treatment with 0 and active treatment with 1
    fish$Condition[fish$Condition == control] <- 0
    fish$Condition[fish$Condition == active] <- 1
    
    # Create a science table
    fishN <- length(fish$Condition)
    sciencefish <- data.frame(i = c(1:fishN),
                              W.obs = fish$Condition,
                              Y.obs = fish[[measure]],
                              Y.0 = rep(c(NA), times = fishN),
                              Y.1 = rep(c(NA), times = fishN))
    
    # Assign observed values to corresponding treatment columns
    for (i in sciencefish$i) {
      if (sciencefish$W.obs[i] == 0) {
        sciencefish$Y.0[i] <- sciencefish$Y.obs[i]
      } else {
        sciencefish$Y.1[i] <- sciencefish$Y.obs[i]
      }
    }
    
    # Calculate observed test statistic
    Tobs <- mean(sciencefish$Y.1, na.rm = T) - mean(sciencefish$Y.0, na.rm = T)
    
    # Create matrix to store treatment randomizations
    randomizationsmatrix <- matrix(NA,fishN,randomizations)
    
    # Fill matrix with unique randomizations
    for (i in 1:randomizations) {
      randomizationsmatrix[,i] <- sample(sciencefish$W.obs)
    }
    randomizationsmatrix <- unique(randomizationsmatrix)
    
    # Create list to store test statistics
    tstats <- rep(NA, length = length(randomizationsmatrix[1,]))
    
    # Calculate test statistic for each permutation
    for(i in 1:randomizations){
      tstats[i] <- mean(sciencefish$Y.obs[randomizationsmatrix[, i] == 1]) -
        mean(sciencefish$Y.obs[randomizationsmatrix[, i] == 0])
    }
    
    # Convert list to dataframe
    tstatsframe <- data.frame(stats=tstats)
    
    if(plot) {
      # Create plot title
      plottitle <- paste("Null randomization distribution for the mean at coherence ", coherence, " between\n",
                         measure, " in ", active, " vs ", control, " fish", sep = "")
      
      # Create null randomization distribution histogram
      nullrandomization <- ggplot(tstatsframe, aes(x=stats)) +
        geom_histogram(color="black",fill="gray", bins = 30) +
        labs(title = plottitle, y = "Frequency", x = "Null randomization of the t-statistic") +
        geom_vline(aes(xintercept=Tobs), color="red",linewidth=1.5)
      
      # Save plot image
      imagename <- paste(active,measure,coherence,"mean.jpg",sep="_")
      ggsave(imagename, plot = nullrandomization, width = 7, height = 5)
    }
    
    # Calculate and print p-value (if 0, print as less than 1/randomizations)
    pval <- sum(tstats <= Tobs)/length(tstats)
    if(pval == 0) {
      cat("T = Mean at coherence ", coherence," : < ",(1/randomizations),"\n",sep="")
    } else {
      cat("T = Mean at coherence ", coherence, ": ",pval,"\n",sep="")
    }
  }
  fishertest.variance.coherence <- function(randomizations = 100000, measure, coherence, plot, file, path) {
    library(ggplot2)
    
    # Read in fish data
    setwd(path)
    fish <- read.table(file, header = T)
    
    # Identify control and treatment variables (assumes that control begins with "WT")
    conditions <- unique(fish$Condition)
    for(c in conditions) {
      condition <- substr(c, start = 1, stop = 2)
      if(condition == "WT") {
        control <- c
      }
      else {
        active <- c
      }
      if(exists("control") && exists("active")) {
        break
      }
    }
    
    # Select data at provided coherence
    fish <- fish[fish$Coherence == coherence,]
    
    # Remove columns other than treatment and measures
    fish <- fish[, -c(1, 3)]
    
    # Replace control treatment with 0 and active treatment with 1
    fish$Condition[fish$Condition == control] <- 0
    fish$Condition[fish$Condition == active] <- 1
    
    # Create a science table
    fishN <- length(fish$Condition)
    sciencefish <- data.frame(i = c(1:fishN),
                              W.obs = fish$Condition,
                              Y.obs = fish[[measure]],
                              Y.0 = rep(c(NA), times = fishN),
                              Y.1 = rep(c(NA), times = fishN))
    
    # Assign observed values to corresponding treatment columns
    for (i in sciencefish$i) {
      if (sciencefish$W.obs[i] == 0) {
        sciencefish$Y.0[i] <- sciencefish$Y.obs[i]
      } else {
        sciencefish$Y.1[i] <- sciencefish$Y.obs[i]
      }
    }
    
    # Calculate observed test statistic
    Tobs <- var(sciencefish$Y.1, na.rm = T) - var(sciencefish$Y.0, na.rm = T)
    
    # Create matrix to store treatment randomizations
    randomizationsmatrix <- matrix(NA,fishN,randomizations)
    
    # Fill matrix with unique randomizations
    for (i in 1:randomizations) {
      randomizationsmatrix[,i] <- sample(sciencefish$W.obs)
    }
    randomizationsmatrix <- unique(randomizationsmatrix)
    
    # Create list to store test statistics
    tstats <- rep(NA, length = length(randomizationsmatrix[1,]))
    
    # Calculate test statistic for each permutation
    for(i in 1:randomizations){
      tstats[i] <- var(sciencefish$Y.obs[randomizationsmatrix[, i] == 1]) -
        var(sciencefish$Y.obs[randomizationsmatrix[, i] == 0])
    }
    
    # Convert list to dataframe
    tstatsframe <- data.frame(stats=tstats)
    
    if(plot) {
      # Create plot title
      plottitle <- paste("Null randomization distribution for the variance at coherence ", coherence, " between\n",
                         measure, " in ", active, " vs ", control, " fish", sep = "")
      
      # Create null randomization distribution histogram
      nullrandomization <- ggplot(tstatsframe, aes(x=stats)) +
        geom_histogram(color="black",fill="gray", bins = 30) +
        labs(title = plottitle, y = "Frequency", x = "Null randomization of the t-statistic") +
        geom_vline(aes(xintercept=Tobs), color="red",linewidth=1.5)
      
      # Save plot image
      imagename <- paste(active,measure,coherence,"variance.jpg",sep="_")
      ggsave(imagename, plot = nullrandomization, width = 7, height = 5)
    }
    
    # Calculate and print p-value (if 0, print as less than 1/randomizations)
    pval <- sum(tstats <= Tobs)/length(tstats)
    if(pval == 0) {
      cat("T = Variance at coherence ",coherence,": <",(1/randomizations),"\n",sep="")
    } else {
      cat("T = Variance at coherence ",coherence,": ",pval,"\n",sep="")
    }
  }
  
  # Set working directory
  setwd(path)
  
  # Create descriptive plots
  plot.correctturn("orange", file, path)
  plot.orientation("orange", file, path)
  plot.boutrate("orange", file, path)
  
  # Store behavior measures to be tested
  behaviormeasures <- c("CorrectTurn","AverageBouts","AverageOrientation")
  
  # Loop through each measure and output text file with p-values for each
  for(measure in behaviormeasures) {
    treatment <- substr(file, 1, nchar(file) - 4)
    filename <- paste(treatment,measure,"pvals.txt",sep="_")
    sink(filename)
    fishertest.mean(randomizations, measure, fisherplot, file, path)
    fishertest.area(randomizations, measure, fisherplot, file, path)
    fishertest.mean.coherence(randomizations, measure, 0, fisherplot, file, path)
    fishertest.mean.coherence(randomizations, measure, 25, fisherplot, file, path)
    fishertest.mean.coherence(randomizations, measure, 50, fisherplot, file, path)
    fishertest.mean.coherence(randomizations, measure, 100, fisherplot, file, path)
    fishertest.variance.coherence(randomizations, measure, 0, fisherplot, file, path)
    fishertest.variance.coherence(randomizations, measure, 25, fisherplot, file, path)
    fishertest.variance.coherence(randomizations, measure, 50, fisherplot, file, path)
    fishertest.variance.coherence(randomizations, measure, 100, fisherplot, file, path)
    sink()
  }
} 
