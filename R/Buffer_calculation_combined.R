#Buffer Calculation
################################################################################
rm(list=ls())

#Utils required
suppressMessages(if (!require("pacman")) install.packages("pacman"))
suppressMessages(pacman::p_load(tidyverse, sf, mapview, units, haven, janitor))

################################################################################
#Reading the Philippines shapefile (Not necessary)
php_shp <- 
  read_sf("../ShapeFiles/Uganda_Shapefiles/DISTRICTS_2018_UTM_36N.shp")
################################################################################

#Reading the Uganda Conflicts file (UCDP) 
#NOTE: (ACLED data might be different so slight adjustment might be needed)
UG_conflicts <- 
  haven::read_dta("../output/Uganda_conflicts.dta") %>% 
  dplyr::select(year, quarter, month, latitude, longitude, event_type, fatalities)  

#Aggregating conflicts over the years and GPS points
#Fatalities in conflcits (Even fatalities =0, still a conflict incident)
UG_conflicts <-   
  UG_conflicts %>% 
  # filter(type_of_violence == "State Based Conf" | 
  #          type_of_violence == "One Sided Violence") %>% 
  group_by(year, quarter, month, longitude, latitude, event_type) %>% #month
  summarise(fatalities = sum(fatalities), 
            .groups = "drop") %>% 
  filter(!is.na(fatalities)) %>%  
  pivot_wider(names_from = event_type, 
              values_from = fatalities) %>% 
  janitor::clean_names()

################################################################################
################################################################################
#Paths (adjust as per your project root folder)
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


# for(gps in dhs_gps){
# 
#   assign(substring(gps, 2, 8), read_sf(paste0(shp_path, gps)))
# 
# }

#Not using shape files now -  to have dhscluster and quarters mapping
#After preparation of climate anomalies: in the FINAL_DATASET line no 70

dhsclust_quarter_map <- 
  haven::read_dta("../output/dhscluster_quarter_mapping.dta") %>% 
  rename(DHSCLUST = dhsclust, DHSYEAR = dhsyear, LONGNUM = longnum, LATNUM = latnum, QUARTER= quarter)  %>% 
  distinct(LONGNUM, LATNUM, DHSYEAR, DHSCLUST, QUARTER) %>% 
  st_as_sf(coords= c("LONGNUM", "LATNUM"), crs=4326) %>%
  mutate(LONGNUM = st_coordinates(.)[, 1],
         LATNUM = st_coordinates(.)[, 2])

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

#All years buffers calculation  (With shapefile)

# for(yr in dhs_years){
#   
#   data_shp <- get(str_c("UG_",yr))
#   
#   assign(
#     str_c("buffer_", yr),
#     data_shp %>%
#      st_transform(crs = 9754) %>% #Uganda  (For speedy and accurate calculation):    https://epsg.io/9754
#       st_buffer(
#         dist = dist,
#         nQuadSegs = 20,   #70  change to control the segments of a circle quadrant, if high for more perfect circles, file size and calculation time would go up
#         endCapStyle = "ROUND",
#         joinStyle = "ROUND",
#         mitreLimit = 1,
#         singleSide = FALSE)%>% 
#       st_transform(crs = 4326)  #Back to 4326 for plotting and merging with conflict features
#   ) 
# }
#buffer_2000
#buffer_2006
#buffer_2011
#buffer_2016

# Combining all buffers for simplicity  (Change as per your DHS years)
# buffer_all <- 
#   buffer_2000 %>% 
#   bind_rows(buffer_2006) %>% 
#   bind_rows(buffer_2011) %>% 
#   bind_rows(buffer_2016)

#All years buffers calculation  (Without shapefile: with quarters calculation)
buffer_all_new <- 
  dhsclust_quarter_map %>%
  st_transform(crs = 32636) %>% #Uganda  (For speedy and accurate calculation):    https://epsg.io/9754
  st_buffer(
    dist = dist,
    nQuadSegs = 70,   #70  change to control the segments of a circle quadrant, if high for more perfect circles, file size and calculation time would go up
    endCapStyle = "ROUND",
    joinStyle = "ROUND",
    mitreLimit = 1,
    singleSide = FALSE) %>% 
  st_transform(crs = 4326)  #Back to 4326 for plotting and merging with conflict features

#Making separate Buffers for 4 DHS years again to make separate tables

