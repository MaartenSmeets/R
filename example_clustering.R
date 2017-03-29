#!/bin/env Rscript

library(randomForest)

install.packages("neuralnet")


library(ggplot2)

d <- rbind(
    data.frame(
        "x" = rnorm(100, 2, 1),
        "y" = rnorm(100, 2, 1),
        "pop" = "A"),
    data.frame(
        "x" = rnorm(100, 4, 1),
        "y" = rnorm(100, 4, 1),
        "pop" = "B"))

ggplot(d) +
    geom_point(aes(x = x, y = y, colour = pop)) +
    theme(aspect.ratio = 1)
