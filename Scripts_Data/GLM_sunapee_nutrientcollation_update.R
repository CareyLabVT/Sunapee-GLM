#*****************************************************************
#*      Cary Institute of Ecosystem Studies (Millbrook, NY)      *
#*                                                               *
#* TITLE:   CNH-GLM_sunapee_nutrientcollation_update.r           *
#* AUTHOR:  Bethel Steele                                        *
#* SYSTEM:  Lenovo ThinkCentre, Win 10, R 3.6.3                  *
#* DATE:    22Mar2017                                            *
#* PROJECT: CNH-GLM                                              *
#* PURPOSE: collate nutrient data for inflows and, observed      *
#*          lake chemistry 1979-2013 for use in CNH-GLM project  *
#* LAST MODIFIED: 21Sept2020                                     *
#* BY:      B. Steele                                            *
#* NOTES:   v 21Sept2020 - update data collation through 2019    *
#*****************************************************************

library(tidyverse) #v 1.3.0
library(readxl) #v 1.3.1
library(doBy)

#set up directories
dump.dir.streamchem = 'C:/Users/steeleb/Dropbox/Lake Sunapee/misc/GLM/Final Data/inflow stream chem/'
dump.dir.calibration = 'C:/Users/steeleb/Dropbox/Lake Sunapee/misc/GLM/Final Data/calibration/'
LSPA.data.dir <- 'C:/Users/steeleb/Dropbox/Lake Sunapee/long term Sunapee data/'
CCC.data.dir <- "C:/Users/steeleb/Dropbox/Lake Sunapee/Sunapee tribs/data from Cayelan/"
SAS.data.dir = "C:/Users/steeleb/Dropbox/Lake Sunapee/Sunapee tribs/sasdatalibr/"


#####**** STREAM INFLOW WATER QUALITY ****####
# salt: mg/L (average daily streamflow salinity)
# and then a whole bunch of water quality parameters: all in mmol/m^3 (average daily streamflow water quality constituent concentrations).  
# Kak mentioned that Mandy had experience working with the data from Christina Macki in 2005 plus assorted samples of C, N, P in the streams over time, 
# to fill this in.  We obviously will not have data coverage for most days, so Kak suggested creating rating curves or thinking through interpolation 
# from analyzing the precip data at the same time period so that we have a daily value over time.

#bring in lspa data (LMP data base) -- data should be attributed to the LSPA
lspa_chem_inflow <- read_csv(paste0(LSPA.data.dir, 'master files/stream_chem_1986-2019_v27Jul2020.csv'))
str(lspa_chem_inflow)
#subset for desired streams
lspa_streamchem <- subset(lspa_chem_inflow, subset=station %in% c(505, 510, 515, 540, 640, 665, 670, 720, 750, 760, 788, 790, 800, 805, 830, 835))

#subset for desired variables
unique(lspa_streamchem$parameter)

lspa_stream_TP <- lspa_streamchem %>% 
  filter(parameter == 'TP_mgl')

#subset for non-NA data only
lspa_stream_TP <- lspa_stream_TP %>% 
  filter(!is.na(value))
range(lspa_stream_TP$value)

#convert to mmol/m3 (mg/L -> mmol/L : *1/MW) (mmol/L -> mmol/m3 : *1000)
lspa_stream_TP$TP_mmolm3 <- lspa_stream_TP$value*(1/30.973761)*(1000)

#rename for merge
lspa_stream_TP <- lspa_stream_TP %>% 
  rename(stream_no = station)
lspa_stream_TP <- subset(lspa_stream_TP, select=c('date', 'stream_no', 'TP_mmolm3', 'flag'))

head(lspa_stream_TP)

#bring in Cayelan's data -- data should be attributed to Cayelan Carey
TNTP_2012 <- read_csv(paste0(CCC.data.dir, 'Sunapee_Inflows_2012_TNTP.csv'),
                      col_names = c('Sample.ID', 'Stream.ID', 'Stream.Name', 'Date', 'TP_ug.L', 'TN_ug.L', 'Notes')) # data has been QAQC'd by Cayelan. No need to reset DL data #in begwrspc

