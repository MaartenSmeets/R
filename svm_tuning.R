library(ggplot2)
library(e1071)

alligator = data.frame(
  lnLength = c(3.87, 3.61, 4.33, 3.43, 3.81, 3.83, 3.46, 3.76,
               3.50, 3.58, 4.19, 3.78, 3.71, 3.73, 3.78),
  lnWeight = c(4.87, 3.93, 6.46, 3.33, 4.38, 4.70, 3.50, 4.50,
               3.58, 3.64, 5.90, 4.43, 4.38, 4.42, 4.25)
)

#alli.mod1 = svm(alligator$lnLength,alligator$lnWeight)

tuneResult <- tune(svm,lnWeight ~ lnLength,
                   data=alligator,
                   ranges = list(epsilon=seq(0,0.4,0.01),cost=2^(2:9)))

plot(tuneResult)

tunedModel <- tuneResult$best.model

perc <- c(0:100)

#go from min value to max value of length in steps of 1%
lengthtopredict <- ((max(alligator$lnLength)-
                       min(alligator$lnLength))/100 * perc) +min(alligator$lnLength)

lengthtopredict

prediction <- data.frame (lnLength=lengthtopredict,lnWeight=c(0:100))

predictedweight <- predict(tunedModel, newdata=prediction)

prediction$lnWeight <- predictedweight
alligatorprediction <- data.frame(lnLength = lengthtopredict, 
                                  lnWeight = predictedweight)

ggplot(alligator,aes(x = alligator$lnLength, 
                      y = alligator$lnWeight))+ 
    labs(x="lnLength",y="lnWeight") +
    geom_point() +
    geom_point(data=alligatorprediction, 
               aes(x=alligatorprediction$lnLength,
                   y=alligatorprediction$lnWeight), 
               col = "red", pch=4)


    