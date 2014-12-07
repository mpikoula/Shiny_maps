# Note: percent map is designed to work with the afghanistan admin data set
# It may not work correctly with other data sets if their row order does 
# not exactly match the order in which the maps package plots districts and provinces
province_map <- function(province, districts, centroids, fill, size = 3) {
  
  p <- ggplot(province, aes(x = long, y = lat, group = group)) + geom_polygon(fill="white") +
    geom_path(data = province, aes(x = long, y = lat), color = "black")+ 
    lapply(districts,geom_polygon, mapping=aes(x=long, y=lat), fill= fill) + 
    lapply(districts,geom_path, mapping=aes(x=long, y=lat))+
    geom_text(data = centroids, aes(label = NAME_2, x = long, y = lat, group = NAME_2), size = size) +
    labs(x=" ", y=" ") + 
    theme_bw() + 
    theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank()) + 
    theme(axis.ticks = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank()) + 
    theme(panel.border = element_blank())
  
  print(p)
}

# getdf2 <- function(country.spdf, province) {
#   sub.shape <- country.spdf[country.spdf$NAME_1 == province,]
#   country.df <- fortify(sub.shape, region = "NAME_2")
#   traceback()
# }
getDistricts <- function(country.spdf, province) {
  sub.shape <- country.spdf[country.spdf$NAME_1 == province,]
  country.df <- fortify(sub.shape, region = "NAME_2")
  district_list <- unique(country.df$id)
}

getCentroids <- function(centroids, districts){
  cent2 <-subset(centroids, (NAME_2 %in% districts))
  cent2 <-subset(cent2, NAME_1 == province)
}

#getPlot1 <- function(df, province){
#  toplot1 = subset(df, id == province)
#}

#getPlot2 <- function(df, districts){
#  toplot2 <- replicate(length(districts), data.frame())
  
#  for (i in 1:length(districts)) {
#    toplot2[[i]] <- subset(afghanistan.adm2.df, id == districts[i])
#  })
#}