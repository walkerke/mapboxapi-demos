library(mapboxapi)
library(sf)
library(crsuggest)
library(leaflet)
library(fasterize)
library(esri2sf)

locations <- esri2sf("http://maps.lagrange-ga.org/arcgis/rest/services/Voting/Troup_County_Voting/MapServer/1")

crs <- suggest_top_crs(locations, units = "m")

isochrones <- mb_isochrone(
  location = locations,
  time = 1:60,
  profile = "walking"
) %>%
  st_transform(crs = crs)

template <- raster::raster(isochrones, resolution = 100)

polling_access <- fasterize(isochrones, 
                            template, 
                            field = "time", 
                            fun = "min")

vals <- raster::values(polling_access)

pal <- colorNumeric("viridis", 
                    vals, 
                    na.color = "transparent")

leaflet() %>%
  addMapboxTiles("streets-v11", "mapbox") %>%
  addRasterImage(polling_access, colors = pal, opacity = 0.5) %>%
  addLegend(values = vals, pal = pal,
            title = "Walk-time to nearest<br/>polling location")




