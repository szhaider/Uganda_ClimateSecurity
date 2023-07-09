#Buffer Calculation
################################################################################
rm(list=ls())

#Utils required
if (!require("pacman")) install.packages("pacman")
suppressMessages(pacman::p_load(tidyverse, sf, mapview, units))

#library(tidyverse)
#library(sf)
#library(mapview)
#library(units)

################################################################################
#Reading the Uganda shapefile (Not necessary)
uga_shp <- 
  read_sf("../ShapeFiles/Uganda_Shapefiles/DISTRICTS_2018_UTM_36N.shp")
################################################################################

#Reading the Uganda Conflicts file (ACLED) 
#NOTE: (ACLED data might be different so slight adjustment might be needed)
UG_conflicts <- 
  haven::read_dta("../output/Uganda_conflicts.dta") %>% 
  dplyr::select(year, quarter, month, latitude, longitude, event_type, fatalities)  

#Aggregating conflicts over the years and GPS points
#Fatalities in conflcits (Even fatalities =0, still a conflcit incident)
UG_conflicts <-   
  UG_conflicts %>% 
  # filter(type_of_violence == "State Based Conf" | 
  #          type_of_violence == "One Sided Violence") %>% 
  group_by(year, quarter, month, longitude, latitude, event_type) %>%
  summarise(fatalities = sum(fatalities),
            .groups = "drop") %>%
  filter(!is.na(fatalities)) %>%
  pivot_wider(names_from = event_type, 
              values_from = fatalities) %>% 
  janitor::clean_names()

################################################################################
################################################################################
#Paths (adjust as per your project root folder)
main_path <- dirname(getwd())
shp_path <- paste0(main_path, "/dhs_raw/")
data_path <- paste0(main_path, "/output/")
################################################################################

# ISO
iso <- 'UGA' # ISO 3 country code

################################################################################
#All DHS years where GPS Coords available (2000 + 2006 + 2011 + 2016)

#DHS Clusters (Path to DHS Cluster shape files)   (Adjust as per the country data downloaded)
dhs_gps <- c(
  '/UG_2000-01_DHS_06082023_128_182699/UGGE43FL/UGGE43FL.shp',
  '/UG_2006_DHS_06082023_127_182699/UGGE53FL/UGGE53FL.shp',
  '/UG_2011_DHS_06082023_125_182699/UGGE61FL/UGGE61FL.shp',
  '/UG_2016_DHS_06082023_120_182699/UGGE7AFL/UGGE7AFL.shp'
)

#Adjust according to the country: ISO (3 digits), e.g.if Nigeria = NIG then change to substring(gps, 3, 8) below

#Read Uganda shapefiles as
# UG_2016
# UG_2011
# UG_2006
# UG_2000

for(gps in dhs_gps){
  
  assign(substring(gps, 2, 8), read_sf(paste0(shp_path, gps))) 
  
}

################################################################################
#Buffer Calculation around DHS coordinates

#Years for which DHS Clusters are available 
#(adjust according to the DHS clusters years availability)

dhs_years <- c(2000, 2006, 2011, 2016)

################################################################################

#Change distance based on the country specific context

dist <- set_units(22, km) %>% 
  set_units(km) %>% 
  set_units(m)

dist = dist   # 22km    change if other needed 50000 = 50 Km

for(yr in dhs_years){
  
  data_shp <- get(str_c("UG_",yr))
  
  assign(
    str_c("buffer_", yr),
    data_shp %>%
      st_transform(crs = 32636) %>% #Uganda  (For speedy and accurate calculation):    https://epsg.io/9754
      st_buffer(
        dist = dist,
        nQuadSegs = 20,   #70  change to control the segments of a circle quadrant, if high for more perfect circles, file size and calculation time would go up
        endCapStyle = "ROUND",
        joinStyle = "ROUND",
        mitreLimit = 1,
        singleSide = FALSE)%>% 
      st_transform(crs = 4326)  #Back to 4326 for plotting and merging with conflict features
  ) 
}

