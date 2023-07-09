
########################################
# Uganda - Climate Data Extraction
########################################
rm(list=ls())

# Install packages
# Options
options(warn = -1, scipen = 999)
suppressMessages(if(!require("pacman")) install.packages("pacman"))
suppressMessages(pacman::p_load(tidyverse, terra, raster, 
                                vroom, exactextractr,trend,
                                ncdf4, sp, rgdal, raster,
                                sf, janitor,
                                zoo, here))

################################################################################
#Paths
main_path <- dirname(getwd())
shp_path <- paste0(main_path, "/dhs_raw/")
data_path <- paste0(main_path, "/Climate_Data")
################################################################################

# ISO
iso <- 'UGA' # ISO 3 country code

# USING NC TO EXTRACT DATA AT THE COORDINATE LEVEL

# Multiple layers 1990-2021 (we use this when we work at the COORDINATE LEVEL)

#Extracting Data from all precipitation and Temperature rasters across DHS years

################################################################################
#4 DHS years where GPS Coords available (2001 + 2006 + 2011 + 2016)
gps_years <- c(
  '/UG_2000-01_DHS_06082023_128_182699/UGGE43FL/UGGE43FL.shp',
  '/UG_2006_DHS_06082023_127_182699/UGGE53FL/UGGE53FL.shp',
  '/UG_2011_DHS_06082023_125_182699/UGGE61FL/UGGE61FL.shp',
  '/UG_2016_DHS_06082023_120_182699/UGGE7AFL/UGGE7AFL.shp'
)
################################################################################

########################################
# Uganda - Precipitation Data 
########################################

# All DHS Years
for(yr in gps_years){
  
  #All precipitation rasters
  for(i in 1:6){
    
    i <- i  
    nc <- paste0("prec_uga",i)
    nc <- paste0("/",nc,".nc") 
    rst <- raster::stack(paste0(data_path,nc)) 
    crd <- read_sf(paste0(shp_path, yr)) %>% 
      janitor::clean_names()
    
    crd <- cbind(crd, raster::extract(x = rst, y = crd[,c('longnum','latnum')])) %>% 
      dplyr::select(-geometry, -dhscc, -ccfips, -adm1fips, -adm1fipsna,-adm1salbna, -adm1salbco,
                    -adm1dhs,-dhsregco, -dhsregna,-source, -alt_gps, -alt_dem, -datum)
    
    year <- substr(yr, 2, 8)
    vroom::vroom_write(x = crd, file = paste0(main_path,'/xlsx/climate_extraction/', year, "_prec_",i, '.csv'), delim = ',')
  }
}

################################################################################

########################################
# Uganda - Temperature Data 
########################################

#All DHS Years
for(yr in gps_years){
  
  #All Temperature rasters
  for(i in 1:6){
    
    i <- i  
    nc <- paste0("tmax_uga",i)
    nc <- paste0("/",nc,".nc") 
    rst <- raster::stack(paste0(data_path,nc)) 
    crd <- read_sf(paste0(shp_path, yr)) %>% 
      janitor::clean_names()
    
    crd <- cbind(crd, raster::extract(x = rst, y = crd[,c('longnum','latnum')])) %>% 
      dplyr::select(-geometry, -dhscc, -ccfips, -adm1fips, -adm1fipsna,-adm1salbna, -adm1salbco,
                    -adm1dhs,-dhsregco, -dhsregna,-source, -alt_gps, -alt_dem, -datum) %>% 
      mutate(across(starts_with("X"),
                    ~ .x * 0.1))
    
    year <- substr(yr, 2, 8)
    vroom::vroom_write(x = crd, file = paste0(main_path,'/xlsx/climate_extraction/', year, "_temp_",i, '.csv'), delim = ',')
  }
  
}

################################################################################
#Joining Precipitation Data across 1990-2021 for respective DHS Years
#Each resulting dataset will be merged with final DHS prepared data

