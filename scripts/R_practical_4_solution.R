#----------------------------------------------------
#
# Practical 4: Exo 4. 
# Simulating and comparing discrete/continuous variables
#
#----------------------------------------------------

######################################################################################################
######################################################################################################
######################################################################################################
### 4. VARYING THE SAMPLE SIZES: DISCRETE DV.

##############################################
# 4.1 DISCRETE DV. Continuous/Discrete IVs. Varying n.
set.seed(0)

### Simulation parameters
n.seq <- 10^c(2,3,4)  # Number of observations
r <- 100  # Number of iterations.
k <- 10  # Number of predictors (IVs).
b.sd <- 1
l <- length(n.seq)

### Measure system time:
start_time <- Sys.time()

### Monte Carlo simulations:
nsig.cts <- matrix(0,r,length(n.seq)) # Matrix of significant predicators (IVs),
nsig.dis <- matrix(0,r,length(n.seq)) # Matrix of significant predicators (IVs),
for(n.ind in 1:l){
        n <- n.seq[n.ind]
        print(n)
        for(iter in 1:r){
                
                ### 1.Generate IVs.
                X.cts <- data.frame(matrix(0,n,k))
                X.dis <- data.frame(matrix(0,n,k))
                b <- rnorm(k,mean=0,sd=b.sd)
                for(iv in 1:k){
                        z <- rnorm(n)
                        X.cts[,iv] <- z
                        X.dis[,iv] <- ifelse(z<=median(z),0,1)
                }#iv
                
                ### 2.Generate DV.
                x.cts <- vector("numeric",n)
                x.dis <- vector("numeric",n)
                for(iv in 1:k){
                        x.cts <- x.cts + b[iv]*X.cts[,iv] 
                        x.dis <- x.dis + b[iv]*X.dis[,iv] 
                }#iv
                ### Inverse logit function, and Bernoulli random variable.
                p.cts <- 1/(1+exp(-x.cts));  y.cts <- rbinom(n,1,p.cts) 
                p.dis <- 1/(1+exp(-x.dis));  y.dis <- rbinom(n,1,p.dis) 
                
                ### Data frame.
                data.cts <- data.frame(cbind(y.cts,X.cts))
                data.dis <- data.frame(cbind(y.dis,X.dis))
                
                ### Fit model
                mod.cts <- glm(y.cts~.,family="binomial",data.cts)
                mod.dis <- glm(y.dis~.,family="binomial",data.dis)
                
                ### Collect the number of highly significant predictors. 
                nsig.cts[iter,n.ind] <- sum(summary(mod.cts)$coefficients[,4]<=0.001)  
                nsig.dis[iter,n.ind] <- sum(summary(mod.dis)$coefficients[,4]<=0.001)  
        }#iter
}#n
end_time <- Sys.time()
### Print running time of our outer loop.
end_time - start_time

##############################################
# 4.2: Compare continuous IVs, and discrete simulations. 

### Compare CTS and DIS.
par(mfrow=c(1,l))
for(n.ind in 1:l){
        cts.cts <- nsig.cts[,n.ind]
        cts.dis <- nsig.dis[,n.ind]
        output <- cbind(cts.cts,cts.dis)
        colnames(output) <- c("Continuous IVs","Discrete IVs")
        boxplot(output,main=paste0("n=",n.seq[n.ind]), ylim=c(0,12),
                xlab=c("Type of Predictors"),ylab=c("Number of predictors with p-value <= 0.001"))
}#n.ind


###
# EoF