buffer_2000 <- buffer_all_new %>% 
  filter(DHSYEAR == dhs_years[1])

buffer_2006 <- buffer_all_new %>% 
  filter(DHSYEAR == dhs_years[2])

buffer_2011 <- buffer_all_new %>% 
  filter(DHSYEAR == dhs_years[3])

buffer_2016 <- buffer_all_new %>% 
  filter(DHSYEAR == dhs_years[4])

################################################################################

#To make a complete time series of conflicts as sf object to overlay on buffers
conflicts_all <- 
  UG_conflicts %>%
  # filter(!is.na(state_based_conf) |
  #          !is.na(one_sided_violence)) %>% 
  # year>=2000) %>%  
  rename(LONGNUM=longitude, LATNUM=latitude) %>%
  st_as_sf(coords= c("LONGNUM", "LATNUM"), crs=4326) %>%
  mutate(LONGNUM = st_coordinates(.)[, 1],
         LATNUM = st_coordinates(.)[, 2]) 

# conflicts_all %>% as_tibble() %>%  filter(year == 2020) %>% distinct(month) 

################################################################################

#For whole time series of conflicts overlapping buffers

#Overlapping features of buffers and conflicts

################################################################################
#Looping each month (1:12) of conflict years from 1997-2020 over the buffers of the each DHS year
#Keeping the buffers which have 0 conflicts
#Final Data at month granularity
################################################################################

conflict_years <- unique(conflicts_all$year)

conflict_month <- c(1:12)

dhs_years <- dhs_years


# Making separate datasets of conflict datasets at month level within conflict years


for(yr in conflict_years){
  
  for(mn in conflict_month){
    
    assign(paste0("conflicts_", yr, "_", mn),
           UG_conflicts %>%
             filter(
               # !is.na(state_based_conf) |
               #        !is.na(one_sided_violence),
                    year == yr,
                    month== mn) %>%   
             rename(LONGNUM=longitude, 
                    LATNUM=latitude) %>%
             st_as_sf(coords= c("LONGNUM", "LATNUM"), crs=4326) %>%
             mutate(LONGNUM = st_coordinates(.)[, 1],
                    LATNUM = st_coordinates(.)[, 2]) 
    )
    
  }
}


#For All DHS years complete calculation in 1 go - Use this loop

for(dhs in dhs_years){
  
  for(yr in conflict_years){
    
    for(mn in conflict_month){
      
      assign(paste0("conf_count_", yr, "_", mn), 
             st_intersects(get(paste0("buffer_",dhs)) %>%  st_transform(crs = 32636) , 
                           get(paste0("conflicts_", yr, "_", mn)) %>% st_transform(crs = 32636)) 
      )
      
      assign(paste0("intersects_", yr, "_", mn),  lengths(get(paste0("conf_count_", yr, "_", mn)))     >  0)
      assign(paste0("nointersects_", yr, "_", mn),  lengths(get(paste0("conf_count_" , yr, "_", mn))) == 0)
      
      
      assign(paste0("conf_count_", yr, "_", mn, "_overlap"),
             filter(get(paste0("buffer_",dhs)), get(paste0("intersects_", yr, "_", mn)))
      )
      
      assign(paste0("conf_count_", yr,"_", mn, "_nooverlap"),
             filter(get(paste0("buffer_",dhs)), get(paste0("nointersects_", yr, "_", mn)))
      )
      
      suppressWarnings(
        assign(paste0("conflict_intersect_", yr, "_", mn),
               st_intersection(get(paste0('conf_count_', yr, "_", mn, "_overlap")) %>%  st_transform(crs = 32636),
                               get(paste0("conflicts_", yr, "_", mn))  %>% st_transform(crs = 32636)) %>%
                 st_transform(crs=4326)
        )
      )
      
      assign(paste0("DHS_", dhs ,"_conflict_intersect_", yr, "_", mn),
             get(paste0("conflict_intersect_", yr, "_", mn)) %>%
               bind_rows(get(paste0("conf_count_", yr,"_", mn, "_nooverlap"))) %>% 
               arrange(DHSCLUST) %>% 
               as_tibble() %>% 
               select(-geometry) %>% 
               mutate(year = ifelse(is.na(year), yr , year),
                      month=ifelse(is.na(month), mn , month),#for month NAs, which are not overlapped<<<<<<<<<<<<<<<<<<<<Check (Might try pivoting here)
                      battles = ifelse(is.na(battles), 0, battles),
                      violence_against_civilians = ifelse(is.na(violence_against_civilians), 0 , violence_against_civilians),
                      riots = ifelse(is.na(riots), 0, riots),
                      protests = ifelse(is.na(protests), 0, protests),
                      ) %>% 
               rename(conflict_long= LONGNUM.1,
                      conflict_lat = LATNUM.1,
                      present_battle_fatalities = battles,
                      present_violence_against_civilians_fatalities = violence_against_civilians,
                      present_riots_fatalities = riots,
                      present_protests_fatalities = protests,
                      conflict_year = year,
                      conflict_quarter = quarter,
                      conflict_month = month) 
      )
    }
  }
  
}

