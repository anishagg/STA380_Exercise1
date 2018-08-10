library(ggplot2)
library(LICORS)  # for kmeans++
library(foreach)
library(mosaic)

sm <- read.csv("C:/Users/garga/Desktop/Predictive Modelling/James Scott/STA380-master/data/social_marketing.csv", row.names=1)
head(sm, 10)
sum = sort(colSums(sm),decreasing = TRUE)
barplot(sum,las=2)

# Center/scale the data
X <- scale(sm, center=TRUE, scale=TRUE) 

# Using kmeans++ initialization
k_max = 20
cost = rep(0, k_max)
set.seed(100)
for (i in 1:k_max){
clust1 = kmeanspp(X, k=i, nstart=25)
cost[i] = clust1$tot.withinss
print(i)
}
cost
plot(1:k_max, cost,
     type="b", pch = 19,
     xlab="Number of clusters K",
     ylab="Total within-clusters")

k_opt = 10
set.seed(100)
clust1 = kmeanspp(X, k=k_opt, nstart=25)
View(sort(t(clust1$center)[,4],decreasing = TRUE))

heads=NULL
tails=NULL
for (i in (1:10)){
  o = order((t(clust1$center)[,i]), decreasing=TRUE)
  heads = rbind(heads,colnames(sm)[head(o,3)])
  tails = rbind(tails,colnames(sm)[tail(o,3)])
}
View(heads)
View(tails)


summary(factor(clust1$cluster))
result_clust1 = cbind(sm, clusterNum = clust1$cluster)

par(mfrow = c(3,4))
for (i in 1:10){
c = result_clust1[which(result_clust1$clusterNum == i),]
slice = sort(colSums(c)[-37],decreasing = TRUE)[1:6]
barplot(slice, main=paste("cluster",i),las=2,ylim = c(0,11000))
}


###########PCA

pc = prcomp(sm, scale.=TRUE)
# Look at the basic plotting and summary methods
summary(pc)
par(mfrow = c(1,1))
plot(pc,type='l')
# Question 1: where do the individual points end up in PC space?
loadings = pc$rotation

heads = NULL
tails = NULL
for (i in (1:36)){
o1 = order((loadings[,i]), decreasing=TRUE)
heads = rbind(heads,colnames(sm)[head(o1,4)])
tails = rbind(tails,colnames(sm)[tail(o1,4)])
}
View(heads)
View(tails)

## Cluster Plot against 1st 2 principal components
X1 <- scale(pc$x, center=TRUE, scale=TRUE) 
# Ward Hierarchical Clustering
d_pc = dist(X1[,1:16], method = "euclidean") # distance matrix
set.seed(100)
clust2 = hclust(d_pc, method="ward")
plot(clust2) # display dendogram
groups = cutree(clust2, k=10) # cut tree into 10 clusters
# draw dendogram with red borders around the 10 clusters 
rect.hclust(clust2, k=10, border="red")
result_clust2 = cbind(sm, clusterNum = groups)

par(mfrow = c(3,4))
for (i in 1:10){
  c = result_clust2[which(result_clust2$clusterNum == i),]
  slice = sort(colSums(c)[-37],decreasing = TRUE)[1:6]
  barplot(slice, main=paste("cluster",i),las=2,ylim = c(0,11000))
}

summary(factor(clust1$cluster))
summary(factor(groups))



# # vary parameters for most readable graph
library(cluster)
clusplot(sm, clust3$cluster, color=TRUE, shade=TRUE,
         labels=2, lines=0)



sm <- sm[c(-1)]
