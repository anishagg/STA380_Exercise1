setwd("C:/Users/garga/Desktop/Predictive Modelling/James Scott/STA380-master/data")
getwd()
gb = read.csv("greenbuildings.csv")
attach(gb)
#View(gb)
names(gb)
par(mfrow = c(1,1))

library (caret)


plot(green_rating,Rent,xlab = "green", ylab = "rent", pch=19,cex=1.5)
boxplot(gb$age~green_rating,xlab = "green", ylab = "Age of building", pch=1,cex=0.5, main = "Relation between age and green certification")
plot(age,Rent,xlab = "age", ylab = "rent", pch=1,cex=0.5)
plot(Electricity_Costs,Rent)
plot(Gas_Costs,Rent)
boxplot(Rent,as.factor(green_rating))
# boxplot(leasing_rate~green_rating, xlab="Green rating", ylab = "leasing rate", main = "Leasing rate variations")
tb = table(as.factor(class_a),as.factor(green_rating))
names(dimnames(tb)) <- c("class_a", "green_rating")
tb
# Reference
# Prediction    0    1
# 0 4598  139
# 1 2611  546

mod = glm(Rent~green_rating)
summary(mod)

mod1 = glm(Rent~green_rating+age)
summary(mod1)

mod2 = glm(Rent~green_rating+class_a)
summary(mod2)

mod3 = glm(Rent~green_rating+class_a+gb$age)
summary(mod3)

mod_all = glm(Rent~.,data=gb)
summary(mod_all)

gb_nonNA <- gb[rowSums(is.na(gb)) == 0,]
dat <- as.data.frame(sapply(gb_nonNA[,c(-5)], as.numeric))
Rt = as.numeric(gb_nonNA$Rent)
XXgb1 <- model.matrix(gb_nonNA$Rent~.*green_rating, data=data.frame(scale(dat)))[,c(-1,-5)]
gb_mat = as.data.frame(data.frame(XXgb1,Rt))
mod4 = glm(Rt~.,data=gb_mat)
summary(mod4)

# 
# clean_gb = gb[gb[,"leasing_rate"] > 0.1,]
# plot(clean_gb$green_rating,clean_gb$Rent,xlab = "green", ylab = "rent", pch=19,cex=1.5)
# boxplot(clean_gb$Rent~clean_gb$green_rating)
# dim(gb)
# 
# bad_gb = gb[gb[,"leasing_rate"] <= 0.1,]
# plot(bad_gb$green_rating,bad_gb$Rent,xlab = "green", ylab = "rent", pch=19,cex=1.5)
# boxplot(bad_gb$Rent~bad_gb$green_rating)
# plot(bad_gb$cluster,bad_gb$Rent,xlab = "cluster", ylab = "rent", pch=1,cex=0.5)

green = gb[gb[,"green_rating"] == 1,]
non_green = gb[gb[,"green_rating"] == 0,]
boxplot(green$Rent)
boxplot(green$Gas_Costs, xlab="Gas costs in Green buildings")
boxplot(non_green$Gas_Costs, xlab="Gas costs in non-Green buildings")
summary(green$Gas_Costs)
summary(non_green$Gas_Costs)

boxplot(green$Electricity_Costs, xlab="electricity costs in Green buildings")
boxplot(non_green$Electricity_Costs, xlab="electricity costs in non-Green buildings")
summary(green$Electricity_Costs)
summary(non_green$Electricity_Costs)


names(gb)


plot(green$cluster,green$Rent,xlab = "green_cluster", ylab = "rent", pch=1,cex=0.5)
plot(non_green$cluster,non_green$Rent,xlab = "non_green_cluster", ylab = "rent", pch=1,cex=0.5)

#View(green)
#rent = 138 for cluster 567

View(non_green)
#rent 20 - 105 for cluster 567

cl_no567 = gb[gb[,"cluster"] != 567,]
green_no567 = cl_no567[cl_no567[,"green_rating"] == 1,]
non_green_no567 = cl_no567[cl_no567[,"green_rating"] == 0,]
boxplot(green$Rent)
summary(green_no567$Rent)


plot(green$cluster,green$cluster_rent,xlab = "cluster", ylab = "cluster_rent", pch=1,cex=0.5)

plot(stories,Rent,xlab = "stories", ylab = "rent", pch=1,cex=0.5)

