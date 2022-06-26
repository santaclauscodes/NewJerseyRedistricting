# map of NJ congressional districts for comparison
# https://www.njredistrictingcommission.org/adoption2022map.asp

#pulled fips from 
#https://www.nrcs.usda.gov/wps/portal/nrcs/detail/nj/about/?cid=nrcs143_013697

library(choroplethr)
library(ggplot2)

fipsdata = read.csv("C:/Users/skinn/Desktop/Northwestern/MSDS 460/Module6/nj-fips.csv", stringsAsFactors = FALSE)

# note use of county FIPS codes
county <- data.frame(region = fipsdata$fips,
                 value=c(3,12,11,7,3,3,10,7,8,1,11,6,4,5,2,9,3,1,9,5,1))


county_choropleth(county, title="New Jersey Redistricting",
                  legend="District", state_zoom = "new jersey", num_colors = 1)+
  scale_fill_gradient2(high = "coral", 
                       low = "green", 
                       na.value = "grey50",
                       breaks = pretty(county$value, n = 12))








