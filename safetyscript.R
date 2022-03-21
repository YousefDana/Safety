
# Libraries ----
#library(geojsonR)
library(sf)
library(tmap)
library(data.table)
library(ggplot2)
library(units)

setwd("G:/git/Safety")

# Read in data ----
## API ---- Currently times out
# url_path_crashes = 'https://opendata.arcgis.com/datasets/c47903b664164b719cce04a2e7584dac_0.geojson'
# url_js_crashes = FROM_GeoJson(url_file_string = url_path_crashes)
# str(url_js_crashes)

# url_path_hwy = 'https://opendata.arcgis.com/datasets/7f95655e706e408281d16d383b1b4a8a_2.geojson'
# url_js_hwy = FROM_GeoJson(url_file_string = url_path_hwy)
# str(url_js_hwy)

## GeoJSON ---- Currently does not work
#crashes = FROM_GeoJson(url_file_string = 'Crashes2019.geojson')

## Shapefile ----
crashes = st_read('2019crashes/CRASHES_2019.shp')
hwy = st_read('2019hwy/Technology_Transfer_2019.shp')
county = st_read('counties/IL_BNDY_County_Py.shp')

county <- st_read('counties/IL_BNDY_County_Py.shp') %>%
  st_set_crs(4267) %>% 
  st_transform(3857)

# EDA ----
crashes_dt = data.table(crashes)
hwy_dt = data.table(hwy)

mtm = crashes_dt[CrashSever == 'Fatal', .N, CrashMonth]
ggplot(mtm, aes(x = CrashMonth, y = N, group = 1)) +
  geom_line(color = 'blue') +
  geom_point()

cause = crashes_dt[CrashSever == 'Fatal',.N, Cause1]
cause[order(-N)]

tm_shape(crashes) + tm_dots()
tm_shape(hwy) + tm_lines()

tm_shape(county) + tm_polygons() + tm_shape(crashes_dt) + tm_dots()


crashes_dt[Cause1 == 'Under Influence of Alcohol/Drugs', .N, ]

crashes_dt[UrbanRural == 'Rural' | UrbanRural == 'Urban', .N, .(CrashSever, UrbanRural)]




# Analysis ----

## Find missing values for AADT ----
# Use a decision/regression tree to determine AADT in roads that have 0 AADT
hwy_aadt = data.table(hwy)
hwy_aadt = hwy_aadt[AADT > 0,]
hwy_aadt = st_as_sf(hwy_aadt)
#tm_shape(hwy_aadt) + tm_lines()


## Find worst segments based on KABCO ----
# Join HWY and Crashes based on distance and count total number of
# crashes within each hwy segment
#st_join(hwy, crashes, join = st_is_within_distance(hwy, crashes, 500))

crashes_dt = data.table(crashes)
crashes_dt = crashes_dt[CrashSever == 'Fatal',]
crashes_dt = st_as_sf(crashes_dt)

#lengths(st_is_within_distance(hwy, crashes, 500))
distance = set_units(500, feet)
dt = data.table(count = lengths(st_is_within_distance(hwy_aadt, crashes_dt, dist = 0.2)))
hwy_aadt = data.table(hwy_aadt)
hwy_aadt[, count := dt]
hwy_aadt[count > 0, .N]
hwy_aadt[,.N,count]
hwy_aadt = hwy_aadt[count > 0,]
hwy_aadt = st_as_sf(hwy_aadt)
tm_shape(county) + tm_polygons() + tm_shape(hwy_aadt) + tm_lines()






