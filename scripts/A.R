# read a covariance matrix
cov_mat <- as.matrix(read.csv("input/raw_input.csv", header = F))
# sample from a multivariate gaussian distribution informed by said matrix
sampled <- MASS::mvrnorm(n = 10000, rep(0, 2), cov_mat)
# create a smooth density interpolation surface over the sample
dens_surface <- MASS::kde2d(sampled[,1], sampled[,2], n = 50)
# write the density surface object to the file system
save(dens_surface, file = "intermediate/dens_surface.RData")
