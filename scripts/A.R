cov_mat <- as.matrix(read.csv("input/raw_input.csv", header = F))
sampled <- MASS::mvrnorm(n = 10000, rep(0, 2), cov_mat)
dens_surface <- MASS::kde2d(sampled[,1], sampled[,2], n = 50)
save(dens_surface, file = "intermediate/dens_surface.RData")
