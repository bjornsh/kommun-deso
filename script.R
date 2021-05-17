library(dplyr)
library(sf)
library(mapview)

### clean
rm(list = ls())
invisible(gc())


### download and extract data (zipped gpkg)
download.file("https://www.scb.se/contentassets/923c3627a8a042a5b9215e8ff3bde0a3/deso_2018_v2.zip", 
              destfile = paste0(getwd(), "/data/deso_2018_v2.zip"))

unzip(paste0(getwd(), "/data/deso_2018_v2.zip"), exdir = paste0(getwd(), "/data"))

layer_name <- st_layers(paste0(getwd(), "/data/DeSO_2018_v2.gpkg"))$name[1]


### read data from gpkg
deso = st_read(paste0(getwd(), "/data/DeSO_2018_v2.gpkg"), layer = layer_name, quiet = TRUE)                      


### create kommun boundaries based on DeSo boundaries
kommun = deso %>% 
  filter(substr(kommun, 1, 2) == "03") %>% 
  group_by(kommun, kommunnamn) %>% 
  summarize(sp_geometry = st_union(sp_geometry)) %>% 
  ungroup()

### check projection
st_crs(kommun)

### write as shapefile
st_write(kommun, paste0(getwd(), "/data/kommun_based_on_deso.shp"))


### Display result
mapview(kommun, zcol = "kommunnamn", layer.name = "Kommun")
