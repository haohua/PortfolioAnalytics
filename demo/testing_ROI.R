#' ---
#' title: "ROI Demo"
#' date: "7/17/2014"
#' ---

#' This script demonstrates running optimizations using ROI as the 
#' optimization backend. Note that this script uses the v1 specification
#' previous to version 0.8.3.

#' Load packages
library(PortfolioAnalytics)

#' General Parameters for sample code
data(edhec)
funds <- names(edhec)
mu.port <- mean(colMeans(edhec))
N <- length(funds)

#' Define problem with constraints and objectives
gen.constr <- constraint(assets = colnames(edhec), min=-Inf, max =Inf, min_sum=1, max_sum=1, risk_aversion=1)
gen.constr <- add.objective(constraints=gen.constr, type="return", name="mean", enabled=FALSE, multiplier=0, target=mu.port)
gen.constr <- add.objective(constraints=gen.constr, type="risk", name="var", enabled=FALSE, multiplier=0, risk_aversion=10)
gen.constr <- add.objective(constraints=gen.constr, type="risk", name="CVaR", enabled=FALSE, multiplier=0)


#' Max return under box constraints, fully invested
max.port <- gen.constr
max.port$min <- rep(0.01,N)
max.port$max <- rep(0.30,N)
max.port$objectives[[1]]$enabled <- TRUE
max.port$objectives[[1]]$target <- NA
max.solution <- optimize.portfolio(R=edhec, constraints=max.port, optimize_method="ROI")


#' Mean-variance:  Fully invested, Global Minimum Variance Portfolio
gmv.port <- gen.constr
gmv.port$objectives[[2]]$enabled <- TRUE
gmv.port$objectives[[2]]$risk_aversion <- 1
gmv.solution <- optimize.portfolio(R=edhec, constraints=gmv.port, optimize_method="ROI")


#' Mean-variance:  Maximize quadratic utility, fully invested, target portfolio return
target.port <- gen.constr
target.port$objectives[[1]]$enabled <- TRUE
target.port$objectives[[2]]$enabled <- TRUE
target.solution <- optimize.portfolio(R=edhec, constraints=target.port, optimize_method="ROI")


#' Mean-variance:  Maximize quadratic utility, dollar-neutral, target portfolio return
dollar.neu.port <- gen.constr
dollar.neu.port$min_sum <- 0
dollar.neu.port$max_sum <- 0
dollar.neu.port$objectives[[1]]$enabled <- TRUE
dollar.neu.port$objectives[[2]]$enabled <- TRUE
dollar.neu.solution <- optimize.portfolio(R=edhec, constraints=dollar.neu.port, optimize_method="ROI")


#' Minimize CVaR with target return
cvar.port <- gen.constr
cvar.port$objectives[[1]]$enabled <- TRUE
cvar.port$objectives[[3]]$enabled <- TRUE
cvar.solution <- optimize.portfolio(R=edhec, constraints=cvar.port, optimize_method="ROI")


#' Mean-variance:  Fully invested, Global Minimum Variance Portfolio, Groups Constraints
groups.port <- gen.constr
groups <- list(1:3, 4:6, 7:9, 10:13)
groups.port$groups <- groups 
groups.port$cLO <- rep(0.15,length(groups))
groups.port$cUP <- rep(0.30,length(groups)) 
groups.port$objectives[[2]]$enabled <- TRUE
groups.port$objectives[[2]]$risk_aversion <- 1
groups.solution <- optimize.portfolio(R=edhec, constraints=groups.port, optimize_method="ROI")


#' Minimize CVaR with target return and group constraints
group.cvar.port <- gen.constr
groups <- list(1:3, 4:6, 7:9, 10:13)
group.cvar.port$groups <- groups
group.cvar.port$cLO <- rep(0.15,length(groups))
group.cvar.port$cUP <- rep(0.30,length(groups))
group.cvar.port$objectives[[1]]$enabled <- TRUE
group.cvar.port$objectives[[3]]$enabled <- TRUE
group.cvar.solution <- optimize.portfolio(R=edhec, constraints=group.cvar.port, optimize_method="ROI", maxSTARR=FALSE) 

