library(mosaic)
library(quantmod)
library(foreach)
library(xts)

# Import a few stocks
mystocks = c("SPY","TLT","LQD","EEM","VNQ")
getSymbols(mystocks, from = "2005-01-01")

# Adjust for splits and dividends
SPYa = adjustOHLC(SPY)
TLTa = adjustOHLC(TLT)
LQDa = adjustOHLC(LQD)
EEMa = adjustOHLC(EEM)
VNQa = adjustOHLC(VNQ)

# Combine close to close changes in a single matrix
all_returns = cbind(ClCl(SPYa),ClCl(TLTa),ClCl(LQDa),ClCl(EEMa),ClCl(VNQa))
all_returns = as.matrix(na.omit(all_returns))
head(all_returns)
pairs(all_returns)


#All the spikes seen in Feb 2008
plot(all_returns[,1], type='l',ylab = "SPY") #-0.05 to 0.05
plot(all_returns[,2], type='l',ylab = "TLT") #-0.02 to 0.02
plot(all_returns[,3], type='l',ylab = "LQD") #-0.01 to 0.01
plot(all_returns[,4], type='l',ylab = "EEM") #-0.05 to 0.05
plot(all_returns[,5], type='l',ylab = "VNQ") #-0.03 to 0.03

# The sample correlation matrix
cor(all_returns)

# Now simulate many different possible scenarios  

##### Scenario A
set.seed(100)
initial_wealth = 100000
sim1 = foreach(i=1:5000, .combine='rbind') %do% {    #Monte-carlo
  total_wealth = initial_wealth
  weights = c(0.2, 0.2, 0.2, 0.2, 0.2)               #Equal splits
  n_days = 20
  wealthtracker = rep(0, n_days)                     #tracking wealth of 20 days for each simulation
  for(today in 1:n_days) {                           #Bootstrap
    return.today = resample(all_returns, 1, orig.ids=FALSE)   #taking a bootstrap sample
    holdings = weights * total_wealth                #redistributing wealth among the ETFs before the start of day
    holdings = holdings + holdings*return.today      #holdings in each ETF at end of the day
    total_wealth = sum(holdings)                     #total wealth at end of the day
    wealthtracker[today] = total_wealth              #populating the wealthtracker
  }
  wealthtracker                                      #adding a row to 'sim1' for i th monte carlo simulation
}

hist(sim1[,n_days], 25)

# Profit/loss
mean(sim1[,n_days])
hist(sim1[,n_days]- initial_wealth, breaks=30)

# Calculate 5% value at risk
quantile(sim1[,n_days], 0.05) - initial_wealth   #-5603.648



##### Scenario B


set.seed(100)
wghts = foreach(i=1:50, .combine='rbind') %do% {
  wts = matrix(0,ncol=5)
  wt = seq(0, 0.8, by=0.1)
  wts[1] = resample(wt, 1, orig.ids=FALSE)
  wt = seq(0, 0.9-wts[1], by=0.1)
  wts[2] = resample(wt, 1, orig.ids=FALSE)
  wt = seq(0, 0.9-wts[1]-wts[2], by=0.1)
  wt = c(0,0.1)
  wts[4] = resample(wt, 1, orig.ids=FALSE)
  wts[5] = resample(wt, 1, orig.ids=FALSE)
  wts[3] = 1-wts[1]-wts[2]-wts[4]-wts[5]
  wts
}

set.seed(100)
safe = foreach(j = 1:50, .combine='cbind') %do% {
  initial_wealth = 100000
  sim2 = foreach(i=1:1000, .combine='rbind') %do% {
    total_wealth = initial_wealth
    weights = wghts[j,]
    n_days = 20
    for(today in 1:n_days) {
      return.today = resample(all_returns, 1, orig.ids=FALSE)
      holdings = weights * total_wealth
      holdings = holdings + holdings*return.today
      total_wealth = sum(holdings)
    }
    total_wealth - initial_wealth
  }
  sim2
}

losses = apply(safe,2, function(x) {quantile(x, 0.05)})
max(losses)
wghts[which(losses==max(losses)),]




##### Scenario C


set.seed(100)
wghts3 = foreach(i=1:50, .combine='rbind') %do% {
  wts = matrix(0,ncol=5)
  wt = c(0,0.1)
  wts[1] = resample(wt, 1, orig.ids=FALSE)
  wts[2] = resample(wt, 1, orig.ids=FALSE)
  wts[3] = resample(wt, 1, orig.ids=FALSE)
  wt = seq(0.1, 1-wts[2]-wts[3]-wts[5], by=0.1)
  wts[4] = resample(wt, 1, orig.ids=FALSE)
  wts[5] = 1 - wts[1] - wts[2] - wts[3] - wts[4]
  wts
}

set.seed(100)
aggresive = foreach(j = 1:50, .combine='cbind') %do% {
  initial_wealth = 100000
  sim3 = foreach(i=1:1000, .combine='rbind') %do% {
    total_wealth = initial_wealth
    weights = wghts2[j,]
    n_days = 20
    for(today in 1:n_days) {
      return.today = resample(all_returns, 1, orig.ids=FALSE)
      holdings = weights * total_wealth
      holdings = holdings + holdings*return.today
      total_wealth = sum(holdings)
    }
    total_wealth - initial_wealth
  }
  sim3
}

losses3 = apply(aggresive,2, function(x) {quantile(x, 0.05)})
answer3 = which(losses3==max(losses3))
wghts3[answer3,]



even = c(0,0)
even[1] = round(initial_wealth - quantile(sim1[,n_days], 0.05),2)
even[2] = round(quantile(sim1[,n_days], 0.95) - initial_wealth,2)

safe = c(0,0)
safe[1] = round(min(losses),2)
profit2 = apply(safe,2, function(x) {quantile(x, 0.95) - initial_wealth})
safe[2] = profit2[which(losses==min(losses))]

aggressive = c(0,0)
aggressive[1] = round(min(losses3),2)
profit3 = apply(aggressive,2, function(x) {quantile(x, 0.95) - initial_wealth})
aggressive[2] = round(profits[which(losses3==min(losses3)),],2)

profit2 = apply(safe,2, function(x) {quantile(x, 0.95) - initial_wealth})

