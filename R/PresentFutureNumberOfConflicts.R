###############################################################################

#The script performs the present and future number of conflicts calculation for
# each cluster in the respective DHS years

# 2016, 2011, 2006 and 2000-01 in this case
################################################################################


################################################################################  
################################################################################
################################################################################
#Final data output (DHS 2016) obtained for the buffer calculation combined file
################################################################################  
################################################################################
################################################################################

#Performing the present and future variable preparation for 2016 DHS 

#Data preparation for final DHS dataset merge


################################################################################  
################################################################################
################################################################################
                                #For 2016 DHS  
################################################################################  
################################################################################
################################################################################

################For Battles based conflicts####################

# (All DHS clusters covered in quarter 2, 3 and 4)
final_data_DHS2016 %>% 
  distinct(DHSQUARTER)

DHS2016_conflicts_battles_pf <- 
  
  final_data_DHS2016 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2016 | conflict_year == 2017) %>% 
  select(-violence_against_civilians_occurred,-riots_occured, -protests_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(battle_occured),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2016_conflicts_battles_pf <- 
  DHS2016_conflicts_battles_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(battles_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            battles_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2017 ouput in csv
Final_DHS2016_conflicts_battles_pf %>% 
  write.csv("../xlsx/buffers/FinalData_battles_2016.csv")


##########For Violence Against civilians Violence######################
DHS2016_conflicts_vac_pf <- 
  
  final_data_DHS2016 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2016 | conflict_year == 2017) %>% 
  select(-battle_occured,-riots_occured, -protests_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(violence_against_civilians_occurred),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2016_conflicts_vac_pf <- 
  DHS2016_conflicts_vac_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(vac_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            vac_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2016 output in csv
Final_DHS2016_conflicts_vac_pf %>% 
  write.csv("../xlsx/buffers/FinalData_vac_2016.csv")


##########For Riots Violence######################
DHS2016_conflicts_riots_pf <- 
  
  final_data_DHS2016 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2016 | conflict_year == 2017) %>% 
  select(-battle_occured,-violence_against_civilians_occurred, -protests_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(riots_occured),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2016_conflicts_riots_pf <- 
  DHS2016_conflicts_riots_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(riots_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            riots_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2016 output in csv
Final_DHS2016_conflicts_riots_pf %>% 
  write.csv("../xlsx/buffers/FinalData_riots_2016.csv")

##########For Protests Violence######################
DHS2016_conflicts_protests_pf <- 
  
  final_data_DHS2016 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2016 | conflict_year == 2017) %>% 
  select(-battle_occured,-violence_against_civilians_occurred, -riots_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(protests_occured),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2016_conflicts_protests_pf <- 
  DHS2016_conflicts_protests_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(protests_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            protests_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2016 output in csv
Final_DHS2016_conflicts_riots_pf %>% 
  write.csv("../xlsx/buffers/FinalData_protests_2016.csv")
################################################################################  
################################################################################
################################################################################



################################################################################  
################################################################################
################################################################################
                                #For 2011  DHS
################################################################################  
################################################################################
################################################################################
################For Battles based conflicts####################

# (All DHS clusters covered in quarter 2, 3 and 4)
final_data_DHS2011 %>% 
  distinct(DHSQUARTER)

DHS2011_conflicts_battles_pf <- 
  
  final_data_DHS2011 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2011 | conflict_year == 2012) %>% 
  select(-violence_against_civilians_occurred,-riots_occured, -protests_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(battle_occured),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2011_conflicts_battles_pf <- 
  DHS2011_conflicts_battles_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(battles_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            battles_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2011 ouput in csv
Final_DHS2011_conflicts_battles_pf %>% 
  write.csv("../xlsx/buffers/FinalData_battles_2011.csv")


##########For Violence Against civilians Violence######################
DHS2011_conflicts_vac_pf <- 
  
  final_data_DHS2011 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2011 | conflict_year == 2012) %>% 
  select(-battle_occured,-riots_occured, -protests_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(violence_against_civilians_occurred),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2011_conflicts_vac_pf <- 
  DHS2011_conflicts_vac_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(vac_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            vac_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2011 output in csv
Final_DHS2011_conflicts_vac_pf %>% 
  write.csv("../xlsx/buffers/FinalData_vac_2011.csv")


##########For Riots Violence######################
DHS2011_conflicts_riots_pf <- 
  
  final_data_DHS2011 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2011 | conflict_year == 2012) %>% 
  select(-battle_occured,-violence_against_civilians_occurred, -protests_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(riots_occured),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2011_conflicts_riots_pf <- 
  DHS2011_conflicts_riots_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(riots_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            riots_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2011 output in csv
Final_DHS2011_conflicts_riots_pf %>% 
  write.csv("../xlsx/buffers/FinalData_riots_2011.csv")

##########For Protests Violence######################
DHS2011_conflicts_protests_pf <- 
  
  final_data_DHS2011 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2011 | conflict_year == 2012) %>% 
  select(-battle_occured,-violence_against_civilians_occurred, -riots_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(protests_occured),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2011_conflicts_protests_pf <- 
  DHS2011_conflicts_protests_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(protests_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            protests_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2011  output in csv
Final_DHS2011_conflicts_riots_pf %>% 
  write.csv("../xlsx/buffers/FinalData_protests_2011.csv")


################################################################################  
################################################################################
################################################################################
                        #For 2006  DHS
################################################################################  
################################################################################
################################################################################
################For Battles based conflicts####################

# (All DHS clusters covered in quarter 2, 3 and 4)
final_data_DHS2006 %>% 
  distinct(DHSQUARTER)

DHS2006_conflicts_battles_pf <- 
  
  final_data_DHS2006 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2006 | conflict_year == 2007) %>% 
  select(-violence_against_civilians_occurred,-riots_occured, -protests_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(battle_occured),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>%
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2006_conflicts_battles_pf <- 
  DHS2006_conflicts_battles_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(battles_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            battles_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2006 ouput in csv
Final_DHS2006_conflicts_battles_pf %>% 
  write.csv("../xlsx/buffers/FinalData_battles_2006.csv")


##########For Violence Against civilians Violence######################
DHS2006_conflicts_vac_pf <- 
  
  final_data_DHS2006 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2006 | conflict_year == 2007) %>% 
  select(-battle_occured,-riots_occured, -protests_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(violence_against_civilians_occurred),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2006_conflicts_vac_pf <- 
  DHS2006_conflicts_vac_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(vac_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            vac_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2006 output in csv
Final_DHS2006_conflicts_vac_pf %>% 
  write.csv("../xlsx/buffers/FinalData_vac_2006.csv")


##########For Riots Violence######################
DHS2006_conflicts_riots_pf <- 
  
  final_data_DHS2006 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2006 | conflict_year == 2007) %>% 
  select(-battle_occured,-violence_against_civilians_occurred, -protests_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(riots_occured),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2006_conflicts_riots_pf <- 
  DHS2006_conflicts_riots_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(riots_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            riots_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2006 output in csv
Final_DHS2006_conflicts_riots_pf %>% 
  write.csv("../xlsx/buffers/FinalData_riots_2006.csv")

##########For Protests Violence######################
DHS2006_conflicts_protests_pf <- 
  
  final_data_DHS2006 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2006 | conflict_year == 2007) %>% 
  select(-battle_occured,-violence_against_civilians_occurred, -riots_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(protests_occured),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2006_conflicts_protests_pf <- 
  DHS2006_conflicts_protests_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(protests_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            protests_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2006  output in csv
Final_DHS2006_conflicts_riots_pf %>% 
  write.csv("../xlsx/buffers/FinalData_protests_2006.csv")

################################################################################  
################################################################################
################################################################################
                                #For 2000-01  DHS
################################################################################  
################################################################################
################################################################################
################For Battles based conflicts####################

# (All DHS clusters covered in quarter 1, 3 and 4)
final_data_DHS2000 %>% 
  distinct(DHSQUARTER)

DHS2000_conflicts_battles_pf <- 
  
  final_data_DHS2000 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2000 | conflict_year == 2001) %>% 
  select(-violence_against_civilians_occurred,-riots_occured, -protests_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(battle_occured),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 2) ~ "future_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 3) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
             
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2000_conflicts_battles_pf <- 
  DHS2000_conflicts_battles_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(battles_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            battles_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2000 ouput in csv
Final_DHS2000_conflicts_battles_pf %>% 
  write.csv("../xlsx/buffers/FinalData_battles_2000.csv")


##########For Violence Against civilians Violence######################
DHS2000_conflicts_vac_pf <- 
  
  final_data_DHS2000 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2000 | conflict_year == 2001) %>% 
  select(-battle_occured,-riots_occured, -protests_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(violence_against_civilians_occurred),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 2) ~ "future_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 3) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2000_conflicts_vac_pf <- 
  DHS2000_conflicts_vac_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(vac_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            vac_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2000 output in csv
Final_DHS2000_conflicts_vac_pf %>% 
  write.csv("../xlsx/buffers/FinalData_vac_2000.csv")


##########For Riots Violence######################
DHS2000_conflicts_riots_pf <- 
  
  final_data_DHS2000 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2000 | conflict_year == 2001) %>% 
  select(-battle_occured,-violence_against_civilians_occurred, -protests_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(riots_occured),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 2) ~ "future_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 3) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2000_conflicts_riots_pf <- 
  DHS2000_conflicts_riots_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(riots_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            riots_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2000 output in csv
Final_DHS2000_conflicts_riots_pf %>% 
  write.csv("../xlsx/buffers/FinalData_riots_2000.csv")

##########For Protests Violence######################
DHS2000_conflicts_protests_pf <- 
  
  final_data_DHS2000 %>% #filter(conflict_year == 2016 & DHSCLUST == 1) %>% View()
  filter(conflict_year == 2000 | conflict_year == 2001) %>% 
  select(-battle_occured,-violence_against_civilians_occurred, -riots_occured) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter) %>%  #conflict_month 
  summarise(number_of_conflicts = sum(protests_occured),
            .groups = "drop") %>%
  mutate(conflict_map = 
           case_when(
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter) ~ "present_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 1) ~ "future_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 2) ~ "future_conflicts",
             (DHSYEAR == conflict_year) &  (DHSQUARTER==conflict_quarter - 3) ~ "future_conflicts",
             (DHSYEAR == conflict_year - 1) &  (DHSQUARTER >= conflict_quarter) ~ "future_conflicts",
           )) %>% 
  filter(!is.na(conflict_map)) %>%
  pivot_wider(names_from = conflict_map, values_from = number_of_conflicts) %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM,
           conflict_year, conflict_quarter)

Final_DHS2000_conflicts_protests_pf <- 
  DHS2000_conflicts_protests_pf %>% 
  group_by(DHSYEAR, DHSCLUST, DHSQUARTER, LONGNUM, LATNUM) %>% 
  summarise(protests_present_number_of_conflicts = sum(present_conflicts, na.rm = T),
            protests_future_number_of_conflicts = sum(future_conflicts, na.rm= T),
            .groups = "drop") 

#Final data set for 2000  output in csv
Final_DHS2000_conflicts_riots_pf %>% 
  write.csv("../xlsx/buffers/FinalData_protests_2000.csv")

################################################################################  
################################################################################
################################################################################

#To  make combined data set of present and futue conflicts of all dhsyears

Final_2000 <-

Final_DHS2000_conflicts_battles_pf %>% 
  left_join(Final_DHS2000_conflicts_vac_pf, 
            by=c("DHSYEAR", "DHSCLUST", "DHSQUARTER", "LONGNUM", "LATNUM")) %>% 
  left_join(Final_DHS2000_conflicts_riots_pf, 
            by=c("DHSYEAR", "DHSCLUST", "DHSQUARTER", "LONGNUM", "LATNUM")) %>% 
  left_join(Final_DHS2000_conflicts_protests_pf, 
            by=c("DHSYEAR", "DHSCLUST", "DHSQUARTER", "LONGNUM", "LATNUM")) 
  



Final_2006 <-
  
  Final_DHS2006_conflicts_battles_pf %>% 
  left_join(Final_DHS2006_conflicts_vac_pf, 
            by=c("DHSYEAR", "DHSCLUST", "DHSQUARTER", "LONGNUM", "LATNUM")) %>% 
  left_join(Final_DHS2006_conflicts_riots_pf, 
            by=c("DHSYEAR", "DHSCLUST", "DHSQUARTER", "LONGNUM", "LATNUM")) %>% 
  left_join(Final_DHS2006_conflicts_protests_pf, 
            by=c("DHSYEAR", "DHSCLUST", "DHSQUARTER", "LONGNUM", "LATNUM")) 




Final_2011 <-
  
  Final_DHS2011_conflicts_battles_pf %>% 
  left_join(Final_DHS2011_conflicts_vac_pf, 
            by=c("DHSYEAR", "DHSCLUST", "DHSQUARTER", "LONGNUM", "LATNUM")) %>% 
  left_join(Final_DHS2011_conflicts_riots_pf, 
            by=c("DHSYEAR", "DHSCLUST", "DHSQUARTER", "LONGNUM", "LATNUM")) %>% 
  left_join(Final_DHS2011_conflicts_protests_pf, 
            by=c("DHSYEAR", "DHSCLUST", "DHSQUARTER", "LONGNUM", "LATNUM")) 

Final_2016 <-
  
  Final_DHS2016_conflicts_battles_pf %>% 
  left_join(Final_DHS2016_conflicts_vac_pf, 
            by=c("DHSYEAR", "DHSCLUST", "DHSQUARTER", "LONGNUM", "LATNUM")) %>% 
  left_join(Final_DHS2016_conflicts_riots_pf, 
            by=c("DHSYEAR", "DHSCLUST", "DHSQUARTER", "LONGNUM", "LATNUM")) %>% 
  left_join(Final_DHS2016_conflicts_protests_pf, 
            by=c("DHSYEAR", "DHSCLUST", "DHSQUARTER", "LONGNUM", "LATNUM")) 

#Final combined dataset
FinalData_b_v_r_p_ALLYEARS <-

Final_2016 %>% 
  bind_rows(Final_2011) %>% 
  bind_rows(Final_2006) %>% 
  bind_rows(Final_2000)


FinalData_b_v_r_p_ALLYEARS %>% 
  write.csv("../xlsx/buffers/FinalData_conflicts_ALLYEARS.csv")