#format date
TNTP_2012$date <- as.Date(TNTP_2012$Date, format='%m/%d/%Y')
#subset for data associated with inflow streams
TNTP_stream_CCC <- subset(TNTP_2012, subset=Stream.ID %in% c(505, 510, 515, 540, 640, 665, 670, 720, 750, 760, 788, 790, 800, 805, 830, 835))
#convert to mmol/m3 (ug/L -> mg/L : *1/1000) (mg/L -> mmol/L : *1/MW) (mmol/L -> mmol/m3 : *1000)
TNTP_stream_CCC$TP_mmolm3 <- as.numeric(TNTP_stream_CCC$TP_ug.L)*(1/1000)*(1/30.973761)*(1000)
TNTP_stream_CCC$TN_mmolm3 <- as.numeric(TNTP_stream_CCC$TN_ug.L)*(1/1000)*(1/14.0067)*(1000)
#subset for desired fields
TNTP_stream_CCC <- subset(TNTP_stream_CCC, select=c('Stream.ID', 'date', 'TP_mmolm3', 'TN_mmolm3'))
#rename stream ID
TNTP_stream_CCC <- TNTP_stream_CCC %>% 
  rename(stream_no = Stream.ID) %>% 
  mutate(stream_no = as.numeric(stream_no))

head(TNTP_stream_CCC)

#in sasdatalibr: 'DOC_data.csv'; 'all_ion_data.csv'; 'diss_P_data' -- data should be attributed to: Kathleen Weathers (Cary), Holly Ewing (Bates), 
#               Cathy Cottingham (Dartmouth), David Fischer (Cary)

doc <- read_csv(paste0(SAS.data.dir, 'DOC_data.csv')) 
ion <- read_csv(paste0(SAS.data.dir, 'all_ion_data.csv')) 

#format date
doc$date <- as.Date(doc$collect_date, format="%Y-%m-%d")
ion$date <- as.Date(ion$collect_date, format="%Y-%m-%d")
# p$date <- as.Date(p$collect_date, format="%Y-%m-%d")

#subset for data associated with stream inflow 505, 665, 788, 790, 805, 830
doc_sub <- subset(doc, subset=stream_no %in% c(505, 510, 515, 540, 640, 665, 670, 720, 750, 760, 788, 790, 800, 805, 830, 835))
ion_sub <- subset(ion, subset=stream_no %in% c(505, 510, 515, 540, 640, 665, 670, 720, 750, 760, 788, 790, 800, 805, 830, 835))

doc_sub$flag <- NA_character_
ion_sub$flag <- NA_character_

#select all data BDL, set to 1/2 DL
range(doc_sub$DOC_mgl)
ix=which(doc_sub$DOC_mgl <= 1)
doc_sub$flag[ix] = 'BDL'

range(ion_sub$TN_mgl)
ix=which(ion_sub$TN_mgl <= 0.002)
ion_sub$flag[ix] = 'BDL'

#convert to mmolm3(mg/L -> mmol/L : *1/MW) (mmol/L -> mmol/m3 : *1000)
doc_sub$DOC_mmolm3 <- doc_sub$DOC_mgl*(1/12.0107)*(1/0.001)
ion_sub$TN_mmolm3 <- ion_sub$TN_mgl*(1/14.0067)*(1/0.001) 

#merge datasets
sas_NPC <- full_join(doc_sub, ion_sub)

#select desired variables
sas_NPC <- subset(sas_NPC, select=c('date', 'stream_no', 'DOC_mmolm3', 'TN_mmolm3', 'flag'))

head(sas_NPC)

#merge all inflow datasets
inflow_chem <- full_join(lspa_stream_TP, TNTP_stream_CCC) %>% 
  full_join(., sas_NPC)

ggplot(inflow_chem, aes(x = date, y = TN_mmolm3, color = flag)) +
  geom_point()

ggplot(inflow_chem, aes(x = date, y = TP_mmolm3, color = flag)) +
  geom_point()

ggplot(inflow_chem, aes(x = date, y = DOC_mmolm3, color = flag)) +
  geom_point()

