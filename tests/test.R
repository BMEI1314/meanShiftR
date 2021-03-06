library(meanShiftR)
library(LPCM)
library(MeanShift)

# set a seed to make this reproducible 
set.seed(100)

# set the number of iterations to test
iter <- 100

# set the number of points to simulate
n <- 200 

# set the bandwidth
h <- c(0.5,0.5)

# create example data
x1 <- matrix( rnorm( n ),ncol=2)
x2 <- matrix( rnorm( n ),ncol=2) + 2 
x <- rbind( x1, x2 ) 

########### meanShiftR ###################
run.time <- proc.time()
result <- meanShift(
  x, 
  x, 
  algorithm="KDTREE",
  bandwidth=h,
  alpha=0,
  nNeighbors=200,
  iterations = iter, 
  parameters=c(30,0)
) 
meanShiftR_kd_runtime <- (proc.time()-run.time)[3]

# assignment
meanShiftR_kd_assignment <- result$assignment

# value
meanShiftR_kd_value <- result$value


########### meanShiftR ###################
run.time <- proc.time()
result <- meanShift(
  x, 
  x, 
  bandwidth=h,
  alpha=0,
  iterations = iter 
) 
meanShiftR_runtime <- (proc.time()-run.time)[3]

# assignment
meanShiftR_assignment <- result$assignment

# value
meanShiftR_value <- result$value


########### LPCM ###################
runtime <- proc.time()
result <- ms(
            x,
            h=h, 
            scaled=FALSE, 
            iter=iter, 
            plotms=-1)
LPCM_runtime <- (proc.time()-runtime)[3]

# assignment
LPCM_assignment <- result$cluster.label

# value
LPCM_value <- result$cluster.center[LPCM_assignment,]


########### MeanShift ###################
#options(mc.cores = 4)
#z <- t(x)
#runtime <- proc.time()
#result <- msClustering(
#            X=z,
#            h=h, 
#            kernel="gaussianKernel", 
#            tol.stop=1e-08,
#            tol.epsilon=1e-04,
#            multi.core=T)
#MeanShift_runtime <- (proc.time()-runtime)[3]
#
#MeanShift_assignment <- result$labels
#MeanShift_value <- t(result$components[,result$labels])


print(sprintf("Elapsed time meanShiftR kdtree = %f", meanShiftR_kd_runtime))
print(sprintf("Elapsed time meanShiftR = %f", meanShiftR_runtime))
print(sprintf("Elapsed time LPCM ms = %f", LPCM_runtime))
#print(sprintf("Elapsed time MeanShift msClassify = %f", MeanShift_runtime))


print("max diff")

print( max(abs(meanShiftR_value - LPCM_value) ))
print( max(abs(meanShiftR_kd_value - LPCM_value) ))
#print( max(abs(MeanShift_value - LPCM_value) ))


print( sprintf("Number of differences between meanShiftR and LPCM = %d",
               sum(meanShiftR_assignment != LPCM_assignment)))
print( sprintf("Number of differences between meanShiftR kdtree and LPCM = %d",
               sum(meanShiftR_kd_assignment != LPCM_assignment))) 
#print( sprintf("Number of differences between msClustering and LPCM = %d",
#               sum(MeanShift_assignment != LPCM_assignment))) 


#

#result <- x 
#
#for( i in 1:7 ) {
##  for( j in 1:nrow(x) ) {
#  j <- 1
#  y <- result[j,]
#    nNeighbors <- nrow(x) 
#    
#    # get nearest neighbors
#    xx <- ((t(x) - y)*(1/h))^2
#    d <- colSums(xx) 
#    #d.sort <- sort(d, index.return=T)
#    
#    #d.exp <- exp( d.sort$x[1:nNeighbors] * -1/2 )   
#    d.exp1 <- dnorm( sqrt(d) )   
#    d.exp <- exp( d * -1/2 )   
#    w = sum(d.exp)
#    
#    #result[j,] <- colSums(x[d.sort$ix[1:nNeighbors],] * d.exp / w )
#    result[j,] <- colSums(x * d.exp / w )
##  }
#}
#print(result)
#print(d.exp/w)
##print( max(abs(result - nn.ms) ))
##print( max(abs(result - nn.meanShift.value_kd) ))
##
#