################################################################################
################################################################################

#Okay
paste0("DHS_", "2011" ,"_conflict_intersect_", 2016, "_", 1) %>%
  get() %>% 
  filter(DHSCLUST==1) %>%
  distinct(conflict_month)

#Data lists at month and year level for all DHS Years

year_list_2000 <- list()
year_list_2000 = vector("list", length = length(conflict_years))

month_list_2000 <- list()
month_list_2000 <- vector("list", length=length(conflict_month))


year_list_2006 <- list()
year_list_2006 = vector("list", length = length(conflict_years))

month_list_2006 <- list()
month_list_2006 <- vector("list", length=length(conflict_month))

year_list_2011 <- list()
year_list_2011 = vector("list", length = length(conflict_years))

month_list_2011 <- list()
month_list_2011 <- vector("list", length=length(conflict_month))

year_list_2016 <- list()
year_list_2016 = vector("list", length = length(conflict_years))

month_list_2016 <- list()
month_list_2016 <- vector("list", length=length(conflict_month))

# For DHS-2000 final list

for(yr in conflict_years){
  
  year_list_2000[[yr]]  <-   year_list_2000
  
  for(mn in conflict_month){
    
    month_list_2000[[mn]]  <-
      get(paste0("DHS_", "2000","_conflict_intersect_", yr, "_", mn))
    
  }
  
  year_list_2000[[yr]] = bind_rows(month_list_2000)
  
}

# For DHS-2006 final list

for(yr in conflict_years){
  
  year_list_2006[[yr]]  <-   year_list_2006
  
  for(mn in conflict_month){
    
    month_list_2006[[mn]]  <-
      get(paste0("DHS_", "2006","_conflict_intersect_", yr, "_", mn))
    
  }
  
  year_list_2006[[yr]] = bind_rows(month_list_2006)
  
}

# For DHS-2011 final list

for(yr in conflict_years){
  
  year_list_2011[[yr]]  <-   year_list_2011
  
  for(mn in conflict_month){
    
    month_list_2011[[mn]]  <-
      get(paste0("DHS_", "2011","_conflict_intersect_", yr, "_", mn))
    
  }
  
  year_list_2011[[yr]] = bind_rows(month_list_2011)
  
}

# For DHS-2016 final list

for(yr in conflict_years){
  
  year_list_2016[[yr]]  <-   year_list_2016
  
  for(mn in conflict_month){
    
    month_list_2016[[mn]]  <-
      get(paste0("DHS_", "2016","_conflict_intersect_", yr, "_", mn))
    
  }
  
  year_list_2016[[yr]] = bind_rows(month_list_2016)
  
}


#Final 2000 Data table
final_data_DHS2000 = bind_rows(year_list_2000) %>% 
  mutate(battle_occured = ifelse(present_battle_fatalities == 0, 0 , 1),
         violence_against_civilians_occurred = ifelse(present_violence_against_civilians_fatalities == 0, 0 , 1), #Making separate indictors for state-based and one-sided violence
         riots_occured = ifelse(present_riots_fatalities == 0, 0 , 1),
         protests_occured = ifelse(present_protests_fatalities == 0, 0 , 1)) %>% 
  rename(DHSQUARTER = QUARTER) %>% 
  mutate(conflict_quarter= ifelse(conflict_month %in% c(1:3), 1, conflict_quarter),
         conflict_quarter= ifelse(conflict_month %in% c(4:6), 2, conflict_quarter),
         conflict_quarter= ifelse(conflict_month %in% c(7:9), 3, conflict_quarter),
         conflict_quarter= ifelse(conflict_month %in% c(10:12),4, conflict_quarter))