# write_csv(inflow_chem, paste0(dump.dir.streamchem, 'inflowchem_allstream_21Sept2020.csv'))


#### create matrices for bootstrapping ####
inflow_chem_doc_summary <- inflow_chem %>% 
  select(DOC_mmolm3, date, stream_no, flag) %>% 
  filter(!is.na(DOC_mmolm3)) %>% 
  group_by(date, stream_no) %>% 
  summarise(DOC_rep = length(DOC_mmolm3),
            DOC_mmolm3 = mean(DOC_mmolm3),
            DOC_flag = toString(flag, sep = ', '))

inflow_chem_tn_summary <- inflow_chem %>% 
  select(TN_mmolm3, date, stream_no, flag) %>% 
  filter(!is.na(TN_mmolm3)) %>% 
  group_by(date, stream_no) %>% 
  summarise(TN_rep = length(TN_mmolm3),
            TN_mmolm3 = mean(TN_mmolm3),
            TN_flag = toString(flag, sep = ', '))

inflow_chem_tp_summary <- inflow_chem %>% 
  select(TP_mmolm3, date, stream_no, flag) %>% 
  filter(!is.na(TP_mmolm3)) %>% 
  group_by(date, stream_no) %>% 
  summarise(TP_rep = length(TP_mmolm3),
            TP_mmolm3 = mean(TP_mmolm3),
            TP_flag = toString(flag, sep = ', '))

inflow_chem_summary <- full_join(inflow_chem_doc_summary, inflow_chem_tn_summary) %>% 
  full_join(., inflow_chem_tp_summary)

# write_csv(inflow_chem_summary, paste0(dump.dir.streamchem, 'inflowchem_onevalperday_21Sept2020.csv'))



#### ***** LAKE CHEMISTRY ******####
#  Finally, the last priority but no less important is the calibration data for the water quality variables.  
# These would be separate files for the LSPA's thermal and DO profiles over time, as well as historical TP, 
# chla, and Secchi data. These are not interpolated data; just what was observed the day it was measured. At 
# this point, we are interested solely in the data for the site closest to the buoy (I think 210) over time.  

#import station id
sun_id <- read_csv(paste0(LSPA.data.dir, 'raw data/sunapee station ids.csv'))

#create site description data frame
site=c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 100.1, 110, 200, 210, 220, 230)
maxdepth=c(11.8, 4.3, 10.8, NA, NA, 4.7, 6.4, NA, 7.3, NA, 7.7, 8.3, 19.5, 30.5, 25.6, 21.5)
sitetype=c('littoral', 'littoral', 'littoral', 'littoral', 'littoral', 'littoral', 'littoral', 'littoral', 'littoral', 'littoral', 'littoral', 'littoral', 'pelagic', 'pelagic', 'pelagic', 'pelagic')
site_descrip <- data.frame(site, maxdepth, sitetype)

# lspa data (LMP data base) #
LMP_bio <- read_csv(paste0(LSPA.data.dir, 'master files/lake_bio_1986-2019_v27Jul2020.csv')) 
LMP_chem <- read_csv(paste0(LSPA.data.dir, 'master files/lake_chem_1986-2019_v27Jul2020.csv'),
                     col_types = c('nDnccnc'))
LMP_do <- read_csv(paste0(LSPA.data.dir, 'master files/raw_do_1986-2019_v27Jul2020.csv'),
                   col_types = c('nDnccn'))
## all data attributable to LSPA ##

##LMP_bio data set
#subset for chla
LMP_chla <- LMP_bio %>% 
  filter(parameter == 'chla_ugl')
LMP_chla <- subset(LMP_chla, subset=!is.na(value))
LMP_chla$depth_m <- 0.1
LMP_chla$depth.measurement <- 'assumed'

#subseet for SD
LMP_SD <- LMP_bio %>% 
  filter(parameter == 'secchidepth_m')
LMP_SD <- subset(LMP_SD, subset=!is.na(value))

# write_csv(LMP_SD, paste0(dump.dir.calibration, 'secchi_1986-2019_v27Jul2020.csv'))

