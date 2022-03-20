
# Libraries ----
#library(geojsonR)
library(sf)
library(tmap)
library(data.table)
library(ggplot2)

setwd("G:/git/Safety")

# Read in data ----
## API ----
# url_path = 'https://opendata.arcgis.com/datasets/c47903b664164b719cce04a2e7584dac_0.geojson'
# url_js = FROM_GeoJson(url_file_string = url_path)
# str(url_js)

# Roads - https://opendata.arcgis.com/datasets/7f95655e706e408281d16d383b1b4a8a_2.geojson

## GeoJSON ----
#crashes = FROM_GeoJson(url_file_string = 'Crashes2019.geojson')

## Shapefile ----
crashes = st_read('2019crashes/CRASHES_2019.shp')
hwy = st_read('2019hwy/Technology_Transfer_2019.shp')

# EDA ----
crashes_dt = data.table(crashes)
mtm = crashes_dt[CrashSever == 'Fatal',.N,CrashMonth]
mtm[CrashMonth == 1, Month := 'Jan']
mtm[CrashMonth == 2, Month := 'Feb']
mtm[CrashMonth == 3, Month := 'Mar']
mtm[CrashMonth == 4, Month := 'Apr']
mtm[CrashMonth == 5, Month := 'May']
mtm[CrashMonth == 6, Month := 'June']
mtm[CrashMonth == 7, Month := 'July']
mtm[CrashMonth == 8, Month := 'Aug']
mtm[CrashMonth == 9, Month := 'Sep']
mtm[CrashMonth == 10, Month := 'Oct']
mtm[CrashMonth == 11, Month := 'Nov']
mtm[CrashMonth == 12, Month := 'Dec']

tm_shape(crashes) + tm_dots()
tm_shape(hwy) + tm_lines()

ggplot(mtm, aes(x = CrashMonth, y = N, group = 1)) +
  geom_line(color = 'blue') +
  geom_point()

# Analysis ----
# Find worst segments based on KABCO