#Reading in All precipitation data to merge together years 1990 : 2021 across 4 DHS years
#All DHS years where GPS Coords available (2001 + 2006 + 2011 + 2017)

gps_years <- c(
  '/UG_2000-01_DHS_06082023_128_182699/UGGE43FL/UGGE43FL.shp',
  '/UG_2006_DHS_06082023_127_182699/UGGE53FL/UGGE53FL.shp',
  '/UG_2011_DHS_06082023_125_182699/UGGE61FL/UGGE61FL.shp',
  '/UG_2016_DHS_06082023_120_182699/UGGE7AFL/UGGE7AFL.shp'
)

for(yr in gps_years){
  year <- paste0(substr(yr, 2,8), "_prec")
  
  prec_files <- list.files(paste0(main_path, "/xlsx/climate_extraction/"), pattern = year)
  
  for (i in 1:length(prec_files)) {
    assign(paste0("prec_",year, i), 
           read.csv(paste0(paste0(main_path, "/xlsx/climate_extraction/"),"/", year, "_", i,".csv"))
    )
  }
}

#Merging Precipitation Data files
#2000-2001
UG_precipitation_final_2000 <-
  prec_UG_2000_prec1 %>% 
  left_join(prec_UG_2000_prec2 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry), 
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2000_prec3 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2000_prec4 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),  
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2000_prec5 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2000_prec6 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust"))

#2006
UG_precipitation_final_2006 <-
  prec_UG_2006_prec1 %>% 
  left_join(prec_UG_2006_prec2 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry), 
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2006_prec3 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2006_prec4 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),  
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2006_prec5 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2006_prec6 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust"))
#2011
UG_precipitation_final_2011 <-
  prec_UG_2011_prec1 %>% 
  left_join(prec_UG_2011_prec2 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry), 
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2011_prec3 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2011_prec4 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),  
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2011_prec5 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2011_prec6 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust"))

