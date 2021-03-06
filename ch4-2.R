# install.packages("pls")

rm(list = ls())
library(dplyr)
library(pls)
library(ggplot2)
library(GGally)

data(iris)
str(iris)
head(iris)

# 각 변수의 표준화한 값
z_iris <- cbind(stdize(as.matrix(iris[-5])), iris[5])
head(z_iris)


# K-평균 군집분석방법을 이용하여 3개 군집에 대한 군집분석 실시
km_cluster <- kmeans(z_iris[-5], 3)
km_cluster

# 군집 결과를 소속군집 산점도로 표현
pairs(z_iris, col = km_cluster$cluster, pch = 16)
ggpairs(z_iris, aes(colour = as.factor(km_cluster$cluster)))


# K-평균 군집분석의 군집결과와 붓꽃 데이터에 주어져 있는 종류와의 분할표 통해 군집분석의 성능 평가
z_iris2 <- cbind(z_iris, fit = km_cluster$cluster)
confu_mat <- table(z_iris2$Species, z_iris2$fit)
confu_mat

# 성능 평가를 위하여 fit 결과를 분류
confu_mat2 <- table(z_iris2$Species, z_iris2$fit, 
                    dnn = c("setosa", "versicolor", "virginica"))
confu_mat2

# 오분류율 계산
error <- 1 - sum(diag(confu_mat2))/sum(confu_mat2)
error
1- error

# 오분류율 16.7%, 정분류율은 83.3%, 특히 Setosa는 완벽히 분류되었음