storey_15 = gb[gb[,"stories"] == 15,]
green_15 = storey_15[storey_15[,"green_rating"] == 1,]
non_green_15 = storey_15[storey_15[,"green_rating"] == 0,]
boxplot(green_15$Rent, xlab = "Green buildings with 15 stories")
boxplot(non_green_15$Rent, xlab = "Non Green buildings with 15 stories")
summary(green_15$Rent)
summary(non_green_15$Rent)

# > summary(green_15$Rent)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 15.75   30.04   36.95   34.95   40.54   49.80 
# > summary(non_green_15$Rent)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 8.00   18.38   24.36   26.29   33.02   50.55 

nrow(green_15) #10
nrow(non_green_15) #156

names(gb)
nrow(green)
sum(green$Energystar)

boxplot(green$Rent~green$Energystar, xlab="Energystar", ylab = "Rent", main = "Variation of rent among green buildings")
boxplot(green$Rent~green$Energystar)$stats
summary()


par(mfrow=c(1,2))
plot(green$size,green$Rent,pch=1,cex=0.5,main="green buildings")
plot(non_green$size,non_green$Rent,pch=1,cex=0.5,main="non-green buildings")

boxplot(size)
summary(size)
size_500 = gb[gb[,"size"] <= 500000,]
green_size = size_500[size_500[,"green_rating"] == 1,]
non_green_size = size_500[size_500[,"green_rating"] == 0,]
boxplot(green_size$Rent, xlab = "Green buildings le 500k sqFt")
boxplot(non_green_size$Rent, xlab = "Non-Green buildings le 500k sqFt")
summary(green_size$Rent)
summary(non_green_size$Rent)

# > summary(green_size$Rent)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 8.87   22.00   28.50   30.59   35.99  138.07 
# > summary(non_green_size$Rent)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 2.98   19.13   25.20   27.89   34.20  200.00 

storey = size_500[size_500[,"stories"] <= 40,]
green_storey = storey[storey[,"green_rating"] == 1,]
non_green_storey = storey[storey[,"green_rating"] == 0,]
boxplot(green_storey$Rent, xlab = "Green buildings with removed anomalies", ylab = "rent")
boxplot(non_green_storey$Rent, xlab = "Non Green buildings with removed anomalies", ylab = "rent")
summary(green_storey$Rent)
summary(non_green_storey$Rent)

boxplot(green_storey$Rent, xlab = "Green buildings with removed anomalies", ylab = "rent")
boxplot(non_green_storey$Rent, xlab = "Non Green buildings with removed anomalies", ylab = "rent")
summary(green_storey$Rent)
summary(non_green_storey$Rent)

# > summary(green_storey$Rent)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 15.75   30.04   36.95   34.95   40.54   49.80 
# > summary(non_green_storey$Rent)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 8.00   18.38   24.36   26.29   33.02   50.55 

par(mfrow = c(1,2))
age = storey[storey[,"age"] <= 5 & storey[,"class_a"] ==1,]
green_AgeStrSz = age[age[,"green_rating"] == 1,]
NONgreen_AgeStrSz = age[age[,"green_rating"] == 0,]
boxplot(green_AgeStrSz$Rent, xlab = "New Green buildings with removed anomalies", ylab = "rent")
boxplot(NONgreen_AgeStrSz$Rent, xlab = "New Non Green buildings with removed anomalies", ylab = "rent")
summary(green_AgeStrSz$Rent)
summary(NONgreen_AgeStrSz$Rent)

# > summary(green_AgeStrSz$Rent)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 12.22   21.15   26.50   29.18   34.25   72.00 
# > summary(NONgreen_AgeStrSz$Rent)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 9.60   22.00   29.54   31.11   37.91   90.00 

size_500 = gb[gb[,"size"] <= 500000 & 100000 <= gb[,"size"],]
filtered_gb = size_500[size_500[,"stories"] <= 30 & size_500[,"stories"] >= 4 ,]

par(mfrow = c(1,2))
aged = filtered_gb[filtered_gb[,"age"] <= 5,]
nrow(aged)
green_AgeStrSz = aged[aged[,"green_rating"] == 1,]
NONgreen_AgeStrSz = aged[aged[,"green_rating"] == 0,]
boxplot(green_AgeStrSz$Rent, xlab = "New Green buildings with removed anomalies", ylab = "rent")
boxplot(NONgreen_AgeStrSz$Rent, xlab = "New Non Green buildings with removed anomalies", ylab = "rent")
summary(green_AgeStrSz$Rent)
summary(NONgreen_AgeStrSz$Rent)

plot(age, Rent, data = filtered_gb)
boxplot(Rent~renovated)
