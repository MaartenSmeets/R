#!/bin/env Rscript


library(ggplot2)

d <- rbind(
    data.frame(
        "i" = 1:100,
        "x" = rnorm(100, 2, 1),
        "y" = rnorm(100, 2, 1),
        "pop" = "A"),
    data.frame(
        "i" = 1:100,
        "x" = rnorm(100, 6, 1),
        "y" = rnorm(100, 6, 1),
        "pop" = "B"))

ggplot(d) +
    geom_point(aes(x = x, y = y, colour = pop)) +
    theme(aspect.ratio = 1)

#'
#'
library(randomForest)

model <- randomForest(d[,1:3], y = d$pop)

tst <- data.frame(
        "i" = 1:100,
        "x" = rnorm(100, 2, 1),
        "y" = rnorm(100, 2, 1))

rsp <- predict(model, test)

x <- tst
x$pop <- rsp
x$type <- "predicted"
y <- d
y$type <- "original"

ggplot(rbind(x, y)) +
    geom_point(aes(x = x, y = y, colour = pop)) +
    facet_wrap(~ type) +
    theme(aspect.ratio = 1)