#Final 2006 Data table
final_data_DHS2006 = bind_rows(year_list_2006) %>% 
  mutate(battle_occured = ifelse(present_battle_fatalities == 0, 0 , 1),
         violence_against_civilians_occurred = ifelse(present_violence_against_civilians_fatalities == 0, 0 , 1), #Making separate indictors for state-based and one-sided violence
         riots_occured = ifelse(present_riots_fatalities == 0, 0 , 1),
         protests_occured = ifelse(present_protests_fatalities == 0, 0 , 1)) %>% 
  rename(DHSQUARTER = QUARTER) %>% 
  mutate(conflict_quarter= ifelse(conflict_month %in% c(1:3), 1, conflict_quarter),
         conflict_quarter= ifelse(conflict_month %in% c(4:6), 2, conflict_quarter),
         conflict_quarter= ifelse(conflict_month %in% c(7:9), 3, conflict_quarter),
         conflict_quarter= ifelse(conflict_month %in% c(10:12),4, conflict_quarter))


#Final 2011 Data table
final_data_DHS2011 = bind_rows(year_list_2011) %>% 
  mutate(battle_occured = ifelse(present_battle_fatalities == 0, 0 , 1),
         violence_against_civilians_occurred = ifelse(present_violence_against_civilians_fatalities == 0, 0 , 1), #Making separate indictors for state-based and one-sided violence
         riots_occured = ifelse(present_riots_fatalities == 0, 0 , 1),
         protests_occured = ifelse(present_protests_fatalities == 0, 0 , 1)) %>% 
  rename(DHSQUARTER = QUARTER) %>% 
  mutate(conflict_quarter= ifelse(conflict_month %in% c(1:3), 1, conflict_quarter),
         conflict_quarter= ifelse(conflict_month %in% c(4:6), 2, conflict_quarter),
         conflict_quarter= ifelse(conflict_month %in% c(7:9), 3, conflict_quarter),
         conflict_quarter= ifelse(conflict_month %in% c(10:12),4, conflict_quarter))


#Final 2016 Data table
final_data_DHS2016 = bind_rows(year_list_2016) %>% 
  mutate(battle_occured = ifelse(present_battle_fatalities == 0, 0 , 1),
         violence_against_civilians_occurred = ifelse(present_violence_against_civilians_fatalities == 0, 0 , 1), #Making separate indictors for state-based and one-sided violence
         riots_occured = ifelse(present_riots_fatalities == 0, 0 , 1),
         protests_occured = ifelse(present_protests_fatalities == 0, 0 , 1)) %>% 
  rename(DHSQUARTER = QUARTER) %>% 
  mutate(conflict_quarter= ifelse(conflict_month %in% c(1:3), 1, conflict_quarter),
         conflict_quarter= ifelse(conflict_month %in% c(4:6), 2, conflict_quarter),
         conflict_quarter= ifelse(conflict_month %in% c(7:9), 3, conflict_quarter),
         conflict_quarter= ifelse(conflict_month %in% c(10:12),4, conflict_quarter))


################################################################################

################################################################################

#Final Datasets of 4 DHS years with complete time-series of conflicts

final_data_DHS2000 %>% 
  write.csv("../xlsx/buffers/buffer_conflict_2000.csv")

final_data_DHS2006 %>% 
  write.csv("../xlsx/buffers/buffer_conflict_2006.csv")

final_data_DHS2011 %>% 
  write.csv("../xlsx/buffers/buffer_conflict_2011.csv")

final_data_DHS2016 %>% 
  write.csv("../xlsx/buffers/buffer_conflict_2016.csv")

################################################################################
##Okay 

#Drawing buffered dhs points
buffer_2016 %>%
  mapview()

#Conflicts points exactly ON the dhs clusters now  #OKAY ALL
buffer_2011 %>% 
  filter(LONGNUM>0) %>% 
  select(-LONGNUM, -LATNUM) %>% 
  ggplot()+
  geom_sf() +
  geom_point(aes(conflict_long, conflict_lat), 
             size=2, 
             alpha=1,
             data=final_data_DHS2016 %>% 
               filter( 
                 # !is.na(present_state_based_conf_fatalities),
                 # one_sided_conflict_occurred != 0,
                 conflict_year == 2011)
  )


