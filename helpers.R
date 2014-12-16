# Note: percent map is designed to work with the afghanistan admin data set
# It may not work correctly with other data sets if their row order does 
# not exactly match the order in which the maps package plots districts and provinces

province_map <- function(all, province, fill, size = 3, country = FALSE) {
  if (country) {
    p <- ggplot(all, aes(x = long, y = lat, group = group)) + geom_polygon(fill="white", color = "black") +
      geom_polygon(data=province, aes(x=long, y=lat, group=group), fill="grey", color = "black") +
      geom_path(data = province, aes(x = long, y = lat), color = "black")+ 
      labs(x=" ", y=" ") + 
      theme_bw() + 
      theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank()) + 
      theme(axis.ticks = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank()) + 
      theme(panel.border = element_blank())
  } else {
    p <- ggplot(province, aes(x = long, y = lat, group = group)) + geom_polygon(fill="white") +
      geom_path(data = province, aes(x = long, y = lat), color = "black")+ 
      labs(x=" ", y=" ") + 
      theme_bw() + 
      theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank()) + 
      theme(axis.ticks = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank()) + 
      theme(panel.border = element_blank())
  }
  print(p)
}

district_map <- function(all, province, districts, centroids, fill, size = 3, country = FALSE) {
  if (country) {
    p <- ggplot(all, aes(x = long, y = lat, group = group)) + geom_polygon(fill="white", color = "black") +
      geom_polygon(data=province, aes(x=long, y=lat, group=group), fill="grey", color = "black") +
      geom_path(data = province, aes(x = long, y = lat), color = "black")+ 
      lapply(districts,geom_polygon, mapping=aes(x=long, y=lat), fill= fill) + 
      lapply(districts,geom_path, mapping=aes(x=long, y=lat))+
      labs(x=" ", y=" ") + 
      theme_bw() + 
      theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank()) + 
      theme(axis.ticks = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank()) + 
      theme(panel.border = element_blank())
} else {
  p <- ggplot(province, aes(x = long, y = lat, group = group)) + geom_polygon(fill="white") +
    geom_path(data = province, aes(x = long, y = lat), color = "black")+ 
    lapply(districts,geom_polygon, mapping=aes(x=long, y=lat), fill= fill) + 
    lapply(districts,geom_path, mapping=aes(x=long, y=lat))+
    geom_text(data = centroids, aes(label = DIST_NA_EN, x = long, y = lat, group = DIST_NA_EN), size = size) +
    labs(x=" ", y=" ") + 
    theme_bw() + 
    theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank()) + 
    theme(axis.ticks = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank()) + 
    theme(panel.border = element_blank())
}
  print(p)
}

getdf2 <- function(country.spdf, province) {
  sub.shape <- country.spdf[country.spdf$PROV_NA_EN == province,]
  country.df <- fortify(sub.shape, region = "DIST_NA_EN")
}
getDistricts <- function(country.df) {
  district_list <- unique(country.df$id)
}

getCentroids <- function(centroids, province, districts){
  cent2 <-subset(centroids, (DIST_NA_EN %in% districts))
  cent2 <-subset(cent2, PROV_NA_EN == province)
}

getPlot1 <- function(df, province){
 toplot1 = subset(df, id == province)
}

getPlot2 <- function(df, districts){
 toplot2 <- replicate(length(districts), data.frame())
  
 for (i in 1:length(districts)) {
   toplot2[[i]] <- subset(df, id == districts[i])
 }
 return(toplot2)
}