#2016
UG_precipitation_final_2016 <-
  prec_UG_2016_prec1 %>% 
  left_join(prec_UG_2016_prec2 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry), 
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2016_prec3 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2016_prec4 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),  
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2016_prec5 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(prec_UG_2016_prec6 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust"))

# UG_precipitation_final_2000 %>%
#   janitor::clean_names() %>%
#   haven::write_dta(paste0(main_path,"/output/","UG_precipitation_final_2000.dta"))
# 
# UG_precipitation_final_2006 %>%
#   janitor::clean_names() %>%
#   haven::write_dta(paste0(main_path,"/output/","UG_precipitation_final_2006.dta"))
# 
# UG_precipitation_final_2011 %>%
#   janitor::clean_names() %>%
#   haven::write_dta(paste0(main_path,"/output/","UG_precipitation_final_2011.dta"))
# 
# UG_precipitation_final_2016 %>%
#   janitor::clean_names() %>%
#   haven::write_dta(paste0(main_path,"/output/","UG_precipitation_final_2016.dta"))


UG_precipitation_final_2000 %>% 
  dplyr::bind_rows(UG_precipitation_final_2006) %>% 
  dplyr::bind_rows(UG_precipitation_final_2011) %>% 
  dplyr::bind_rows(UG_precipitation_final_2016) %>% 
  janitor::clean_names() %>% 
  pivot_longer(cols = -c(geometry, dhsid, dhsyear, dhsclust,adm1name, urban_rura, latnum, longnum) ,
               names_to = 'prec',
               values_to = "value") %>%
  dplyr::select(-geometry) %>%
  arrange(year, dhsclust) %>%
  rename(time =prec, prec = value) %>%
  mutate(time=stringr::str_replace(time, "x", "prec")) %>% 
  pivot_wider(names_from = time , values_from = prec) %>% 
  arrange(dhsyear) %>% 
  haven::write_dta(paste0(main_path,"/output/","UG_precipitation_final_allyears.dta"))

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#Final Precipitation Data in long format
Uganda_prec_final <- UG_precipitation_final_2000 %>% 
  dplyr::bind_rows(UG_precipitation_final_2006) %>% 
  dplyr::bind_rows(UG_precipitation_final_2011) %>% 
  dplyr::bind_rows(UG_precipitation_final_2016) %>% 
  janitor::clean_names() %>% 
  pivot_longer(cols = -c(geometry, dhsid, dhsyear, dhsclust,adm1name, urban_rura, latnum, longnum) ,
               names_to = 'prec',
               values_to = "value") %>%
  dplyr::select(-geometry) %>%
  arrange(year, dhsclust) %>%
  rename(time =prec, prec = value) %>%
  dplyr::mutate(time = stringr::str_remove(time, "x"),
                time = lubridate::ymd(time),
                year = lubridate::year(time),
                month= lubridate::month(time),
                day = lubridate::day(time),
                lat_long = paste0(latnum,"-", longnum)) %>% 
  filter(lat_long != "0-0") %>% 
  group_by(lat_long, month) %>%
  mutate(prec_mean = mean(prec, rm.na= TRUE),
         prec_sd = sd(prec, na.rm = TRUE),
         count= n()) %>%    #Same in STATA (Validated)
  mutate(quarter = case_when(
    month <= 3 ~ "1",
    month > 3 & month <= 6 ~ "2",
    month > 6 & month <= 9 ~ "3",
    month > 9 & month <= 12 ~ "4"
  )
  ) %>% 
  arrange(dhsyear, dhsclust)

#Estimating Precipitation Anamoly - long format
Uganda_prec_final %>% 
  group_by(dhsyear, lat_long) %>% 
  mutate(prec_lag_p = 
           (prec - prec_mean)/prec_sd, 
         prec_rollMean_p3 = zoo::rollapply(prec_lag_p,
                                           3,
                                           mean,
                                           align='right',
                                           fill=NA), 
         prec_rollMean_p6 = zoo::rollapply(prec_lag_p,
                                           6,
                                           mean,
                                           align='right',
                                           fill=NA),
         prec_rollMean_p9 = zoo::rollapply(prec_lag_p,
                                           9,
                                           mean,
                                           align='right',
                                           fill=NA),
         prec_rollMean_p12 = zoo::rollapply(prec_lag_p,
                                            12,
                                            mean,
                                            align='right',
                                            fill=NA)
  ) %>% 
  haven::write_dta(paste0(main_path,"/output/","Uganda_prec_final_anamoly.dta"))

################################################################################
#Reading Temperature Files
################################################################################

for(yr in gps_years){
  year <- paste0(substr(yr, 2,8), "_temp")
  
  temp_files <- list.files(paste0(main_path, "/xlsx/climate_extraction/"), pattern = year)
  
  for (i in 1:length(temp_files)) {
    assign(paste0("temp_",year, i), 
           read.csv(paste0(main_path, "/xlsx/climate_extraction/", year, "_", i,".csv"))
    )
  }
}

#Merging Temperature Data files
#2000-2001
UG_temperature_final_2000 <-
  temp_UG_2000_temp1 %>% 
  left_join(temp_UG_2000_temp2 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry), 
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2000_temp3 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2000_temp4 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),  
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2000_temp5 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2000_temp6 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust"))

#2006
UG_temperature_final_2006 <-
  temp_UG_2006_temp1 %>% 
  left_join(temp_UG_2006_temp2 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry), 
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2006_temp3 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2006_temp4 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),  
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2006_temp5 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2006_temp6 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust"))
#2011
UG_temperature_final_2011 <-
  temp_UG_2011_temp1 %>% 
  left_join(temp_UG_2011_temp2 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry), 
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2011_temp3 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2011_temp4 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),  
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2011_temp5 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2011_temp6 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust"))

