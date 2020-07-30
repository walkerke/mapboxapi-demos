library(mapboxapi)
library(sf)
library(leaflet)
library(fasterize)
library(esri2sf)

locations <- esri2sf("https://gis.suffolkcountyny.gov/server/rest/services/LocalGovernmentSQLData/PollingPlace/MapServer/0")
