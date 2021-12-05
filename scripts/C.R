# load the input objects defined in A.R and B.R
load("intermediate/dens_surface.RData")
load("intermediate/colours.RData")
s <- dens_surface

# enable meaningful colour coding for the density surface from A.R in a 3D plot
# https://stackoverflow.com/questions/39117827/colorful-plot-using-persp
z <- s$z
colors <- colorRampPalette(colours)(100)
z_facet_center <- (z[-1, -1] + z[-1, -ncol(z)] + z[-nrow(z), -1] + z[-nrow(z), -ncol(z)])/4
z_facet_range <- cut(z_facet_center, 100)

# create the 3D plot and write a .png file to the file system
png(file = "output/3D.png", bg = "transparent", width = 1000, heigh = 600)
  par(mar = c(0, 0, 0, 0))
  persp(
    s, 
    phi = 30, theta = 20, d = 5, expand = 0.3,
    col = colors[z_facet_range], border = "white",
    box = F, zlim = c(0, 0.009)
  )
dev.off()