#2016
UG_temperature_final_2016 <-
  temp_UG_2016_temp1 %>% 
  left_join(temp_UG_2016_temp2 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry), 
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2016_temp3 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2016_temp4 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),  
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2016_temp5 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust")) %>% 
  left_join(temp_UG_2016_temp6 %>% 
              dplyr::select(-latnum, -longnum,-adm1name, -urban_rura, -geometry),
            by= c("dhsid", "dhsyear", "dhsclust"))

UG_temperature_final_2000%>% 
  bind_rows(UG_temperature_final_2006) %>% 
  bind_rows(UG_temperature_final_2011) %>% 
  bind_rows(UG_temperature_final_2016) %>% 
  janitor::clean_names() %>% 
  pivot_longer(cols = -c(geometry, dhsid, dhsyear, dhsclust,adm1name, urban_rura, latnum, longnum) ,
               names_to = 'temp',
               values_to = "value") %>%
  dplyr::select(-geometry) %>%
  arrange(year, dhsclust) %>%
  rename(time =temp, temp = value) %>%
  mutate(time=stringr::str_replace(time, "x", "temp")) %>% 
  pivot_wider(names_from = time , values_from = temp) %>% 
  arrange(dhsyear) %>% 
  haven::write_dta(paste0(main_path,"/output/","UG_temperature_final_allyears.dta"))


#Final Temperature Data in long format

Uganda_temp_final <-
  UG_temperature_final_2000 %>% 
  dplyr::bind_rows(UG_temperature_final_2006) %>% 
  dplyr::bind_rows(UG_temperature_final_2011) %>% 
  dplyr::bind_rows(UG_temperature_final_2016) %>% 
  janitor::clean_names() %>% 
  pivot_longer(cols = -c(geometry, dhsid, dhsyear, dhsclust,adm1name, urban_rura, latnum, longnum) ,
               names_to = 'temp',
               values_to = "value") %>% 
  # dplyr::select(-geometry) %>%
  arrange(year, dhsclust) %>%
  # dplyr::mutate(temp = stringr::str_replace(temp, "x", "temp")) %>%
  dplyr::select(-geometry) %>%
  arrange(year, dhsclust) %>%
  rename(time =temp, temp = value) %>% 
  dplyr::mutate(time = stringr::str_remove(time, "x"),
                time = lubridate::ymd(time),
                year = lubridate::year(time),
                month= lubridate::month(time),
                day = lubridate::day(time),
                lat_long = paste0(latnum,"-", longnum)) %>% 
  filter(lat_long != "0-0") %>% 
  group_by(lat_long, month) %>%
  mutate(temp_mean = mean(temp, rm.na= TRUE),
         temp_sd = sd(temp, na.rm = TRUE),
         count= n()) %>%    #Same in STATA (Validated)
  mutate(quarter = case_when(
    month <= 3 ~ "1",
    month > 3 & month <= 6 ~ "2",
    month > 6 & month <= 9 ~ "3",
    month > 9 & month <= 12 ~ "4"
  )
  ) %>% 
  arrange(dhsyear, dhsclust)

#Estimating Temperature Anamoly - Long format
Uganda_temp_final %>% 
  group_by(dhsyear, lat_long) %>% 
  mutate(temp_lag_p = 
           (temp - temp_mean)/temp_sd, 
         temp_rollMean_p3 = 
           zoo::rollapply(temp_lag_p,
                          3,
                          mean,
                          align='right',
                          fill=NA),
         temp_rollMean_p6 = zoo::rollapply(temp_lag_p,
                                           6,
                                           mean,
                                           align='right',
                                           fill=NA),
         temp_rollMean_p9 = zoo::rollapply(temp_lag_p,
                                           9,
                                           mean,
                                           align='right',
                                           fill=NA), 
         temp_rollMean_p12 = zoo::rollapply(temp_lag_p,
                                            12,
                                            mean,
                                            align='right',
                                            fill=NA)
  ) %>% 
  haven::write_dta(paste0(main_path,"/output/","Uganda_temp_final_anamoly.dta"))



