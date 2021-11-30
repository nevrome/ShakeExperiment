library(magrittr)

load("intermediate/dens_surface.RData")
load("intermediate/colours.RData")

s <- dens_surface
p <- plotly::plot_ly(x = s$x, y = s$y, z = s$z) %>% 
  plotly::add_surface(
    colorscale = list(
      list(0,   colours[1]),
      list(0.5, colours[2]),
      list(1,   colours[3])
    )
  )

htmlwidgets::saveWidget(plotly::as_widget(p), "output/3D.html")