#determine missing depths by summarizing available data
layer_depth_LMP <- subset(LMP_chem, select=c('station', 'depth_m', 'layer'))
layer_depth_LMP <- subset(layer_depth_LMP, subset=!(is.na(depth_m) | layer == ' '))
layer_depth_summary <- layer_depth_LMP %>% 
  group_by(station, layer) %>% 
  summarise(mean_depth_m = mean(depth_m),
            median_depth_m = median(depth_m),
            count_depth = length(depth_m))
layer_depth_summary <- merge(layer_depth_summary, site_descrip, by.x='station', by.y='site', all=T)


#subset for litttoral sites and merge by location only (layer is irrelevant for this merge)
LMP_chem_l <- subset(LMP_chem, subset= station < 200)
LMP_chem_lm <- merge(LMP_chem_l, layer_depth_summary, by.x = c('station'), by.y=c('station'), all.x=T )
LMP_chem_lm$depth.measurement [!is.na(LMP_chem_lm$depth_m)] = 'actual'
LMP_chem_lm$depth.measurement [is.na(LMP_chem_lm$depth_m)] = 'mean'
ix=which(LMP_chem_lm$depth.measurement=='mean')
LMP_chem_lm$depth_m[ix] = LMP_chem_lm$mean_depth_m[ix]
LMP_chem_lm <- subset(LMP_chem_lm, select=c('station', 'date', 'depth_m', 'layer.x', 'parameter', 'value', 'sitetype', 'depth.measurement'))
LMP_chem_lm <- LMP_chem_lm %>% 
  rename(layer = layer.x)

#subset for pelagica and add depth details where na
LMP_chem_p <- subset(LMP_chem, subset= station >= 200)
LMP_chem_pm <- merge(LMP_chem_p, layer_depth_summary, by.x = c('station', 'layer'), by.y=c('station', 'layer'), all.x=T )
LMP_chem_pm$depth.measurement [!is.na(LMP_chem_pm$depth_m)] = 'actual'
LMP_chem_pm$depth.measurement [is.na(LMP_chem_pm$depth_m)] = 'median'
ix=which(LMP_chem_pm$depth.measurement=='median')
LMP_chem_pm$depth_m[ix] = LMP_chem_pm$median_depth_m[ix]
LMP_chem_pm <- subset(LMP_chem_pm, select=c('station', 'date', 'depth_m', 'layer', 'parameter', 'value', 'sitetype', 'depth.measurement'))
LMP_chem_pm <- subset(LMP_chem_pm, subset=!is.na(value))

LMP_chem_m <- merge(LMP_chem_lm, LMP_chem_pm, all=T)
LMP_chem_m$datasource <- 'LMP chem'


##LMP do data
LMP_do$depth.measurement <- 'actual'
LMP_do <- merge(LMP_do, site_descrip, by.x='station', by.y='site', all=T)
LMP_do <- subset(LMP_do, subset=!(is.na(value)))
LMP_do <- LMP_do %>% 
  select(-maxdepth)
LMP_do$datasource <- 'LMP DO'

# write_csv(LMP_do, paste0(dump.dir.calibration, 'LMP_lowresDOTemp_1986-2019_v28Sept2020.csv'))

#### woody lake data - from trophic reports ####
woody <- read_xlsx(paste0(LSPA.data.dir, 'raw data/from LSPA/Woody data.xlsx'))
woody <- woody %>% 
  rename(station = site)
woody$date <- as.Date(woody$date, format='%Y-%m-%d')

## chla ##
chla_woody <- subset(woody, subset=(parameter=='chla'))
chla_woody$depth.m = 0.1
chla_woody$depth.measurement <- 'assumed'
chla_woody$parameter <- 'chla_ugL'
chla_woody <- chla_woody %>% 
  select(-unit, -layer) %>% 
  mutate(datasource = 'trophic reports (Woody)')
str(chla_woody)
str(LMP_chla)
LMP_chla <- LMP_chla %>% 
  mutate(datasource = 'LMP bio')

chla <- full_join(chla_woody, LMP_chla) %>% 
  filter(date >= as.Date('1986-01-01')) %>% 
  filter(station != 222 & station != 225)

ggplot(chla, aes(x = date, y = value, color = flag)) +
  geom_point() +
  facet_grid(station ~ .)