################################################################################

#Conflict points (2000 + 2006 + 2011 + 2016) preparation as spatial features  
for(yr in dhs_years){
  assign(paste0("conflicts_", yr), 
         UG_conflicts %>%
           filter(year == yr |
                    year == yr + 1  #Since all the future conflicts can at max be in the 3 quarters of the next year
           ) %>%  #>>>>Here for additional filtering based on present quarter and future 3 quarters conflicts mapping to the DHS year, then we might overlay present quarter conflicts and next 3 quarters conflicts for present conflicts and future on DHS buffers.
           # filter(!is.na(battles) |
           #        !is.na(violence_against_civilians),
           #        !is.na(riots),
           #        !is.na(protests)) %>%  View() 
           rename(LONGNUM=longitude, LATNUM=latitude) %>%
           st_as_sf(coords= c("LONGNUM", "LATNUM"), crs=4326) %>%
           mutate(LONGNUM = st_coordinates(.)[, 1],
                  LATNUM = st_coordinates(.)[, 2])
  )
}


################################################################################
# Count of conflicts overlapping respective DHS clusters

for(yr in dhs_years){
  
  #Overlapping features of buffers and conflicts
  
  assign(paste0("conf_count_", yr),
         st_intersects(get(paste0("buffer_", yr)), get(paste0("conflicts_", yr)))
  )
  
  intersects <-  lengths(get(paste0("conf_count_", yr))) > 0
  
  assign(paste0("conf_count_",yr,"_overlap"),
         filter(get(paste0("buffer_", yr)), intersects)
  )
  
  #Spatial join of overlapping features with all features  
  #Preparing the count of conflict incidences  
  assign(paste0("conf_count_final_", yr),
         get(paste0("buffer_", yr)) %>%
           st_join(get(paste0("conf_count_",yr,"_overlap")),
                   join = st_equals,
                   left = TRUE) %>%
           mutate(conf_count = if_else(is.na(LATNUM.y), 0, 1))
  )
  
} 


#Adjusting the var names, cleaning and exporting CSVs for further use in later analyses

for(yr in dhs_years){
  
  vars <- colnames(get(paste0("conf_count_final_", yr)) %>% 
                     as_tibble() %>% 
                     dplyr::select(-ends_with(".y"),
                            -geometry))
  
  vars <- vars %>% 
    str_remove(".x") 
  
  var_names <- 
    get(paste0("conf_count_final_", yr)) %>% 
    as_tibble() %>% 
    dplyr::select(-ends_with(".y"),
           -geometry) %>% 
    purrr::set_names(vars) %>% 
    colnames()
  
  #Exporting CSVs
  get(paste0("conf_count_final_", yr)) %>% 
    as_tibble() %>% 
    dplyr::select(-ends_with(".y"),
           -geometry) %>% 
    arrange(DHSID.x) %>% 
    purrr::set_names(var_names) %>% 
    write.csv(paste0("../xlsx/buffers/buffer_conflict_",yr, ".csv"))
}


################################################################################
#Drawing buffered dhs points
buffer_2016 %>%
  mapview()

##Visual Validation : by simply overlaying conflicts on clusters & then by calculating counts and overlaying
buffer_2016 %>% 
  filter(LONGNUM>0) %>% 
  dplyr::select(-LONGNUM, -LATNUM) %>% 
  ggplot()+
  geom_sf() +
  geom_point(aes(LONGNUM, LATNUM), 
             data=conflicts_2016)

#Conflcits points exactly ON the dhs clusters now
buffer_2016 %>% 
  filter(LONGNUM>0) %>% 
  dplyr::select(-LONGNUM, -LATNUM) %>% 
  ggplot()+
  geom_sf() +
  geom_point(aes(LONGNUM.y, LATNUM.y), 
             data=conf_count_final_2016)




