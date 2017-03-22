#!/bin/env Rscript


#' Read a simple table
#'
dataset <- read.table("dataset.txt", sep = "\t", header = TRUE, stringsAsFactors = TRUE)
dataset$X <- as.numeric(dataset$X)

#'
#'
library(ggplot2)

# add data later
p <- ggplot()
p <- p + geom_point(aes(x = Letter, y = X), data = dataset)
p

# add data directly
p <- ggplot(dataset)
p <- p + geom_boxplot(aes(x = Letter, y = X))
p <- p + geom_point(aes(x = Letter, y = X))
p 

# map data to properties
p <- ggplot(dataset)
p <- p + geom_point(aes(x = Letter, y = X, colour = Letter), shape = 2)
p <- p + scale_colour_manual(values = c("A" = "red", "B" = "blue", "C" = "black"))
p 