# write_csv(chla, paste0(dump.dir.calibration, 'chlorophylla_1986-2019_v28Sept2020.csv'))

## secchi ##
secchi_woody <- subset(woody, subset=(parameter=='secchi'))
secchi_woody$parameter <- 'secchidepth_m'
secchi_woody <- secchi_woody %>% 
  select(-depth.m, -layer, -unit) %>% 
  mutate(datasource = 'trophic reports (Woody)')
str(secchi_woody)
str(LMP_SD)
LMP_SD <- LMP_SD %>% 
  mutate(datasource = 'LMP bio')

secchi <- full_join(secchi_woody, LMP_SD) %>% 
  filter(date >= as.Date('1986-01-01')) %>% 
  filter(station != 222 & station != 225)

ggplot(secchi, aes(x = date, y = value, color = flag)) +
  geom_point() +
  facet_grid(station ~ .)

# write_csv(secchi, paste0(dump.dir.calibration, 'secchi_1986-2019_v28Sept2020.csv'))

## do temp ##
dotemp_woody <- woody %>% 
  filter(parameter=='DO' | parameter == 'DO sat' | parameter == 'temp')

dotemp_woody$depth.measurement <- 'actual'

dotemp_woody <- dotemp_woody %>% 
  mutate(parameter = case_when(parameter == 'DO' ~ 'DO_mgl',
                               parameter == 'DO sat' ~ 'DO_pctsat',
                               parameter == 'temp' ~ 'temp_C',
                               TRUE ~ parameter)) %>% 
  select(-unit, - layer) %>% 
  rename(depth_m = depth.m) %>% 
  mutate(datasource = 'trophic reports (Woody)')
dotemp_woody <- merge(dotemp_woody, site_descrip, by.x = 'station', by.y = 'site') %>% 
  select(-maxdepth)

str(dotemp_woody)
str(LMP_do)

dotemp <- full_join(dotemp_woody, LMP_do) %>% 
  filter(date >= as.Date('1986-01-01')) %>% 
  filter(station != 222 & station != 225 & station != 999)
str(dotemp)

ggplot(dotemp, aes(x = date, y = value, color = flag)) +
  geom_point() +
  facet_grid(parameter ~ station, scales = 'free_y')


#chemistry ##
chem_woody <- woody %>% 
  filter(parameter=='pH' | parameter=='TP' | parameter=='PO4-P' |parameter=='Nitrate-N' |parameter=='Kjeld-N'|parameter=='Nitrite/Nitrate-N'|parameter=='TN') %>% 
  mutate(parameter = case_when(parameter == 'TP' ~ 'TP_mgl',
                               parameter == 'Kjeld-N' ~ 'TKN_mgl',
                               parameter == 'Nitrite/Nitrate-N' ~ 'TIN_mgl',
                               parameter == 'TN' ~ 'TN_mgl',
                               TRUE ~ parameter),
         value = case_when(parameter == 'PO4-P' ~ signif(value * 94.9714/30.973762, digits = 3), #convert from phosphate-p to phosphate
                           parameter == 'Nitrate-N' ~ signif(value * 62.0049/14.0067, digits = 3), #convert from nitrate-n to nitrate
                           parameter == 'pH' ~ 10^(-value),
                           TRUE ~ value), 
         parameter = case_when(parameter == 'PO4-P' ~ 'PO4_mgL',
                               parameter == 'Nitrate-N' ~ 'NO3_mgL',
                               parameter == 'pH' ~ 'H_M',
                               TRUE ~ parameter),
         depth.measurement = 'actual') %>% 
  select(-unit) %>% 
  rename(depth_m = depth.m) %>% 
  mutate(datasource = 'trophic reports (Woody)')
chem_woody <- merge(chem_woody, site_descrip, by.x = 'station', by.y = 'site') %>% 
  select(-maxdepth)

str(chem_woody)
str(LMP_chem_m)


chem <- full_join(chem_woody, LMP_chem_m)

# write_csv(chem, paste0(dump.dir.calibration, 'lake_chem_1986-2019_v29Sept2020.csv'))

