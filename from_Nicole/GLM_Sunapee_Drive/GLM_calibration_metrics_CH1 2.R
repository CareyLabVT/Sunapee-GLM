rm(list=ls())
library(glmtools)
library(GLMr)
library(hydroGOF)
library(dplyr)
library(lubridate)
library(ggplot2)
library(tidyr)
dev.off()



sim_folder<-"/Volumes/My Passport/GLM_manuscript/Simulations/Experiments_12June18_Phosphorus/GLM_Sunapee_10May18_initialcondTP0p5" ##!! Edit this line of
SimDir ="/Volumes/My Passport/GLM_manuscript/Simulations/Experiments_12June18_Phosphorus/GLM_Sunapee_10May18_initialcondTP0p5"
setwd("/Volumes/My Passport/GLM_manuscript/Simulations/Experiments_12June18_Phosphorus/GLM_Sunapee_10May18_initialcondTP0p5")
setwd(sim_folder)
nml_file<-paste0(sim_folder,"/glm2.nml")

#Read in the .nml file
nml<-read_nml(nml_file)
print(nml)

#################################
#### Run GLM model #####

run_glm(sim_folder,  verbose=TRUE)


SimFile = paste(SimDir,'/','output.nc',sep = '')
#!!! turned sed flux to dynamic, it then read SDF variables. turned off rsi, dic, maybe another
## delete this section###
field_stage = file.path(SimDir, 'field_stage_1982_2018.csv')
field_stage<-read.csv("field_stage_1982_2018.csv")
# jpeg(filename = "/Users/nicoleward/Downloads/transfer_from_frankenstein/outputs/stage_simobs.jpeg",width = 8,height = 4,
#      units = "in",res = 300)
plot_compare_stage(SimFile,field_stage, main="dots = observed")

Psedflux<-get_var(SimFile,var_name = "PHS_sed_frp") ##mmol/m**2/d
Psedflux$PHS_sed_frp<-Psedflux$PHS_sed_frp * 30.97 /1000000## convert to kg/m2/day
Psedflux$DateTime<-as.Date(Psedflux$DateTime)
Psedflux<-Psedflux[which(Psedflux$DateTime>"2004-12-31"),]
plot(Psedflux$DateTime,Psedflux$PHS_sed_frp)
write.csv(Psedflux,"GLM_Psedflux_kgm2d_2005_2018.csv",row.names = FALSE,quote = FALSE)
ice<-get_ice(SimFile,snow.rm = TRUE)
ice.snow<-get_ice(SimFile)
ice<-ice[which(ice$DateTime>"2007-08-26"),]
ice<-ice[which(ice$DateTime<"2009-01-15"),]
ice.snow<-ice.snow[which(ice.snow$DateTime>"2007-08-26"),]
ice.snow<-ice.snow[which(ice.snow$DateTime<"2009-01-15"),]
plot(ice$DateTime,ice$`ice(m)`)
plot(ice.snow$DateTime,ice.snow$`ice(m)`)
write_csv(ice,"GLM_ice")
# sedflux_model = 'Constant' !max ~3x10^-13

#  multi_ben = .false. !higher interannual variability max = 3.5x10^-13

#"multi_ben". According to the instruction of Louise Bruce change multi_ben
#flag to benthic_mode where false = 0 and true =1

0.0000000000015*16934251.6*60
########
#
####################### make manual only csv ###################################
# alltempdata<-read.csv("LMP_L1daily_temp_merge.csv")
#
# manualtemp<-alltempdata[which(alltempdata$loc==210),]
# depths2<-1
# depths<-(colnames(manualtemp))
# for(i in 3:(length(depths)-1)){
#   depths2[i-2]<-strsplit(depths,"_")[[i]][2]
# }
# depths<- rbind(0,0.1,0.5,1,1.5,1.9,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7,7.5,
# 8,8.3,85,8.7,9,9.17,9.5,10,10.5,11,11.5,12,12.5,13,13.5,14,14.5,15,
# 15.5,16,16.5,17,17.5,18,18.5,19,19.2,19.5,20,20.5,21,21.5,21.9,22,22.5,23,
# 23.5,24,24.5,25,25.5,26,26.5,27,27.5,28,28.5,29,29.5,30,31,32,33)
# depthschar<-as.data.frame(depths2)
# depthmatr<-cbind(depths,depthschar)
#
# # dailyMAXbuoyTemp<-mybuoyTemp%>%group_by(time)%>%summarise_each(funs(max))
# #
# #
# #
# #
# # datetime<-matrix(NA,nrow=(nrow(dailyMAXbuoyTemp)*(ncol(dailyMAXbuoyTemp)-1)))
# # depth_m<-matrix(NA,nrow=(nrow(dailyMAXbuoyTemp)*(ncol(dailyMAXbuoyTemp)-1)))
# # temp_buoy<-matrix(NA,nrow=(nrow(dailyMAXbuoyTemp)*(ncol(dailyMAXbuoyTemp)-1)))
# # x=1
# DateTime<-rep(NA,nrow(manualtemp)*(ncol(manualtemp)-4))
# Depth<-rep(NA,nrow(manualtemp)*(ncol(manualtemp)-4))
# Temp<-rep(NA,nrow(manualtemp)*(ncol(manualtemp)-4))
# x=1
# for(i in 1:nrow(manualtemp)){
#   for(j in 3:73){
#     in_dat<-as.character(manualtemp[i,1])
#     DateTime[x]<-in_dat
#     in_dep<-depthmatr[(j-2),1]
#     Depth[x]<-in_dep
#     in_temp<-manualtemp[i,j]
#     Temp[x]<-in_temp
#     x<-x+1
#   }
# }
#
# tr.manual_temp<-cbind(DateTime,Depth,Temp)
# tr.manual_temp<-as.data.frame(tr.manual_temp)
# tr.manual_temp$Temp<-as.numeric(as.character(tr.manual_temp$Temp))
# tr.manual_temp$Temp<-round(tr.manual_temp$Temp,digits = 2)
#
# write.csv(x = tr.manual_temp,"manual_temperature_210.csv",quote = FALSE,row.names = FALSE)

################### make buoy only csv###################
#
# buoyTemp<- file.path(sim_folder, 'L1_buoy_temp_hourlymean.csv') #define the observed field data
# mybuoyTemp = read.csv(buoyTemp)
# depths<-(colnames(mybuoyTemp))
#
# depths<- rbind(0,0.5,1,1.5,2,2.5,3,3.5,4,5,6,7,8,9,10,11,12,13,14)
#
#
# mybuoyTemp<-subset(mybuoyTemp,select=c("date", "Temp_0m_degC" ,  "Temp_0p5m_degC" ,"Temp_1m_degC"  , "Temp_1p5m_degC" ,"Temp_2m_degC" ,
#                                         "Temp_2p5m_degC", "Temp_3m_degC" ,  "Temp_3p5m_degC" ,"Temp_4m_degC" ,  "Temp_5m_degC"  ,
#                                         "Temp_6m_degC" ,  "Temp_7m_degC" ,  "Temp_8m_degC"  ,
#                                          "Temp_9m_degC"  , "Temp_10m_degC" , "Temp_11m_degC"  ,"Temp_12m_degC",  "Temp_13m_degC",  "Temp_14m_degC"))
#
# mybuoyTemp <-  mybuoyTemp %>%
#   mutate(time= as.POSIXct(date)) %>%
#   group_by(day=format(time, '%d'))
#
# mybuoyTemp<-subset(mybuoyTemp,select=c("time", "Temp_0m_degC" ,  "Temp_0p5m_degC" ,"Temp_1m_degC"  , "Temp_1p5m_degC" ,"Temp_2m_degC" ,
#                                        "Temp_2p5m_degC", "Temp_3m_degC" ,  "Temp_3p5m_degC" ,"Temp_4m_degC" ,  "Temp_5m_degC"  ,
#                                        "Temp_6m_degC" ,  "Temp_7m_degC" ,  "Temp_8m_degC"  ,
#                                        "Temp_9m_degC"  , "Temp_10m_degC" , "Temp_11m_degC"  ,"Temp_12m_degC",  "Temp_13m_degC",  "Temp_14m_degC"))
#
# dailyMAXbuoyTemp<-mybuoyTemp%>%group_by(time)%>%summarise_each(funs(max))
#
#
#
#
# datetime<-matrix(NA,nrow=(nrow(dailyMAXbuoyTemp)*(ncol(dailyMAXbuoyTemp)-1)))
# depth_m<-matrix(NA,nrow=(nrow(dailyMAXbuoyTemp)*(ncol(dailyMAXbuoyTemp)-1)))
# temp_buoy<-matrix(NA,nrow=(nrow(dailyMAXbuoyTemp)*(ncol(dailyMAXbuoyTemp)-1)))
# x=1
# for(i in 1:nrow(dailyMAXbuoyTemp)){
#   for(j in 2:20){
#     in_dat<-dailyMAXbuoyTemp[[1]][i]
#     datetime[x]<-as.character(in_dat)
#     in_dep<-depths[(j-1)]
#     depth_m[x]<-as.numeric(in_dep)
#     in_temp<-dailyMAXbuoyTemp[i,j]
#     temp_buoy[x]<-as.numeric(in_temp)
#     x<-x+1
#   }
# }
#
# colnames(datetime)[1] <- "DateTime"
# colnames(depth_m)[1]<-"Depth"
# colnames(temp_buoy)[1]<-"Temp"
# tr.buoy_temp<-cbind(datetime,depth_m,temp_buoy)
# tr.buoy_temp<-as.data.frame(tr.buoy_temp)
# tr.buoy_temp$Temp<-as.numeric(as.character(tr.buoy_temp$Temp))
# tr.buoy_temp$Temp<-round(tr.buoy_temp$Temp,digits = 2)
# write.csv(x = tr.buoy_temp,"buoy_dailymax_temperature.csv",quote = FALSE,row.names = FALSE)
############# read in buoy csv ##########
buoytemp<-read.csv("buoy_dailymax_temperature.csv")
buoytemp$DateTime<-as.POSIXct(buoytemp$DateTime)
hist(as.numeric(buoytemp$Depth))
###################### simfile convert simvar ################

SimFile = paste(SimDir,'/','output.nc',sep = '')
convert_sim_var(SimFile, DO = OXY_oxy * 32/1000, unit = 'mg/L',overwrite = T)
convert_sim_var(SimFile, TotP2 = TOT_tp * 30.97/1000, unit = 'mg/L',overwrite = T)
convert_sim_var(SimFile, TotN2 = TOT_tn * 14/1000, unit = 'mg/L',overwrite = T)
#### summer fall mechanism for PAPER ######
mv = get_var(SimFile,var_name = 'TotP2', z_out=0:6, reference = "surface") #g
a = mv %>% gather(key = 'depth',value = 'TotP2',TotP2_0:TotP2_6) %>% #changing from wide to long
  mutate(depth = gsub("TotP2_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)

epi.p<-  aggregate(as.numeric(as.character(a$TotP2)),
                        by=list(date=a$DateTime),
                        FUN=mean)
epi.p$date<-as.Date(epi.p$date)


mv2 = get_var(SimFile,var_name = 'TotP2', z_out=10:33, reference = "surface") #g
a2 = mv2 %>% gather(key = 'depth',value = 'TotP2',TotP2_10:TotP2_33) %>% #changing from wide to long
  mutate(depth = gsub("TotP2_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)
convert_sim_var(SimFile, POP = OGM_pop * 30.97/1000, unit = 'mg/L',overwrite = T)
convert_sim_var(SimFile, DOP = OGM_dop * 30.97/1000, unit = 'mg/L',overwrite = T)
convert_sim_var(SimFile, FRP = PHS_frp * 30.97/1000, unit = 'mg/L',overwrite = T)
convert_sim_var(SimFile, greensP = PHY_CHLOROPCH3_IP * 30.97/1000, unit = 'mg/L',overwrite = T)
mvPOP = get_var(SimFile,var_name = 'POP', z_out=10:33, reference = "surface") #g
aPOP = mvPOP %>% gather(key = 'depth',value = 'POP',POP_10:POP_33) %>% #changing from wide to long
  mutate(depth = gsub("POP_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)
mvGreensP = get_var(SimFile,var_name = 'greensP', z_out=10:33, reference = "surface") #g
aGreensP = mvGreensP %>% gather(key = 'depth',value = 'greensP',greensP_10:greensP_33) %>% #changing from wide to long
  mutate(depth = gsub("greensP_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)
mvDOP = get_var(SimFile,var_name = 'DOP', z_out=10:33, reference = "surface") #g
aDOP = mvDOP %>% gather(key = 'depth',value = 'DOP',DOP_10:DOP_33) %>% #changing from wide to long
  mutate(depth = gsub("DOP_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)
mvFRP = get_var(SimFile,var_name = 'FRP', z_out=10:33, reference = "surface") #g
aFRP = mvFRP %>% gather(key = 'depth',value = 'FRP',FRP_10:FRP_33) %>% #changing from wide to long
  mutate(depth = gsub("FRP_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)

hypo.p<-  aggregate(as.numeric(as.character(a2$TotP2)),
                   by=list(date=a2$DateTime),
                   FUN=mean)
hypo.p$date<-as.Date(hypo.p$date)

hypo.greensp<-  aggregate(as.numeric(as.character(aGreensP$greensP)),
                    by=list(date=aGreensP$DateTime),
                    FUN=mean)
hypo.greensp$date<-as.Date(hypo.greensp$date)

hypo.pop<-  aggregate(as.numeric(as.character(aPOP$POP)),
                      by=list(date=aPOP$DateTime),
                      FUN=mean)
hypo.pop$date<-as.Date(hypo.pop$date)
hypo.dop<-  aggregate(as.numeric(as.character(aDOP$DOP)),
                      by=list(date=aDOP$DateTime),
                      FUN=mean)
hypo.dop$date<-as.Date(hypo.dop$date)
hypo.frp<-  aggregate(as.numeric(as.character(aFRP$FRP)),
                      by=list(date=aFRP$DateTime),
                      FUN=mean)
hypo.frp$date<-as.Date(hypo.frp$date)

plot(epi.p$date,epi.p$x,lwd=2, cex=2,main="1993",type = "l",
     xlim = as.Date(c('1993-01-15','1993-12-15')),ylim=c(0,0.011),
     ylab = "TP mg/l")
lines(hypo.p$date,hypo.p$x, lwd=2,col="red",type = "l",
      xlim = as.Date(c('1993-01-15','1993-12-15')))
lines(hypo.pop$date,hypo.pop$x,col="blue", type = "l",lwd=2,
      xlim = as.Date(c('1993-01-15','1993-12-15')))
lines(hypo.dop$date,hypo.dop$x,col="darkgreen", type = "l",lwd=2,
      xlim = as.Date(c('1993-01-15','1993-12-15')))
lines(hypo.frp$date,hypo.frp$x,col="orange", type = "l",lwd=2,
      xlim = as.Date(c('1993-01-15','1993-12-15')))
lines(hypo.greensp$date,hypo.greensp$x,col="green", type = "l",lwd=2,lty=2,
      xlim = as.Date(c('1993-01-15','1993-12-15')))
legend("bottomleft",cex=1.5,
       legend=c("hypolimnion", "epilimnion"),
       lty=c(1,1), lwd=c(2,2), col=c("red", "black"),bty = "n",
       y.intersp = 0.75,
       x.intersp=0.1)
plot(epi.p$date,epi.p$x,main="1999",lwd=2, type = "l",ylim=c(0,0.015),
     xlim = as.Date(c('1999-01-15','1999-12-15')),
     ylab = "TP mg/l")
lines(hypo.p$date,hypo.p$x,col="red", type = "l",lwd=2,
      xlim = as.Date(c('1999-01-15','1999-12-15')))
lines(hypo.pop$date,hypo.pop$x,col="blue", type = "l",lwd=2,
      xlim = as.Date(c('1999-01-15','1999-12-15')))
lines(hypo.dop$date,hypo.dop$x,col="darkgreen", type = "l",lwd=2,
      xlim = as.Date(c('1999-01-15','1999-12-15')))
lines(hypo.frp$date,hypo.frp$x,col="orange", type = "l",lwd=2,
      xlim = as.Date(c('1999-01-15','1999-12-15')))
lines(hypo.greensp$date,hypo.greensp$x,col="green", type = "l",lwd=2,lty=2,
      xlim = as.Date(c('1999-01-15','1999-12-15')))
legend("topleft",xpd = TRUE,
       legend=c("TP hypolimnion", "TP epilimnion", "DOP hypo", "POP hypo","FRP hypo","P in greens"),
       lty=c(1,1,1,1,1,2), lwd=c(2,2,2,2,2,2),
       col=c("red", "black","darkgreen","blue","orange", "green"),bty = "n",
       y.intersp = 0.3,
       x.intersp=0.1)

ph= get_var(SimFile,var_name = 'PHY_TCHLA', z_out=0:3, reference = "surface") #g

ph$DateTime<-as.Date(ph$DateTime)
plot(ph$DateTime,ph$PHY_TCHLA_1, type = "l",xlim = as.Date(c('1993-01-15','1993-12-15')))
plot(ph$DateTime,ph$PHY_TCHLA_1, type = "l",xlim = as.Date(c('1999-01-15','1999-12-15')))


PHY_CYANONPCH2<-get_var(SimFile,var_name = 'PHY_CYANONPCH2',z_out=0.5,reference = 'surface')
PHY_CRYSOPCH1<-get_var(SimFile,var_name = 'PHY_CRYSOPCH1',z_out=0.5,reference = 'surface')
PHY_DIATOMPCH4<-get_var(SimFile,var_name = 'PHY_DIATOMPCH4',z_out=0.5,reference = 'surface')
PHY_CHLOROPCH3<-get_var(SimFile,var_name = 'PHY_CHLOROPCH3',z_out=0.5,reference = 'surface')
par(xpd=TRUE)
PHY_CHLOROPCH3$DateTime<-as.Date(PHY_CHLOROPCH3$DateTime)
PHY_CRYSOPCH1$DateTime<-as.Date(PHY_CRYSOPCH1$DateTime)
PHY_CYANONPCH2$DateTime<-as.Date(PHY_CYANONPCH2$DateTime)
PHY_DIATOMPCH4$DateTime<-as.Date(PHY_DIATOMPCH4$DateTime)

plot(PHY_CHLOROPCH3$DateTime,PHY_CHLOROPCH3$PHY_CHLOROPCH3_0.5,type="l",col="darkgreen",lwd=2,
     ylim=c(0,20),xlim = as.Date(c('1999-01-15','1999-12-15')),ylab = "phyto concentration (mmol/m3)",xlab="Date",cex.axis=1.5,cex.lab=1.5)
lines(PHY_DIATOMPCH4$DateTime,PHY_DIATOMPCH4$PHY_DIATOMPCH4_0.5,type="l",col="blue",lwd=2)
lines(PHY_CRYSOPCH1$DateTime,PHY_CRYSOPCH1$PHY_CRYSOPCH1_0.5,type="l",col="red",lwd=2)
lines(PHY_CYANONPCH2$DateTime,PHY_CYANONPCH2$PHY_CYANONPCH2_0.5,type="l",col="green",lwd=3)
legend("topleft",seg.len=0.3,cex=1.5,
       legend=c("Greens", "Diatoms","Crysophytes","N-fixing Cyanos"),
       lty=c(1,1,1,1), lwd=c(2,2,2,3), col=c("darkgreen", "blue", "red","green"),bty = "n",
       y.intersp = 0.5,
       x.intersp=0.1)
annual<-read.csv("annual_data.csv")
plot(annual$year,annual$mam.TP, type = "l")

totp<-get_var(SimFile,var_name = 'TOT_tp',z_out = 0.5,reference = 'bottom')
frp<-get_var(SimFile,var_name = 'PHS_frp',z_out = 0.5,reference = 'bottom')
pop<-get_var(SimFile,var_name = 'OGM_pop',z_out = 0.5,reference = 'bottom')
dop<-get_var(SimFile,var_name = 'OGM_dop',z_out = 0.5,reference = 'bottom')
plot(as.Date(totp$DateTime),totp$TOT_tp.elv_0.5,type='l',col='black',
     ylim=c(0,0.7),lwd=3,xlim=c(as.Date("1999-01-01"), as.Date("1999-12-31")))
lines(as.Date(frp$DateTime),frp$PHS_frp.elv_0.5,col='green',lwd=3)
lines(as.Date(pop$DateTime),pop$OGM_pop.elv_0.5,col='darkblue')
lines(as.Date(dop$DateTime),dop$OGM_dop.elv_0.5,col='cyan',lwd=3)
legend("top",legend = c("TP","frp","pop","dop"),ncol = 2,
       col = c("black","green","darkblue","cyan"),lwd = c(3,3,1,3),bty="n")

oxy<-get_var(SimFile,var_name = 'DO',z_out = 0.1,reference = 'bottom')
plot(as.Date(oxy$DateTime),oxy$DO.elv_0.1,type='l',col='black',
     ylim=c(0,15),lwd=3,xlim=c(as.Date("1999-01-01"), as.Date("1999-12-31")))

plot(as.Date(schmidt$datetime),schmidt$schmidt.stability,type="l",lwd=2,cex.axis=2,cex.lab=2,
     xlim=c(as.Date("1999-01-01"), as.Date("1999-12-31")))

## SCHMIDT STABILITY####
var_data <- get_var(SimFile, reference = 'surface', var_name = 'temp',z_out = 1:30) #*I think you would want to set z_out, but play around with this.
schmidt<- ts.schmidt.stability(wtr = var_data, bathy = get_hypsography(file = 'glm2.nml'), na.rm=FALSE)

### sub sample x axis heat map####
### GLM OUTPUT ###

source("plot_field_pub.R")
mv = get_var(SimFile,var_name = 'PHY_TCHLA', z_out=0:33) #get variable of choice

library(tidyverse)
a = mv %>% gather(key = 'depth',value = 'PHY_TCHLA',PHY_TCHLA.elv_0:PHY_TCHLA.elv_33) %>% #changing from wide to long
  mutate(depth = gsub("PHY_TCHLA.elv_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)

#plot_field(filename = a,var_name = 'TotP2',units = 'mg/L')  # example with no date limits
plot_field(filename = a,var_name = 'PHY_TCHLA',units = 'ug/L',
           xlims = as.Date(c('1993-08-15','1993-09-15')))

field_stage = file.path(SimDir, 'field_stage.csv')
# field_stage<-read.csv("field_stage.csv")
# jpeg(filename = "/Users/nicoleward/Downloads/transfer_from_frankenstein/outputs/stage_simobs.jpeg",width = 8,height = 4,
#      units = "in",res = 300)
plot_compare_stage(SimFile,field_stage, main="dots = observed")
# dev.off()

sw1evap<-get_evaporation(SimFile)
mean(sw1evap$`evaporation(mm/d)`)
### manual temp compare metrics#####
ManualTemp<- file.path(sim_folder, 'manual_temperature_210.csv') #define the observed field data
myTemp = read.csv(ManualTemp)
myTemp<-myTemp[complete.cases(myTemp),]
myTemp<-myTemp[which(as.numeric(myTemp$Depth)<14.1),]
manual.temp<-myTemp
tempTemp = paste(SimDir,'/','temp.csv',sep="")
write.csv(myTemp,file = tempTemp,row.names = FALSE, quote = FALSE)
myTempResampled = resample_to_field(SimFile,tempTemp, method = 'interp')

myTempResampled$DateTime<-as.character(myTempResampled$DateTime)
myTempResampled$DateTime<-as.POSIXct(as.character(myTempResampled$DateTime), format="%Y-%m-%d")
test <- strsplit(as.character(myTempResampled$DateTime), "-")
myTempResampled$year<-sapply(test, "[", 1)
myTempResampled<-myTempResampled[which(myTempResampled$year>1987),]

alldates<-myTempResampled
myTempResampled<-alldates
myTempResampled<-myTempResampled[complete.cases(myTempResampled),]
## just for calibration
calibration<-myTempResampled[which(myTempResampled$DateTime>"2004-12-31"),]
calibration<-calibration[which(calibration$DateTime<"2011-01-01"),]

y.1985to2005<-myTempResampled[which(myTempResampled$DateTime<"2005-01-01"),]
validation<-myTempResampled[which(myTempResampled$DateTime>"2010-12-31"),]
temp.lm<-lm(formula = Modeled_temp ~ Observed_temp,data = myTempResampled)
temp.cal.lm<-lm(formula = Modeled_temp ~ Observed_temp,data = calibration)
temp.sim.lm<-lm(formula = Modeled_temp ~ Observed_temp,data = y.1985to2005)
temp.val.lm<-lm(formula = Modeled_temp ~ Observed_temp,data = validation)
alltemp.rq<-summary(temp.lm)$r.squared
cal.rq<-summary(temp.cal.lm)$r.squared
val.rq<-summary(temp.val.lm)$r.squared
sim.rq<-summary(temp.sim.lm)$r.squared
surfacetemp<-myTempResampled[which(myTempResampled$Depth<6.1),]
cal.surfacetemp<-calibration[which(calibration$Depth<6.1),]
val.surfacetemp<-y.1985to2005[which(y.1985to2005$Depth<6.1),]
sur.lm<-lm(formula = Modeled_temp~Observed_temp,data = surfacetemp)
cal.sur.lm<-lm(formula = Modeled_temp~Observed_temp,data = cal.surfacetemp)
val.sur.lm<-lm(formula = Modeled_temp~Observed_temp,data = val.surfacetemp)
surface.rsq<-summary(sur.lm)$r.squared
cal.surface.rsq<-summary(cal.sur.lm)$r.squared
val.surface.rsq<-summary(val.sur.lm)$r.squared
metrics<-data.frame(matrix(nrow = 200,ncol = 20,data = NA))
##### GOF metrics##########
names(metrics)[names(metrics)=="X1"] <- "Variable"
names(metrics)[names(metrics)=="X2"] <- "r.squared"
names(metrics)[names(metrics)=="X3"] <- "n"
metrics$Variable[1]<-"alldates_temp_0to6m_manual"
metrics$r.squared[1]<-surface.rsq
metrics$n[1]<-nrow(surfacetemp)
metrics$Variable[2]<-"alldates_temp_0to14m_manual"
metrics$r.squared[2]<-alltemp.rq
metrics$n[2]<-nrow(myTempResampled)
metrics$Variable[3]<-"calibration_temp_0to6m_manual"
metrics$r.squared[3]<-cal.surface.rsq
metrics$n[3]<-nrow(cal.surfacetemp)
metrics$Variable[4]<-"calibration_temp_0to14_manual"
metrics$r.squared[4]<-cal.rq
metrics$n[4]<-nrow(calibration)
metrics$Variable[5]<-"validation_temp_0to6m_manual"
metrics$r.squared[5]<-val.surface.rsq
metrics$n[5]<-nrow(val.surfacetemp)
metrics$Variable[6]<-"validation_temp_allm_manual"
metrics$r.squared[6]<-val.rq
metrics$n[6]<-nrow(y.1985to2005)

# MAE gives equal weight to all errors, while RMSE gives extra weight to large errors
# (https://heuristically.wordpress.com/2013/07/12/calculate-rmse-and-mae-in-r-and-sas/)
GOFnums<-gof(sim = surfacetemp$Modeled_temp,obs = surfacetemp$Observed_temp)
#ggof(sim = surfacetemp$Modeled_temp,obs = surfacetemp$Observed_temp)
names(metrics)[names(metrics)=="X4"] <- "RMSE"
metrics$RMSE[1]<-GOFnums[4,1]
names(metrics)[names(metrics)=="X5"] <- "PBIAS"
metrics$PBIAS[1]<-GOFnums[6,1]
names(metrics)[names(metrics)=="X6"] <- "NSE"
metrics$NSE[1]<-GOFnums[9,1]
names(metrics)[names(metrics)=="X7"] <- "r"
metrics$r[1]<-GOFnums[16,1]
names(metrics)[names(metrics)=="X8"] <- "MAE"
metrics$MAE[1]<-GOFnums[2,1]

GOFnums<-gof(sim = myTempResampled$Modeled_temp,obs = myTempResampled$Observed_temp)
#ggof(sim = myTempResampled$Modeled_temp,obs = myTempResampled$Observed_temp)
metrics$RMSE[2]<-GOFnums[4,1]
metrics$PBIAS[2]<-GOFnums[6,1]
metrics$NSE[2]<-GOFnums[9,1]
metrics$r[2]<-GOFnums[16,1]
metrics$MAE[2]<-GOFnums[2,1]

GOFnums<-gof(sim = cal.surfacetemp$Modeled_temp,obs = cal.surfacetemp$Observed_temp)
#ggof(sim = cal.surfacetemp$Modeled_temp,obs = cal.surfacetemp$Observed_temp)
metrics$RMSE[3]<-GOFnums[4,1]
metrics$PBIAS[3]<-GOFnums[6,1]
metrics$NSE[3]<-GOFnums[9,1]
metrics$r[3]<-GOFnums[16,1]
metrics$MAE[3]<-GOFnums[2,1]

GOFnums<-gof(sim = calibration$Modeled_temp,obs = calibration$Observed_temp)
#ggof(sim = calibration$Modeled_temp,obs = calibration$Observed_temp)
metrics$RMSE[4]<-GOFnums[4,1]
metrics$PBIAS[4]<-GOFnums[6,1]
metrics$NSE[4]<-GOFnums[9,1]
metrics$r[4]<-GOFnums[16,1]
metrics$MAE[4]<-GOFnums[2,1]

GOFnums<-gof(sim = val.surfacetemp$Modeled_temp,obs = val.surfacetemp$Observed_temp)
#ggof(sim = val.surfacetemp$Modeled_temp,obs = val.surfacetemp$Observed_temp)
metrics$RMSE[5]<-GOFnums[4,1]
metrics$PBIAS[5]<-GOFnums[6,1]
metrics$NSE[5]<-GOFnums[9,1]
metrics$r[5]<-GOFnums[16,1]
metrics$MAE[5]<-GOFnums[2,1]


GOFnums<-gof(sim = validation$Modeled_temp,obs = validation$Observed_temp)
#ggof(sim = validation$Modeled_temp,obs = validation$Observed_temp)
metrics$RMSE[6]<-GOFnums[4,1]
metrics$PBIAS[6]<-GOFnums[6,1]
metrics$NSE[6]<-GOFnums[9,1]
metrics$r[6]<-GOFnums[16,1]
metrics$MAE[6]<-GOFnums[2,1]



#surface = 0-6m
mean.obs.dailytemp<-  aggregate(surfacetemp$Observed_temp, by=list(date=surfacetemp$DateTime),
                          FUN=mean)
mean.mod.dailytemp<-  aggregate(surfacetemp$Modeled_temp, by=list(date=surfacetemp$DateTime),
                                FUN=mean)

mean.mod.dailytemp$date<-as.Date(mean.mod.dailytemp$date)
mean.obs.dailytemp$date<-as.Date(mean.obs.dailytemp$date)

names(mean.mod.dailytemp)[names(mean.mod.dailytemp)=="x"] <- "modeled"
names(mean.obs.dailytemp)[names(mean.obs.dailytemp)=="x"] <- "observed"
mean.mod.dailytemp$modeled<-as.numeric(mean.mod.dailytemp$modeled)
mean.obs.dailytemp$observed<-as.numeric(mean.obs.dailytemp$observed)
epi<-left_join(mean.mod.dailytemp,mean.obs.dailytemp)

#jpeg(filename = "/Users/nicoleward/Downloads/transfer_from_frankenstein/outputs/epi_dailymeantemp_GGOF.jpeg",width = 10,height = 10,
#     units = "in",res = 500)
#ggof(sim = epi$modeled,obs = epi$observed)
#dev.off()

metrics$Variable[7]<-"alldates_temp_0to6mmean_manual"
GOFnums<-gof(sim = epi$modeled,obs = epi$observed)
metrics$RMSE[7]<-GOFnums[4,1]
metrics$PBIAS[7]<-GOFnums[6,1]
metrics$NSE[7]<-GOFnums[9,1]
metrics$r[7]<-GOFnums[16,1]
metrics$r.squared[7]<-GOFnums[17,1]
metrics$MAE[7]<-GOFnums[2,1]
temp.epimean.lm<-lm(formula = modeled ~ observed,data = epi)
allepimean.rq<-summary(temp.epimean.lm)$r.squared
metrics$r.squared[7]<-allepimean.rq
metrics$n[7]<-nrow(epi)


cal.epi.mean<-epi[which(epi$date>"2004-12-31"),]
cal.epi.mean<-cal.epi.mean[which(cal.epi.mean$date<"2011-01-01"),]
#ggof(sim = cal.epi.mean$modeled,obs = cal.epi.mean$observed)
GOFnums<-gof(sim = cal.epi.mean$modeled,obs = cal.epi.mean$observed)
metrics$Variable[8]<-"cal_temp_0to6mmean_manual"
cal.epimean.lm<-lm(formula = modeled ~ observed,data = cal.epi.mean)
calepimean.rq<-summary(cal.epimean.lm)$r.squared
metrics$r.squared[8]<-calepimean.rq
metrics$n[8]<-nrow(cal.epi.mean)
metrics$RMSE[8]<-GOFnums[4,1]
metrics$PBIAS[8]<-GOFnums[6,1]
metrics$NSE[8]<-GOFnums[9,1]
metrics$r[8]<-GOFnums[16,1]
metrics$r.squared[8]<-GOFnums[17,1]
metrics$MAE[8]<-GOFnums[2,1]

val.epi.mean<-epi[which(epi$date>"2010-12-31"),]

#ggof(sim = val.epi.mean$modeled,obs = val.epi.mean$observed)

metrics$Variable[9]<-"val_temp_0to6mmean_manual"
temp.valepimean.lm<-lm(formula = modeled ~ observed,data = val.epi.mean)
valepimean.rq<-summary(temp.valepimean.lm)$r.squared
metrics$r.squared[9]<-valepimean.rq
metrics$n[9]<-nrow(val.epi.mean)
GOFnums<-gof(sim = val.epi.mean$modeled,obs = val.epi.mean$observed)
metrics$RMSE[9]<-GOFnums[4,1]
metrics$PBIAS[9]<-GOFnums[6,1]
metrics$NSE[9]<-GOFnums[9,1]
metrics$r[9]<-GOFnums[16,1]
metrics$MAE[9]<-GOFnums[2,1]

##  buoy temp data compare #####
buoytemp<-read.csv("buoy_dailymax_temperature.csv")
buoytemp$DateTime<-as.POSIXct(buoytemp$DateTime)
buoytemp[buoytemp < 0.01] <- 0.01
myTemp = buoytemp
myTemp<-myTemp[complete.cases(myTemp),]
myTemp<-myTemp[which(myTemp$Depth<14.1),]
#myTemp<-myTemp[which(myTemp$Depth==1),]
sat<-get_var(SimFile,var_name = "OXY_sat",z_out = 1,reference = "surface")
sat<-sat[which(sat$DateTime>"2007-01-01"),]
sat<-sat[which(sat$DateTime<"2009-01-01"),]

tempTemp = paste(SimDir,'/','temp.csv',sep="")
write.csv(myTemp,file = tempTemp,row.names = FALSE, quote = FALSE)
myTempResampled = resample_to_field(SimFile,tempTemp, method = 'interp')
plot_temp_compare(SimFile,myTemp)

### run for Figures####
modtemp<-get_temp(SimFile,reference = "surface",z_out = c(0.1,1,2,3,4,5,6))
datetime<-rep(NA,nrow(modtemp)*(ncol(modtemp)-1))
depth_m<-rep(NA,nrow(modtemp)*(ncol(modtemp)-1))
temp<-rep(NA,nrow(modtemp)*(ncol(modtemp)-1))
depthmatr<-c(0.1,1,2,3,4,5,6)
x=1
for(i in 1:nrow(modtemp)){
  for(j in 2:8){
    in_dat<-as.character(modtemp[i,1])
    datetime[x]<-in_dat
    in_dep<-depthmatr[j-1]
    depth_m[x]<-in_dep
    in_temp<-modtemp[i,j]
    temp[x]<-in_temp
    x<-x+1
  }
}
tr.temp<-cbind(datetime,depth_m,temp)
tr.temp<-as.data.frame(tr.temp)
tr.temp$depth_m<-as.numeric(as.character(tr.temp$depth_m))
tr.temp$temp<-as.numeric(as.character(tr.temp$temp))

mean.mod.dailytemp<-  aggregate(tr.temp$temp, by=list(tr.temp$datetime),
                                FUN=mean)
names(mean.mod.dailytemp)[names(mean.mod.dailytemp)==c("Group.1","x")] <- c("date","temp")
mean.mod.dailytemp$date<-as.Date(mean.mod.dailytemp$date)
select.mod.temp<-mean.mod.dailytemp[which(as.character(mean.mod.dailytemp$date)>"2004-12-31"),]
select.mod.temp<-select.mod.temp[which(as.character(select.mod.temp$date)<"2014-01-01"),]
#########################################
myTempResampled$DateTime<-as.character(myTempResampled$DateTime)
myTempResampled$DateTime<-as.POSIXct(as.character(myTempResampled$DateTime), format="%Y-%m-%d")
test <- strsplit(as.character(myTempResampled$DateTime), "-")
myTempResampled$year<-sapply(test, "[", 1)

alldates<-myTempResampled
myTempResampled<-alldates
myTempResampled<-myTempResampled[complete.cases(myTempResampled),]
## just for calibration
calibration<-myTempResampled[which(myTempResampled$DateTime>"2004-12-31"),]
calibration<-calibration[which(calibration$DateTime<"2011-01-01"),]

validation<-myTempResampled[which(myTempResampled$DateTime>"2010-12-31"),]
temp.lm<-lm(formula = Modeled_temp ~ Observed_temp,data = myTempResampled)
temp.cal.lm<-lm(formula = Modeled_temp ~ Observed_temp,data = calibration)
#temp.sim.lm<-lm(formula = Modeled_temp ~ Observed_temp,data = y.1985to2005)
temp.val.lm<-lm(formula = Modeled_temp ~ Observed_temp,data = validation)
alltemp.rq<-summary(temp.lm)$r.squared
cal.rq<-summary(temp.cal.lm)$r.squared
val.rq<-summary(temp.val.lm)$r.squared
sim.rq<-summary(temp.sim.lm)$r.squared
surfacetemp<-myTempResampled[which(myTempResampled$Depth<6.1),]
cal.surfacetemp<-calibration[which(calibration$Depth<6.1),]
val.surfacetemp<-validation[which(validation$Depth<6.1),]
manual.surface<-manual.temp[which(manual.temp$Depth<6.1),]
sur.lm<-lm(formula = Modeled_temp~Observed_temp,data = surfacetemp)
cal.sur.lm<-lm(formula = Modeled_temp~Observed_temp,data = cal.surfacetemp)
val.sur.lm<-lm(formula = Modeled_temp~Observed_temp,data = val.surfacetemp)
surface.rsq<-summary(sur.lm)$r.squared
cal.surface.rsq<-summary(cal.sur.lm)$r.squared
val.surface.rsq<-summary(val.sur.lm)$r.squared

#### GOF METRICS buoy########
metrics$Variable[10]<-"alldates_temp_0to6m_buoy"
metrics$r.squared[10]<-surface.rsq
metrics$n[10]<-nrow(surfacetemp)
metrics$Variable[11]<-"alldates_temp_0to14m_buoy"
metrics$r.squared[11]<-alltemp.rq
metrics$n[11]<-nrow(myTempResampled)
metrics$Variable[12]<-"calibration_temp_0to6m_buoy"
metrics$r.squared[12]<-cal.surface.rsq
metrics$n[12]<-nrow(cal.surfacetemp)
metrics$Variable[13]<-"calibration_temp_0to14_buoy"
metrics$r.squared[13]<-cal.rq
metrics$n[13]<-nrow(calibration)
metrics$Variable[14]<-"validation_temp_0to6m_buoy"
metrics$r.squared[14]<-val.surface.rsq
metrics$n[14]<-nrow(val.surfacetemp)
metrics$Variable[15]<-"validation_temp_0to14_buoy"
metrics$r.squared[15]<-val.rq
metrics$n[15]<-nrow(validation)

# MAE gives equal weight to all errors, while RMSE gives extra weight to large errors
# (https://heuristically.wordpress.com/2013/07/12/calculate-rmse-and-mae-in-r-and-sas/)


GOFnums<-gof(sim = surfacetemp$Modeled_temp,obs = surfacetemp$Observed_temp)
ggof(sim = surfacetemp$Modeled_temp,obs = surfacetemp$Observed_temp)
metrics$RMSE[10]<-GOFnums[4,1]
metrics$PBIAS[10]<-GOFnums[6,1]
metrics$NSE[10]<-GOFnums[9,1]
metrics$r[10]<-GOFnums[16,1]
metrics$MAE[10]<-GOFnums[2,1]

GOFnums<-gof(sim = myTempResampled$Modeled_temp,obs = myTempResampled$Observed_temp)
ggof(sim = myTempResampled$Modeled_temp,obs = myTempResampled$Observed_temp)
metrics$RMSE[11]<-GOFnums[4,1]
metrics$PBIAS[11]<-GOFnums[6,1]
metrics$NSE[11]<-GOFnums[9,1]
metrics$r[11]<-GOFnums[16,1]
metrics$MAE[11]<-GOFnums[2,1]

GOFnums<-gof(sim = cal.surfacetemp$Modeled_temp,obs = cal.surfacetemp$Observed_temp)
ggof(sim = cal.surfacetemp$Modeled_temp,obs = cal.surfacetemp$Observed_temp)
metrics$RMSE[12]<-GOFnums[4,1]
metrics$PBIAS[12]<-GOFnums[6,1]
metrics$NSE[12]<-GOFnums[9,1]
metrics$r[12]<-GOFnums[16,1]
metrics$MAE[12]<-GOFnums[2,1]

GOFnums<-gof(sim = calibration$Modeled_temp,obs = calibration$Observed_temp)
ggof(sim = calibration$Modeled_temp,obs = calibration$Observed_temp)
metrics$RMSE[13]<-GOFnums[4,1]
metrics$PBIAS[13]<-GOFnums[6,1]
metrics$NSE[13]<-GOFnums[9,1]
metrics$r[13]<-GOFnums[16,1]
metrics$MAE[13]<-GOFnums[2,1]

GOFnums<-gof(sim = val.surfacetemp$Modeled_temp,obs = val.surfacetemp$Observed_temp)
ggof(sim = val.surfacetemp$Modeled_temp,obs = val.surfacetemp$Observed_temp)
metrics$RMSE[14]<-GOFnums[4,1]
metrics$PBIAS[14]<-GOFnums[6,1]
metrics$NSE[14]<-GOFnums[9,1]
metrics$r[14]<-GOFnums[16,1]
metrics$MAE[14]<-GOFnums[2,1]

GOFnums<-gof(sim = validation$Modeled_temp,obs = validation$Observed_temp)
ggof(sim = validation$Modeled_temp,obs = validation$Observed_temp)
metrics$RMSE[15]<-GOFnums[4,1]
metrics$PBIAS[15]<-GOFnums[6,1]
metrics$NSE[15]<-GOFnums[9,1]
metrics$r[15]<-GOFnums[16,1]
metrics$MAE[15]<-GOFnums[2,1]



#surface = 0-6m
mean.obs.dailytemp<-  aggregate(surfacetemp$Observed_temp, by=list(date=surfacetemp$DateTime),
                                FUN=mean)
mean.mod.dailytemp<-  aggregate(surfacetemp$Modeled_temp, by=list(date=surfacetemp$DateTime),
                                FUN=mean)

mean.mod.dailytemp$date<-as.Date(mean.mod.dailytemp$date)

mean.obs.dailytemp$date<-as.Date(mean.obs.dailytemp$date)

mean.manual.dailytemp<-  aggregate(manual.surface$Temp, by=list(date=manual.surface$DateTime),
                                FUN=mean)

mean.manual.dailytemp$date<-as.Date(mean.manual.dailytemp$date)

names(mean.mod.dailytemp)[names(mean.mod.dailytemp)=="x"] <- "modeled"
names(mean.obs.dailytemp)[names(mean.obs.dailytemp)=="x"] <- "observed"
mean.mod.dailytemp$modeled<-as.numeric(mean.mod.dailytemp$modeled)
mean.obs.dailytemp$observed<-as.numeric(mean.obs.dailytemp$observed)
epi<-left_join(mean.mod.dailytemp,mean.obs.dailytemp)
epi.cal<-epi[which(epi$date<"2010-01-01"),]
epi.val<-epi[which(epi$date>"2009-12-31"),]
epi.cal.manual<-mean.manual.dailytemp[which(as.character(mean.manual.dailytemp$date)>"2004-12-31"),]
epi.cal.manual<-epi.cal.manual[which(as.character(epi.cal.manual$date)<"2010-01-01"),]
epi.val.manual<-mean.manual.dailytemp[which(as.character(mean.manual.dailytemp$date)>"2010-01-01"),]
epi.cal.manual$date<-as.Date(epi.cal.manual$date)
epi.cal.all<-left_join(epi.cal.manual,select.mod.temp)
epi.val.manual$date<-as.Date(epi.val.manual$date)
epi.val.all<-left_join(epi.val.manual,select.mod.temp)
####### run for figures########
names(mean.manual.dailytemp)[names(mean.manual.dailytemp)==c("date","x")] <- c("date","Manual")
names(select.mod.temp)[names(select.mod.temp)==c("date","temp")] <- c("date","Simulated")

buoy.temp<-subset(epi,select = c("date","observed"))
names(buoy.temp)[names(buoy.temp)==c("date","observed")] <- c("date","Buoy")

df.fig1<-left_join(select.mod.temp,mean.manual.dailytemp)
df.fig1<-left_join(df.fig1,buoy.temp)
library(reshape2)
df.fig1.melt<- melt(df.fig1, id = "date")
##### FIGURE 1A. cal/val temperature ################
plot(select.mod.temp$date,select.mod.temp$Simulated,type="l",cex.lab=1.4,ylim=c(0,30),
     lwd=3,xlab="",ylab = "Temperature (Degrees C)",cex.axis=1.7)
points(epi$date,epi$observed,pch=21,bg="steelblue1",
       col="mediumblue",
       cex=1.6)
points(epi.cal.manual$date,epi.cal.manual$x,pch=21,lwd=2,bg="grey88",
       col="blue1",
       cex=1.6)
points(epi.val.manual$date,epi.val.manual$x,pch=21,col="blue1",
       bg="grey88",lwd=2,
       cex=1.6)
lines(select.mod.temp$date,select.mod.temp$temp,lwd=3)
legend("topleft",legend=c("Manual Measurement",
                          "Buoy Measurement","Simulated"),y.intersp = 0.4,
       pch=c(21,21,NA),lty=c(NA,NA,1),lwd=c(NA,NA,3),
       pt.cex=c(1.6,1.6,NA),bty="n",cex = 1.5,x.intersp = 0.2,
       pt.bg=c("grey88","dimgrey",NA),
       col=c("dimgrey","black","black"))

###########Figure 1A presentation mode#################
plot(select.mod.temp$date,select.mod.temp$temp,type="l",cex.lab=1.4,ylim=c(0,30),
     lwd=3,xlab="",ylab = "Temperature (Degrees C)",cex.axis=1.7)
points(epi$date,epi$observed,pch=21,bg="steelblue1",
       col="mediumblue",
       cex=1.6)
points(epi.cal.manual$date,epi.cal.manual$x,pch=21,lwd=2,bg="grey88",
       col="blue1",
       cex=1.6)
points(epi.val.manual$date,epi.val.manual$x,pch=21,col="blue1",
       bg="grey88",lwd=2,
       cex=1.6)
lines(select.mod.temp$date,select.mod.temp$temp,lwd=3)
legend("topleft",legend=c("Manual Measurement",
                          "Buoy Measurement","Simulated"),y.intersp = 0.4,
       pch=c(21,21,NA),lty=c(NA,NA,1),lwd=c(NA,NA,3),
       pt.cex=c(1.6,1.6,NA),bty="n",cex = 1.5,x.intersp = 0.2,
       pt.bg=c("grey88","dimgrey",NA),
       col=c("dimgrey","black","black"))

#### ggplot version ####
df.fig1.melt$variable<- factor(df.fig1.melt$variable,
                               levels = c("Manual","Buoy","Simulated"))

p<-ggplot(subset(df.fig1.melt,variable %in% c("Simulated")),
          aes(x = date, y = value, group = variable, colour = variable,
              shape = variable, fill = variable)) +
  geom_line(aes(date,value, group=variable, colour=variable),size=1.5,show.legend = FALSE)+
  geom_point(data=subset(df.fig1.melt,variable %in% c("Buoy")),
                    aes(date,value, group=variable, colour=variable),
             fill="steelblue4",shape=21,size=4.5,show.legend=FALSE)+#
  geom_point(data=subset(df.fig1.melt,variable %in% c("Manual")),
             aes(date,value, group=variable, colour=variable),
             fill="grey88",shape=21,size=4.5,show.legend=FALSE)+#
  geom_line(aes(date,value, group=variable, colour=variable),size=1,show.legend=FALSE)+
    theme_minimal()
p+  scale_color_manual(values=c("mediumblue","blue1","black"))+
  theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text=element_text(size=24),
          axis.title=element_text(size=24),
          legend.text=element_text(size=22),
          legend.title=element_blank())+
    labs(x="",y=expression(paste('Temperature (',~degree,'C)',sep='')))
 ###### try
p<-ggplot() +
  geom_point(data=subset(df.fig1.melt,variable %in% c("Buoy","Manual")),
             aes(date,value, group=variable, colour=variable,fill=variable),
             shape=21,size=4.5)+#shape=21,
  geom_line(data=subset(df.fig1.melt,variable %in% c("Simulated")),
             aes(date,value, group=variable, colour=variable,linetype=variable))+
  theme_minimal()
p+  scale_color_manual(values=c("red","blue1","black"),breaks=c("Simulated"))+
  scale_fill_manual(values=c("grey88","green"),breaks=c("Buoy","Manual"))+
  breaks=c("Buoy","Manual")+
  scale_shape_manual(values=c(21,21,.))+
  scale_linetype_manual(values=c(NA, NA,"Solid"),breaks=c("Simulated")) +# Change linetypes

  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"),
        axis.text=element_text(size=24),
        axis.title=element_text(size=24),
        legend.text=element_text(size=22),
        legend.title=element_blank())+
  labs(x="",y=expression(paste('Temperature (',~degree,'C)',sep='')))
##### sim v obs ####
plot(epi.cal$observed,epi.cal$modeled,pch=21,bg="steelblue1",
     col="mediumblue",ylab="Simulated",
     xlab = "Observed",cex.axis=1.8,cex.lab=1.4,
     cex=1.6,xlim=c(0,27),ylim=c(0,27))
points(epi.val$observed,epi.val$modeled,pch=21,
       bg="indianred2",col="darkred",
       cex=1.6)
points(epi.cal.all$x,epi.cal.all$temp,pch=21,lwd=2,bg="grey88",
       col="blue1",
       cex=1.6)
points(epi.val.all$x,epi.val.all$temp,pch=21,col="darkred",
       bg="mistyrose",lwd=2,
       cex=1.6)
legend("topleft",legend=c("Calibration - compare to manual",
                          "Calibration - compare to buoy",
                          "Validation - compare to manual",
                          "Validation - compare to buoy"),
       pch=c(21,21,21,21),pt.cex=c(1.6,1.6,1.6,1.6),bty="n",
       pt.bg=c("grey88","steelblue1","mistyrose","indianred2"),
       col=c("blue1","mediumblue","darkred","darkred"))

jpeg(filename = "/Users/nicoleward/Downloads/transfer_from_frankenstein/outputs/epi_dailymeantemp_GGOF.jpeg",width = 10,height = 10,
     units = "in",res = 500)
ggof(sim = epi$modeled,obs = epi$observed)
dev.off()

metrics$Variable[16]<-"alldates_temp_0to6mmean_buoy"
GOFnums<-gof(sim = epi$modeled,obs = epi$observed)
metrics$RMSE[16]<-GOFnums[4,1]
metrics$PBIAS[16]<-GOFnums[6,1]
metrics$NSE[16]<-GOFnums[9,1]
metrics$r[16]<-GOFnums[16,1]
metrics$r.squared[16]<-GOFnums[17,1]
metrics$MAE[16]<-GOFnums[2,1]
temp.epimean.lm<-lm(formula = modeled ~ observed,data = epi)
allepimean.rq<-summary(temp.epimean.lm)$r.squared
metrics$r.squared[16]<-allepimean.rq
metrics$n[16]<-nrow(epi)


cal.epi.mean<-epi[which(epi$date>"2004-12-31"),]
cal.epi.mean<-cal.epi.mean[which(cal.epi.mean$date<"2011-01-01"),]
ggof(sim = cal.epi.mean$modeled,obs = cal.epi.mean$observed)
GOFnums<-gof(sim = cal.epi.mean$modeled,obs = cal.epi.mean$observed)
metrics$Variable[17]<-"cal_temp_0to6mmean_buoy"
cal.epimean.lm<-lm(formula = modeled ~ observed,data = cal.epi.mean)
calepimean.rq<-summary(cal.epimean.lm)$r.squared
metrics$r.squared[17]<-calepimean.rq
metrics$n[17]<-nrow(cal.epi.mean)
metrics$RMSE[17]<-GOFnums[4,1]
metrics$PBIAS[17]<-GOFnums[6,1]
metrics$NSE[17]<-GOFnums[9,1]
metrics$r[17]<-GOFnums[16,1]
metrics$r.squared[17]<-GOFnums[17,1]
metrics$MAE[17]<-GOFnums[2,1]

val.epi.mean<-epi[which(epi$date>"2010-12-31"),]

ggof(sim = val.epi.mean$modeled,obs = val.epi.mean$observed)

metrics$Variable[18]<-"val_temp_0to6mmean_buoy"
temp.valepimean.lm<-lm(formula = modeled ~ observed,data = val.epi.mean)
valepimean.rq<-summary(temp.valepimean.lm)$r.squared
metrics$r.squared[18]<-valepimean.rq
metrics$n[18]<-nrow(val.epi.mean)
GOFnums<-gof(sim = val.epi.mean$modeled,obs = val.epi.mean$observed)
metrics$RMSE[18]<-GOFnums[4,1]
metrics$PBIAS[18]<-GOFnums[6,1]
metrics$NSE[18]<-GOFnums[9,1]
metrics$r[18]<-GOFnums[16,1]
metrics$MAE[18]<-GOFnums[2,1]

write.csv(metrics,"calvalMetrics.csv",row.names = FALSE,quote = FALSE)

#### manual DO compare metrics ####

ObsFileNutrients = "/Users/nicoleward/Documents/VirginiaTech/Manuscripts/SunapeeGLM/transfer_from_frankenstein/GLM_run/do_profile_210.csv"

myDO = read.csv(ObsFileNutrients)

myDO$datetime<-as.POSIXct(myDO$DATE)
myDO.1m = myDO[which(myDO$DEPTH==1.0),]
mean.manual.DO1m<-  aggregate(myDO.1m$DO, by=list(date=myDO.1m$datetime),
                                FUN=mean)
names(mean.manual.DO1m)[names(mean.manual.DO1m)==c("date","x")] <- c("DateTime","DO")
mean.manual.DO1m$Depth<-1
#myTemp<-myTemp[complete.cases(myTemp),]
#myTemp<-myTemp[which(myTemp$depth<14.1),]

tempTemp = paste(SimDir,'/','temp.csv',sep="")
write.csv(mean.manual.DO1m,file = tempTemp,row.names = FALSE, quote = FALSE)
myTempResampled = resample_to_field(SimFile,tempTemp, method = 'interp',var_name = "DO") #cannot use bc requires "temp"?

modtemp<-get_var(SimFile,reference = "surface",z_out = 1,var_name = "DO")

modtemp$DateTime<-as.Date(modtemp$DateTime)
select.mod.DO<-modtemp[which(as.character(modtemp$DateTime)>"2004-12-31"),]
select.mod.DO<-select.mod.DO[which(as.character(select.mod.DO$DateTime)<"2014-01-01"),]




myTempResampled$DateTime<-as.character(myTempResampled$DateTime)
myTempResampled$DateTime<-as.POSIXct(as.character(myTempResampled$DateTime), format="%Y-%m-%d")
test <- strsplit(as.character(myTempResampled$DateTime), "-")
myTempResampled$year<-sapply(test, "[", 1)

alldates<-myTempResampled
myTempResampled<-alldates
myTempResampled<-myTempResampled[complete.cases(myTempResampled),]
## just for calibration
calibration<-myTempResampled[which(myTempResampled$DateTime>"2004-12-31"),]
calibration<-calibration[which(calibration$DateTime<"2011-01-01"),]
y.1985to2005<-myTempResampled
validation<-myTempResampled[which(myTempResampled$DateTime>"2010-12-31"),]
temp.lm<-lm(formula = Modeled_DO ~ Observed_DO,data = myTempResampled)
temp.cal.lm<-lm(formula = Modeled_DO ~ Observed_DO,data = calibration)
temp.sim.lm<-lm(formula = Modeled_DO ~ Observed_DO,data = y.1985to2005)
temp.val.lm<-lm(formula = Modeled_DO ~ Observed_DO,data = validation)
alltemp.rq<-summary(temp.lm)$r.squared
cal.rq<-summary(temp.cal.lm)$r.squared
val.rq<-summary(temp.val.lm)$r.squared
sim.rq<-summary(temp.sim.lm)$r.squared


metrics$Variable[19]<-"alldates_DO_1m_manual"
metrics$r.squared[19]<-alltemp.rq
metrics$n[19]<-nrow(myTempResampled)
metrics$Variable[20]<-"calibration_DO_1m_manual"
metrics$r.squared[20]<-cal.rq
metrics$n[20]<-nrow(calibration)
metrics$Variable[21]<-"validation_DO_1m_manual"
metrics$r.squared[21]<-val.rq
metrics$n[21]<-nrow(validation)

# MAE gives equal weight to all errors, while RMSE gives extra weight to large errors
# (https://heuristically.wordpress.com/2013/07/12/calculate-rmse-and-mae-in-r-and-sas/)


GOFnums<-gof(sim = myTempResampled$Modeled_DO,obs = myTempResampled$Observed_DO)
ggof(sim = myTempResampled$Modeled_DO,obs = myTempResampled$Observed_DO)
metrics$RMSE[19]<-GOFnums[4,1]
metrics$PBIAS[19]<-GOFnums[6,1]
metrics$NSE[19]<-GOFnums[9,1]
metrics$r[19]<-GOFnums[16,1]
metrics$MAE[19]<-GOFnums[2,1]


GOFnums<-gof(sim = calibration$Modeled_DO,obs = calibration$Observed_DO)
ggof(sim = calibration$Modeled_DO,obs = calibration$Observed_DO)
metrics$RMSE[20]<-GOFnums[4,1]
metrics$PBIAS[20]<-GOFnums[6,1]
metrics$NSE[20]<-GOFnums[9,1]
metrics$r[20]<-GOFnums[16,1]
metrics$MAE[20]<-GOFnums[2,1]

GOFnums<-gof(sim = validation$Modeled_DO,obs = validation$Observed_DO)
ggof(sim = validation$Modeled_DO,obs = validation$Observed_DO)
metrics$RMSE[21]<-GOFnums[4,1]
metrics$PBIAS[21]<-GOFnums[6,1]
metrics$NSE[21]<-GOFnums[9,1]
metrics$r[21]<-GOFnums[16,1]
metrics$MAE[21]<-GOFnums[2,1]




## add DO buoy data compare #####
ObsFileNutrients = "/Users/nicoleward/Documents/VirginiaTech/Manuscripts/SunapeeGLM/transfer_from_frankenstein/GLM_run/buoy_do_1m.csv"

myDO = read.csv(ObsFileNutrients)

myDO$DateTime<-as.POSIXct(myDO$DateTime)
myTemp = myDO
names(myTemp)[names(myTemp)==c("DateTime","DO_mgL_1m")] <- c("DateTime","DO")
test <- strsplit(as.character(myTemp$DateTime), " ")
myTemp$DateTime<-sapply(test, "[", 1)
max.buoy.DO1m<-  aggregate(myTemp$DO, by=list(date=myTemp$DateTime),
                              FUN=mean)
names(max.buoy.DO1m)[names(max.buoy.DO1m)==c("date","x")] <- c("DateTime","DO")
max.buoy.DO1m$Depth<-1

tempTemp = paste(SimDir,'/','temp.csv',sep="")
write.csv(max.buoy.DO1m,file = tempTemp,row.names = FALSE, quote = FALSE)
myTempResampled = resample_to_field(SimFile,tempTemp, method = 'interp',var_name = "DO") #cannot use bc requires "temp"?

myTempResampled$DateTime<-as.character(myTempResampled$DateTime)
myTempResampled$DateTime<-as.POSIXct(as.character(myTempResampled$DateTime), format="%Y-%m-%d")
test <- strsplit(as.character(myTempResampled$DateTime), "-")
myTempResampled$year<-sapply(test, "[", 1)

names(max.buoy.DO1m)[names(max.buoy.DO1m)==c("DateTime","DO","Depth")] <- c("DateTime","Buoy","Depth")
max.buoy.DO1m$Buoy<-as.numeric(as.character(max.buoy.DO1m$Buoy))
select.mod.DO$DateTime<-as.character(select.mod.DO$DateTime)
select.mod.DO$DateTime<-as.POSIXct(as.character(select.mod.DO$DateTime), format="%Y-%m-%d")
max.buoy.DO1m$DateTime<-as.character(max.buoy.DO1m$DateTime)
max.buoy.DO1m$DateTime<-as.POSIXct(as.character(max.buoy.DO1m$DateTime), format="%Y-%m-%d")
epi<-left_join(select.mod.DO,max.buoy.DO1m)
epi.cal<-epi[which(epi$DateTime<"2010-01-01"),]
epi.val<-epi[which(epi$DateTime>"2009-12-31"),]
epi.cal.manual<-mean.manual.DO1m[which(as.character(mean.manual.DO1m$DateTime)>"2004-12-31"),]
epi.cal.manual<-epi.cal.manual[which(as.character(epi.cal.manual$DateTime)<"2010-01-01"),]
epi.val.manual<-mean.manual.DO1m[which(as.character(mean.manual.DO1m$DateTime)>"2010-01-01"),]
epi.cal.all<-left_join(epi.cal.manual,select.mod.DO)
epi.val.all<-left_join(epi.val.manual,select.mod.DO)


### FIGURE 1B DO compare #####
plot(select.mod.DO$DateTime,select.mod.DO$DO_1,type="l",cex.lab=1.4,ylim=c(6,20),
     lwd=3,xlab="",ylab = "Dissolved Oxygen (mg/L)",cex.axis=1.7)
points(epi.cal$DateTime,epi.cal$Buoy,pch=21,bg="steelblue1",
       col="mediumblue",
       cex=1.6)
points(epi.val$DateTime,epi.val$Buoy,pch=21,
       bg="steelblue1",col="mediumblue",
       cex=1.6)
points(epi.cal.manual$DateTime,epi.cal.manual$DO,pch=21,lwd=2,bg="grey88",
       col="blue1",
       cex=1.6)
points(epi.val.manual$DateTime,epi.val.manual$DO,pch=21,col="blue1",
       bg="grey88",lwd=2,
       cex=1.6)
lines(select.mod.DO$DateTime,select.mod.DO$DO_1,lwd=3)
legend("topleft",legend=c("Manual Measurement",
                          "Buoy Measurement","Simulated"),y.intersp = 0.4,
       pch=c(21,21,NA),lty=c(NA,NA,1),lwd=c(NA,NA,3),
       pt.cex=c(1.6,1.6,NA),bty="n",cex = 1.5,x.intersp = 0.2,
       pt.bg=c("grey88","steelblue1",NA),
       col=c("blue1","mediumblue","black"))
plot(select.mod.DO$DateTime,select.mod.DO$DO_1,type="l",cex.lab=1.4,ylim=c(6,16),
     lwd=3,xlab="",ylab = "Dissolved Oxygen (mg/L)",cex.axis=1.7)
points(epi.cal$DateTime,epi.cal$Buoy,pch=21,bg="steelblue1",
       col="mediumblue",
       cex=1.6)
points(epi.val$DateTime,epi.val$Buoy,pch=21,
       bg="steelblue1",col="mediumblue",
       cex=1.6)
points(epi.cal.manual$DateTime,epi.cal.manual$DO,pch=21,lwd=2,bg="grey88",
       col="blue1",
       cex=1.6)
points(epi.val.manual$DateTime,epi.val.manual$DO,pch=21,col="blue1",
       bg="grey88",lwd=2,
       cex=1.6)
lines(select.mod.DO$DateTime,select.mod.DO$DO_1,lwd=3)

plot(epi.cal$Buoy,epi.cal$Modeled,pch=21,bg="steelblue1",
     col="mediumblue",ylab="Simulated",ylim=c(6.5,15),
     xlab = "Observed",cex.axis=1.8,cex.lab=1.4,
     cex=1.6,xlim=c(6.5,15))
points(epi.val$Buoy,epi.val$Modeled,pch=21,
       bg="indianred2",col="darkred",
       cex=1.6)
points(epi.cal.all$DO,epi.cal.all$Modeled,pch=21,lwd=2,bg="grey88",
       col="blue1",
       cex=1.6)
points(epi.val.all$DO,epi.val.all$Modeled,pch=21,col="darkred",
       bg="mistyrose",lwd=2,
       cex=1.6)
legend("topleft",legend=c("Calibration - compare to manual",
                          "Calibration - compare to buoy",
                          "Validation - compare to manual",
                          "Validation - compare to buoy"),
       pch=c(21,21,21,21),pt.cex=c(1.6,1.6,1.6,1.6),bty="n",
       pt.bg=c("grey88","steelblue1","mistyrose","indianred2"),
       col=c("blue1","mediumblue","darkred","darkred"))





alldates<-myTempResampled
myTempResampled<-alldates
myTempResampled<-myTempResampled[complete.cases(myTempResampled),]
## just for calibration
calibration<-myTempResampled[which(myTempResampled$DateTime>"2004-12-31"),]
calibration<-calibration[which(calibration$DateTime<"2011-01-01"),]
y.1985to2005<-myTempResampled
validation<-myTempResampled[which(myTempResampled$DateTime>"2010-12-31"),]
temp.lm<-lm(formula = Modeled_DO ~ Observed_DO,data = myTempResampled)
temp.cal.lm<-lm(formula = Modeled_DO ~ Observed_DO,data = calibration)
temp.sim.lm<-lm(formula = Modeled_DO ~ Observed_DO,data = y.1985to2005)
temp.val.lm<-lm(formula = Modeled_DO ~ Observed_DO,data = validation)
alltemp.rq<-summary(temp.lm)$r.squared
cal.rq<-summary(temp.cal.lm)$r.squared
val.rq<-summary(temp.val.lm)$r.squared
sim.rq<-summary(temp.sim.lm)$r.squared


metrics$Variable[22]<-"alldates_DO_1m_buoy"
metrics$r.squared[22]<-alltemp.rq
metrics$n[22]<-nrow(myTempResampled)
metrics$Variable[23]<-"calibration_DO_1m_buoy"
metrics$r.squared[23]<-cal.rq
metrics$n[23]<-nrow(calibration)
metrics$Variable[24]<-"validation_DO_1m_buoy"
metrics$r.squared[24]<-val.rq
metrics$n[24]<-nrow(validation)

# MAE gives equal weight to all errors, while RMSE gives extra weight to large errors
# (https://heuristically.wordpress.com/2013/07/12/calculate-rmse-and-mae-in-r-and-sas/)


GOFnums<-gof(sim = myTempResampled$Modeled_DO,obs = myTempResampled$Observed_DO)
ggof(sim = myTempResampled$Modeled_DO,obs = myTempResampled$Observed_DO)
metrics$RMSE[22]<-GOFnums[4,1]
metrics$PBIAS[22]<-GOFnums[6,1]
metrics$NSE[22]<-GOFnums[9,1]
metrics$r[22]<-GOFnums[16,1]
metrics$MAE[22]<-GOFnums[2,1]

GOFnums<-gof(sim = calibration$Modeled_DO,obs = calibration$Observed_DO)
ggof(sim = calibration$Modeled_DO,obs = calibration$Observed_DO)
metrics$RMSE[23]<-GOFnums[4,1]
metrics$PBIAS[23]<-GOFnums[6,1]
metrics$NSE[23]<-GOFnums[9,1]
metrics$r[23]<-GOFnums[16,1]
metrics$MAE[23]<-GOFnums[2,1]


GOFnums<-gof(sim = validation$Modeled_DO,obs = validation$Observed_DO)
ggof(sim = validation$Modeled_DO,obs = validation$Observed_DO)
metrics$RMSE[24]<-GOFnums[4,1]
metrics$PBIAS[24]<-GOFnums[6,1]
metrics$NSE[24]<-GOFnums[9,1]
metrics$r[24]<-GOFnums[16,1]
metrics$MAE[24]<-GOFnums[2,1]



#### manual TP compare metrics #####
ObsFileNutrients = "/Users/nicoleward/Documents/VirginiaTech/Manuscripts/SunapeeGLM/transfer_from_frankenstein/GLM_run/limnol_buoydeep_to2013_05Jan2017.csv"

myNutrients = read.csv(ObsFileNutrients)
myTP = myNutrients %>% filter(variable == "TP_mgL") %>%
  dplyr::select(datetime = date,depth=depth.m, TP = value)
myTP$datetime<-as.POSIXct(myTP$datetime,format="%Y-%m-%d")
TPdepths<-unique(myTP$depth)
TP<-get_var(SimFile,var_name='TotP2',z_out = TPdepths,reference = 'surface')

myTemp = myTP

myTemp<-myTemp[complete.cases(myTemp),]
colnames(myTemp)<- c("DateTime","Depth","TotP2")
tempTemp = paste(SimDir,'/','temp.csv',sep="")
write.csv(myTemp,file = tempTemp,row.names = FALSE, quote = FALSE)
myTempResampled = resample_to_field(SimFile,tempTemp, method = 'interp',var_name = "TotP2")
plot(myTempResampled$DateTime,myTempResampled$Observed_TotP2)
lines(myTempResampled$DateTime,myTempResampled$Modeled_TotP2, col="red")
ggof(sim = myTempResampled$Modeled_TotP2,obs = myTempResampled$Observed_TotP2)
#### manual TN compare metrics #####

myTIN = myNutrients %>% filter(variable == "TKN_mgL") %>%
  dplyr::select(datetime = date,depth=depth.m, TN = value)
myTIN$datetime<-as.POSIXct(myTIN$datetime,format="%Y-%m-%d")
## there are so few!?!

# TNdepths<-unique(myTN$depth)
# TN<-get_var(SimFile,var_name='TotN',z_out = TPdepths,reference = 'surface')

myTemp = myTIN

myTemp<-myTemp[complete.cases(myTemp),]
colnames(myTemp)<- c("DateTime","Depth","TotN2")
tempTemp = paste(SimDir,'/','temp.csv',sep="")
write.csv(myTemp,file = tempTemp,row.names = FALSE, quote = FALSE)
myTempResampled = resample_to_field(SimFile,tempTemp, method = 'interp',var_name = "TotN2")
plot(myTempResampled$DateTime,myTempResampled$Observed_TotP2)
lines(myTempResampled$DateTime,myTempResampled$Modeled_TotP2, col="red")
#### tp plot for gleon ####
plot(basecorrs$year,basecorrs$TPload.kg)
plot(basecorrs$year,basecorrs$mam.TPload.kg,
     ylab = "Total Annual Phosphorus Load (kg/yr)",cex.lab=1.5,cex.axis=2,
     xlab = "",cex=2,pch=16,col="darkorange3")
tpmod<-lm(TPload.kg~year,data = basecorrs)

#### GOF chla ####
mv = get_var(SimFile,var_name = 'PHY_TCHLA', z_out=0:3, reference = "surface") #g

library(tidyr)
a = mv %>% gather(key = 'depth',value = 'PHY_TCHLA',PHY_TCHLA_0:PHY_TCHLA_3) %>% #changing from wide to long
  mutate(depth = gsub("PHY_TCHLA_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)

sur.chla<-  aggregate(as.numeric(as.character(a$PHY_TCHLA)),
                      by=list(date=a$DateTime),
                      FUN=mean)
CHLa<-sur.chla
CHLa$date<-as.Date(CHLa$date)
myCHLa = myNutrients %>% filter(variable == "chla_ugL") %>%
  dplyr::select(datetime = date,depth=depth.m, CHLa = value)
myCHLa$datetime<-as.POSIXct(myCHLa$datetime,format="%Y-%m-%d")
myCHLa$datetime<-as.Date(as.character(myCHLa$datetime))
myCHLa<-myCHLa[which(myCHLa$datetime>"2004-12-31"),]
myCHLa<-myCHLa[which(myCHLa$CHLa<8),]
CHLa<-CHLa[which(CHLa$date>"2004-12-31"),]
CHLa<-CHLa[which(CHLa$date<"2013-12-31"),]
#### FIGURE 1C CHLA ######
par(mar=c(4,5, 5, 1))
plot(CHLa$DateTime,CHLa$PHY_TCHLA_0.1, type="l",ylim=c(0,6),col="seagreen",
     lwd=3,xlab="Year",cex.axis=1.75,ylab="Chlorophyll-a (μg/L)",cex.lab=1.75)
points(myCHLa$datetime,myCHLa$CHLa,cex=2,col="darkgreen",
       pch=21,
       bg="lightgreen")
legend(x=as.Date("2007-01-01"),y=8,legend=c("Manual Measurement",
                          "Simulated"),y.intersp = 0.4,xpd=TRUE,
       pch=c(21,NA),lty=c(NA,1),lwd=c(NA,3),seg.len=c(1,1),
       pt.cex=c(1.6,NA),bty="n",cex = 1.5,x.intersp = 0.2,
       pt.bg=c("lightgreen",NA),
       col=c("darkgreen","seagreen"))
#lines(myCHLa$datetime,myCHLa$CHLa,lty=2)
par(mfrow=c(1,1),oma=c(2,2,2,4),mar=c(4,5,2,2))
plot(CHLa$DateTime,CHLa$PHY_TCHLA_0.1, type="l",ylim=c(0,8),col="seagreen",
     lwd=3,xlab="Year",cex.axis=1.75,ylab="Chlorophyll-a (μg/L)",cex.lab=1.75)
points(myCHLa$datetime,myCHLa$CHLa,cex=2,col="darkgreen",
       pch=21,
       bg="lightgreen")

CHLa$DateTime<-as.character(CHLa$DateTime)
CHLa$DateTime<-as.POSIXct(as.character(CHLa$DateTime), format="%Y-%m-%d")
test <- strsplit(as.character(CHLa$date), "-")
CHLa$year<-sapply(test, "[", 1)
CHLa$month<-sapply(test, "[", 2)
jjaChla<-CHLa[which(as.numeric(CHLa$month)>5),]
jjaChla<-jjaChla[which(as.numeric(jjaChla$month)<9),]
summerCHLa<-  aggregate(jjaChla$x, by=list(year=jjaChla$year),
                                FUN=mean)
colnames(summerCHLa)<- c("Year","modeled.chla.mean.jja")

myCHLa$datetime<-as.character(myCHLa$datetime)
myCHLa$datetime<-as.POSIXct(as.character(myCHLa$datetime), format="%Y-%m-%d")
test <- strsplit(as.character(myCHLa$datetime), "-")
myCHLa$year<-sapply(test, "[", 1)
myCHLa$month<-sapply(test, "[", 2)
myjjaChla<-myCHLa[which(as.numeric(myCHLa$month)>5),]
myjjaChla<-myjjaChla[which(as.numeric(myjjaChla$month)<9),]
myjjaChla<-myjjaChla[which(as.numeric(myjjaChla$year)>1991),]
obs.summerchla<-aggregate(myjjaChla$CHLa, by=list(year=myjjaChla$year),
                          FUN=mean)
colnames(obs.summerchla)<- c("Year","obs.chla.mean.jja")
jjaChlacompare<-left_join(obs.summerchla,summerCHLa)
jjaChlacompare<-jjaChlacompare[complete.cases(jjaChlacompare),]
plot(jjaChlacompare$Year,jjaChlacompare$obs.chla.mean.jja)
lines(jjaChlacompare$Year,jjaChlacompare$modeled.chla.mean.jja,col="red")

GOFnums<-gof(sim = jjaChlacompare$modeled.chla.mean.jja,obs = jjaChlacompare$obs.chla.mean.jja)
ggof(sim = jjaChlacompare$modeled.chla.mean.jja,obs = jjaChlacompare$obs.chla.mean.jja)



jjaChlacompare<-jjaChlacompare[complete.cases(jjaChlacompare),]
## just for calibration
calibration<-jjaChlacompare[which(jjaChlacompare$Year>"2004"),]
calibration<-calibration[which(calibration$Year<"2011"),]
y.1985to2005<-jjaChlacompare
validation<-jjaChlacompare[which(jjaChlacompare$Year>"2010"),]
temp.lm<-lm(formula = modeled.chla.mean.jja ~ obs.chla.mean.jja,data = jjaChlacompare)
temp.cal.lm<-lm(formula = modeled.chla.mean.jja ~ obs.chla.mean.jja,data = calibration)
temp.sim.lm<-lm(formula = modeled.chla.mean.jja ~ obs.chla.mean.jja,data = y.1985to2005)
temp.val.lm<-lm(formula = modeled.chla.mean.jja ~ obs.chla.mean.jja,data = validation)
alltemp.rq<-summary(temp.lm)$r.squared
cal.rq<-summary(temp.cal.lm)$r.squared
val.rq<-summary(temp.val.lm)$r.squared
sim.rq<-summary(temp.sim.lm)$r.squared


metrics$Variable[25]<-"alldates_Chla"
metrics$r.squared[25]<-alltemp.rq
metrics$n[25]<-nrow(jjaChlacompare)
metrics$Variable[26]<-"calibration_Chla"
metrics$r.squared[26]<-cal.rq
metrics$n[26]<-nrow(calibration)
metrics$Variable[27]<-"validation_chla"
metrics$r.squared[27]<-val.rq
metrics$n[27]<-nrow(validation)

### sept chla metrics ####
CHLa$date<-as.character(CHLa$date)
CHLa$date<-as.POSIXct(as.character(CHLa$date), format="%Y-%m-%d")
test <- strsplit(as.character(CHLa$date), "-")
CHLa$year<-sapply(test, "[", 1)
CHLa$month<-sapply(test, "[", 2)
jjasChla<-CHLa[which(as.numeric(CHLa$month)>5),]
jjasChla<-jjasChla[which(as.numeric(jjasChla$month)<10),]
SsummerCHLa<-  aggregate(jjasChla$x, by=list(year=jjasChla$year),
                        FUN=mean)
colnames(SsummerCHLa)<- c("Year","modeled.chla.mean.jja")

myCHLa$datetime<-as.character(myCHLa$datetime)
myCHLa$datetime<-as.POSIXct(as.character(myCHLa$datetime), format="%Y-%m-%d")
test <- strsplit(as.character(myCHLa$datetime), "-")
myCHLa$year<-sapply(test, "[", 1)
myCHLa$month<-sapply(test, "[", 2)
myjjasChla<-myCHLa[which(as.numeric(myCHLa$month)>5),]
myjjasChla<-myjjasChla[which(as.numeric(myjjasChla$month)<9),]
myjjasChla<-myjjasChla[which(as.numeric(myjjasChla$year)>1991),]
obs.Ssummerchla<-aggregate(myjjasChla$CHLa, by=list(year=myjjasChla$year),
                          FUN=mean)
colnames(obs.Ssummerchla)<- c("Year","obs.chla.mean.jja")
jjasChlacompare<-left_join(obs.Ssummerchla,SsummerCHLa)
jjasChlacompare<-jjasChlacompare[complete.cases(jjasChlacompare),]
plot(jjasChlacompare$Year,jjasChlacompare$obs.chla.mean.jja)
lines(jjasChlacompare$Year,jjasChlacompare$modeled.chla.mean.jja,col="red")

GOFnums<-gof(sim = jjasChlacompare$modeled.chla.mean.jja,obs = jjasChlacompare$obs.chla.mean.jja)
ggof(sim = jjasChlacompare$modeled.chla.mean.jja,obs = jjasChlacompare$obs.chla.mean.jja)



jjasChlacompare<-jjasChlacompare[complete.cases(jjasChlacompare),]
## just for calibration
calibration<-jjasChlacompare[which(jjasChlacompare$Year>"2004"),]
calibration<-calibration[which(calibration$Year<"2011"),]
y.1985to2005<-jjasChlacompare
validation<-jjasChlacompare[which(jjasChlacompare$Year>"2010"),]
temp.lm<-lm(formula = modeled.chla.mean.jja ~ obs.chla.mean.jja,data = jjasChlacompare)
temp.cal.lm<-lm(formula = modeled.chla.mean.jja ~ obs.chla.mean.jja,data = calibration)
temp.sim.lm<-lm(formula = modeled.chla.mean.jja ~ obs.chla.mean.jja,data = y.1985to2005)
temp.val.lm<-lm(formula = modeled.chla.mean.jja ~ obs.chla.mean.jja,data = validation)
alltemp.rq<-summary(temp.lm)$r.squared
cal.rq<-summary(temp.cal.lm)$r.squared
val.rq<-summary(temp.val.lm)$r.squared
sim.rq<-summary(temp.sim.lm)$r.squared


metrics$Variable[28]<-"alldates_ChlaJJAS"
metrics$r.squared[28]<-alltemp.rq
metrics$n[28]<-nrow(jjasChlacompare)
metrics$Variable[29]<-"calibration_ChlaJJAS"
metrics$r.squared[29]<-cal.rq
metrics$n[29]<-nrow(calibration)
metrics$Variable[30]<-"validation_chlaJJAS"
metrics$r.squared[30]<-val.rq
metrics$n[30]<-nrow(validation)

GOFnums<-gof(sim = calibration$modeled.chla.mean.jja,obs = calibration$obs.chla.mean.jja)

metrics$RMSE[29]<-GOFnums[4,1]
metrics$PBIAS[29]<-GOFnums[6,1]
metrics$NSE[29]<-GOFnums[9,1]
metrics$r[29]<-GOFnums[16,1]
metrics$MAE[29]<-GOFnums[2,1]

GOFnums<-gof(sim = validation$modeled.chla.mean.jja,obs = validation$obs.chla.mean.jja)

metrics$RMSE[30]<-GOFnums[4,1]
metrics$PBIAS[30]<-GOFnums[6,1]
metrics$NSE[30]<-GOFnums[9,1]
metrics$r[30]<-GOFnums[16,1]
metrics$MAE[30]<-GOFnums[2,1]
## summer mean

write.csv(metrics,"calvalMetrics.csv",row.names = FALSE,quote = FALSE)

### FIGURE 2A. jun-jul-aug versus sept chla #######

jjaChla<-CHLa[which(as.numeric(CHLa$month)>5),]
jjaChla<-jjasChla[which(as.numeric(jjasChla$month)<9),]

sepChla<-CHLa[which(as.numeric(CHLa$month)==9),]

sep.annual.mean<-aggregate(sepChla$PHY_TCHLA_0.1, by=list(year=sepChla$year),
                           FUN=mean)
jja.annual.mean<-aggregate(jjaChla$PHY_TCHLA_0.1, by=list(year=jjaChla$year),
                           FUN=mean)

sepMax<-max(sep.annual.mean$x)
jjaMax<-max(jja.annual.mean$x)

sep.annual.mean$prop.of.sept<-sep.annual.mean$x/sepMax
jja.annual.mean$prop.of.jja<-jja.annual.mean$x/jjaMax


jja.mean.prop<-subset(jja.annual.mean,select = c("year","prop.of.jja"))
sep.mean.prop<-subset(sep.annual.mean,select=c("year","prop.of.sept"))

data<-left_join(sep.mean.prop,jja.mean.prop)
library(reshape)
mdata<-melt(data,id.vars = "year")

# Load ggplot2.
library(ggplot2)
p<-ggplot(data=mdata,
       aes(x=year, y=value,fill=variable)) + geom_bar(stat="identity",
                                                      position=position_dodge())+
  scale_fill_manual(values=c("springgreen4","palegreen"),
                    labels=c("Summer Chla", "Sept Chla"))+
  theme_minimal()
p+scale_color_manual(values=c("gray52","deepskyblue2","sandybrown"))+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"),
        axis.text=element_text(size=22),
        axis.title=element_text(size=22),
        legend.text=element_text(size=20),
        legend.title=element_blank())+
  scale_y_continuous(expand = c(0,0),limits = c(0,1.05)) +
  scale_x_discrete(breaks=c(1990, 2000, 2010), labels=c("1990","2000", "2010"))+
  labs(x = "",y=expression(paste("Relative to Max Value")))

# plot everything
ggplot(data, aes(Names, value)) +
  geom_bar(aes(fill = variable), position = "dodge", stat="identity")

yrly.data<-read.csv(file = "annual_data.csv",header=TRUE)


##### FIGURE 2B #######
data <- read.csv("annual_data.csv",header=TRUE)
sepMax<-max(data$mean.sep.T)
jjaMax<-max(data$mean.jja.T)
TPMax<-max(data$mam.TP)

data$prop.of.sept<-data$mean.sep.T/sepMax
data$prop.of.jja<-data$mean.jja.T/jjaMax
data$prop.of.tp<-data$mam.TP/TPMax

df.driver<-subset(data,select=c("year","prop.of.sept","prop.of.jja","prop.of.tp"))
mdriver<-melt(df.driver,id.vars = "year")
mdriver$year<-as.character(mdriver$year)
p<-ggplot(data=mdriver,
       aes(x=year, y=value,fill=variable)) + geom_bar(stat="identity",
                                                      position=position_dodge())+
  scale_fill_manual(values=c("skyblue","slateblue3","darkorange3"),
                    labels=c("Sept Temp", "Summer Temp", "Spring TP"))+
  theme_minimal()
p+scale_color_manual(values=c("gray52","deepskyblue2","sandybrown"))+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"),
        axis.text=element_text(size=22),
        axis.title=element_text(size=22),
        legend.text=element_text(size=20),
        legend.title=element_blank())+
  scale_y_continuous(expand = c(0,0),limits = c(0,1.05)) +
  scale_x_discrete(breaks=c(1990, 2000, 2010), labels=c("1990","2000", "2010"))+
  labs(x="",y=expression(paste("Relative to Max Value")))

# plot everything
ggplot(data, aes(Names, value)) +
  geom_bar(aes(fill = variable), position = "dodge", stat="identity")




###### 30 yr correlations#######

MetData<-read.csv("SunapeeMet_1979_2016.csv", header=TRUE)


MetData$time<-as.character(MetData$time)
MetData$time<-as.POSIXct(as.character(MetData$time), format="%Y-%m-%d %H:%M:%S")
test <- strsplit(as.character(MetData$time), "-")
MetData$year<-sapply(test, "[", 1)
MetData$month<-sapply(test, "[", 2)
MetData$month<-as.numeric(as.character(MetData$month))
myData<-na.omit(MetData)
myData$Rain_m_hr<-myData$Rain/24
annual_precip<-aggregate(Rain_m_hr~year,myData,sum)
annualmean_temp<-aggregate(AirTemp~year,myData,mean)
annualmin_temp<-aggregate(AirTemp~year,myData,min)
annualmax_temp<-aggregate(AirTemp~year,myData,max)
metdatasub<-myData[which(myData$month>5),]
metdatasub<-metdatasub[which(metdatasub$month<9),]
summermean_temp<-aggregate(AirTemp~year,metdatasub,mean)
metdatasept<-myData[which(myData$month>8),]
metdatasept<-metdatasept[which(metdatasept$month<10),]
septmean_temp<-aggregate(AirTemp~year,metdatasept,mean)
septmax_temp<-aggregate(AirTemp~year,metdatasept,max)


myData.mam<-myData[which(myData$month>2),]
myData.mam<-myData.mam[which(myData.mam$month<6),]
mam.precip<-  aggregate(as.numeric(as.character(myData.mam$Rain_m_hr)),
                              by=list(year=myData.mam$year),
                              FUN=sum)

myData.jja<-myData[which(myData$month>5),]
myData.jja<-myData.jja[which(myData.jja$month<9),]
jja.precip<-  aggregate(as.numeric(as.character(myData.jja$Rain_m_hr)),
                        by=list(year=myData.jja$year),
                        FUN=sum)

ice<-get_ice(SimFile, snow.rm = TRUE)
test1<-strsplit(as.character(ice$DateTime),"-")
ice$year<-sapply(test1,"[",1)
#Position(function(x) x > 100,x)
#ice_off<-aggregate(ice(m)`~year,ice,FUN = (Position(function(x) x = 0.00000000,ice)))

#Position(function(x) x = 0.00000000,ice$`ice(m)`)

CHLa<-get_var(SimFile,var_name='PHY_TCHLA',z_out = 0.5,reference = 'surface')
CHLa<-mutate(CHLa, year = year(DateTime))
CHLa<-mutate(CHLa,month=month(DateTime))
chlasub<-CHLa[which(CHLa$month>5),]
chlasub<-chlasub[which(chlasub$month<9),]
chlasept<-CHLa[which(CHLa$month>8),]
chlasept<-chlasept[which(chlasept$month<10),]
summermean_chla<-aggregate(PHY_TCHLA_0.5~year,chlasub,mean)
summermax_chla<-aggregate(PHY_TCHLA_0.5~year,chlasub,max)
summermed_chla<-aggregate(PHY_TCHLA_0.5~year,chlasub,median)
septmean_chla<-aggregate(PHY_TCHLA_0.5~year,chlasept,mean)
septmax_chla<-aggregate(PHY_TCHLA_0.5~year,chlasept,max)
septmed_chla<-aggregate(PHY_TCHLA_0.5~year,chlasept,median)

mv = get_var(SimFile,var_name = 'PHY_TCHLA', z_out=0:3, reference = "surface") #g

library(tidyr)
a = mv %>% gather(key = 'depth',value = 'PHY_TCHLA',PHY_TCHLA_0:PHY_TCHLA_3) %>% #changing from wide to long
  mutate(depth = gsub("PHY_TCHLA_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)

sur.chla<-  aggregate(as.numeric(as.character(a$PHY_TCHLA)),
                   by=list(date=a$DateTime),
                   FUN=mean)

sur.chla<-mutate(sur.chla, year = year(date))
sur.chla<-mutate(sur.chla,month=month(date))
sur.chlasub<-sur.chla[which(sur.chla$month>5),]
sur.chlasub<-sur.chlasub[which(sur.chlasub$month<9),]
sur.chlasept<-sur.chla[which(sur.chla$month>8),]
sur.chlasept<-sur.chlasept[which(sur.chlasept$month<10),]
summermean_surchla<-aggregate(x~year,sur.chlasub,mean)
septmean_surchla<-aggregate(x~year,sur.chlasept,mean)


TP.epi<-get_var(SimFile,var_name='TotP2',z_out = 0.5,reference = 'surface')
TP.hyp<-get_var(SimFile,var_name='TotP2',z_out = 0.5,reference = 'bottom')
TP.epi<-mutate(TP.epi, year = year(DateTime))
TP.hyp<-mutate(TP.hyp, year = year(DateTime))
TP.epi<-mutate(TP.epi,month=month(DateTime))
TP.hyp<-mutate(TP.hyp,month=month(DateTime))
TP.hypsum<-TP.hyp[which(TP.hyp$month>5),]
TP.hypsum<-TP.hypsum[which(TP.hypsum$month<9),]
TP.hypfal<-TP.hyp[which(TP.hyp$month>8),]
TP.hypfal<-TP.hypfal[which(TP.hypfal$month<10),]
TP.episum<-TP.epi[which(TP.epi$month>5),]
TP.episum<-TP.episum[which(TP.episum$month<9),]
TP.epifal<-TP.epi[which(TP.epi$month>8),]
TP.epifal<-TP.epifal[which(TP.epifal$month<10),]
summermean_TPhyp<-aggregate(TotP2.elv_0.5~year,TP.hypsum,mean)
summermax_TPhyp<-aggregate(TotP2.elv_0.5~year,TP.hypsum,max)
summermed_TPhyp<-aggregate(TotP2.elv_0.5~year,TP.hypsum,median)
summermean_TPepi<-aggregate(TotP2_0.5~year,TP.episum,mean)
summermax_TPepi<-aggregate(TotP2_0.5~year,TP.episum,max)
summermed_TPepi<-aggregate(TotP2_0.5~year,TP.episum,median)
septmean_TPhyp<-aggregate(TotP2.elv_0.5~year,TP.hypfal,mean)
septmax_TPhyp<-aggregate(TotP2.elv_0.5~year,TP.hypfal,max)
septmed_TPhyp<-aggregate(TotP2.elv_0.5~year,TP.hypfal,median)
septmean_TPepi<-aggregate(TotP2_0.5~year,TP.epifal,mean)
septmax_TPepi<-aggregate(TotP2_0.5~year,TP.epifal,max)
septmed_TPepi<-aggregate(TotP2_0.5~year,TP.epifal,median)





# files<-list.files("C:/Users/nkward/Desktop/Sunapee/GLM run")
# setwd('C:/Users/nkward/Desktop/Sunapee/GLM run')
oneinflow<-read.csv("oneInflow_18May17.csv")
#alldata <- do.call(rbind, lapply(files,
#                                 function(x) cbind(read.csv(x),
#                                                   name=strsplit(x,'_')[[1]][2])))
alldata<-oneinflow
alldata$date<-as.character(alldata$time)
alldata$date<-as.POSIXct(alldata$date, format="%Y-%m-%d")
alldata<-mutate(alldata, date1 = ymd(date), year = year(date1))

#
# i505<-alldata[which(alldata$name==505),]
# i790<-alldata[which(alldata$name==790),]
# i830<-alldata[which(alldata$name==830),]
# i788<-alldata[which(alldata$name==788),]
# i510<-alldata[which(alldata$name==510),]
# i540<-alldata[which(alldata$name==540),]
# i800<-alldata[which(alldata$name==800),]
# i835<-alldata[which(alldata$name==835),]
# i805<-alldata[which(alldata$name==805),]
# i665<-alldata[which(alldata$name==665),]
# i760<-alldata[which(alldata$name==760),]
# iUNG<-alldata[which(alldata$name=="ung"),]
# iBAL<-alldata[which(alldata$name=="bal"),]



i505<-alldata

i505<-i505%>%mutate(FLOW.m3day=(FLOW*3600*24)) #kgrams per day from flow=m3/s and TP = mmol/m3


i505<-i505%>%mutate(TNload.kgday=(FLOW*3600*24)*((OGM_don+NIT_nit+NIT_amm+OGM_pon)*14/1000/1000)) #kgrams per day from flow=m3/s and TP = mmol/m3

i505<-i505%>%mutate(TPload.kgday=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000)) #kgrams per day from flow=m3/s and TP = mmol/m3
# iUNG<-iUNG%>%mutate(TPload=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000))
# iBAL<-iBAL%>%mutate(TPload=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000))
# i835<-i835%>%mutate(TPload=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000))
# i830<-i830%>%mutate(TPload=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000))
# i805<-i805%>%mutate(TPload=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000))
# i800<-i800%>%mutate(TPload=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000))
# i790<-i790%>%mutate(TPload=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000))
# i788<-i788%>%mutate(TPload=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000))
# i760<-i760%>%mutate(TPload=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000))
# i665<-i665%>%mutate(TPload=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000))
# i540<-i540%>%mutate(TPload=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000))
# i510<-i510%>%mutate(TPload=(FLOW*3600*24)*((PHS_frp_ads+OGM_pop+OGM_dop+PHS_frp)*31/1000/1000))


i505<-mutate(i505, year1 = year(time))
i505<-mutate(i505, month = month(time))
i505<-i505[which(i505$year1>1981),]
i505<-i505[which(i505$year1<2016),]
annual_505_Pload_kg<-  aggregate(as.numeric(as.character(i505$TPload)),
                                 by=list(year=i505$year1),
                                 FUN=sum)
annual_505_Nload_kg<-  aggregate(as.numeric(as.character(i505$TNload)),
                                 by=list(year=i505$year1),
                                 FUN=sum)
mam<-i505[which(i505$month>2),]
mam<-mam[which(mam$month<6),]
mam_505_Pload_kg<-  aggregate(as.numeric(as.character(mam$TPload)),
                                 by=list(year=mam$year1),
                                 FUN=sum)
mam_505_Nload_kg<-  aggregate(as.numeric(as.character(mam$TNload)),
                              by=list(year=mam$year1),
                              FUN=sum)
jja<-i505[which(i505$month>5),]
jja<-jja[which(jja$month<9),]
jja_505_Pload_kg<-  aggregate(as.numeric(as.character(jja$TPload)),
                              by=list(year=jja$year1),
                              FUN=sum)


names(summermean_schmidt)[names(summermean_schmidt)==c("year","schmidt.stability")] <- #!!!
  c("year","summer.mean.stab")
names(summermed_schmidt)[names(summermed_schmidt)==c("year","schmidt.stability")] <- #!!!
  c("year","summer.med.stab")
names(summermax_schmidt)[names(summermax_schmidt)==c("year","schmidt.stability")] <- #!!!
  c("year","jja.mx.stab")
names(septmean_schmidt)[names(septmean_schmidt)==c("year","schmidt.stability")] <- #!!!
  c("year","sep.mean.stab")
names(septmed_schmidt)[names(septmed_schmidt)==c("year","schmidt.stability")] <- #!!!
  c("year","sept.med.stab")
names(septmax_schmidt)[names(septmax_schmidt)==c("year","schmidt.stability")] <- #!!!
  c("year","sep.mx.stab")
names(septmin_schmidt)[names(septmin_schmidt)==c("year","schmidt.stability")] <- #!!!
  c("year","sep.min.stab")

names(summermean_surchla)[names(summermean_surchla)==c("year","x")] <- #!!!
  c("year","sur.chla.jja.mean")
names(septmean_surchla)[names(septmean_surchla)==c("year","x")] <- #!!!
  c("year","sur.chla.sept.mean")

names(summermean_TPhyp)[names(summermean_TPhyp)==c("year","TotP2.elv_0.5")]<-
  c("year", "sum.mean.hypP")
summermean_TPhyp$year<-as.numeric(summermean_TPhyp$year)
names(summermax_TPhyp)[names(summermax_TPhyp)==c("year","TotP2.elv_0.5")]<-
  c("year", "sum.max.hypP")
summermax_TPhyp$year<-as.numeric(summermax_TPhyp$year)
names(summermed_TPhyp)[names(summermed_TPhyp)==c("year","TotP2.elv_0.5")]<-
  c("year", "sum.med.hypP")
summermed_TPhyp$year<-as.numeric(summermed_TPhyp$year)
names(summermean_TPepi)[names(summermean_TPepi)==c("year","TotP2_0.5")]<-
  c("year", "sum.mean.epiP")
summermean_TPepi$year<-as.numeric(summermean_TPepi$year)
names(summermax_TPepi)[names(summermax_TPepi)==c("year","TotP2_0.5")]<-
  c("year", "sum.max.epiP")
summermax_TPepi$year<-as.numeric(summermax_TPepi$year)
names(summermed_TPepi)[names(summermed_TPepi)==c("year","TotP2_0.5")]<-
  c("year", "sum.med.epiP")
summermed_TPepi$year<-as.numeric(summermed_TPepi$year)
names(septmean_TPhyp)[names(septmean_TPhyp)==c("year","TotP2.elv_0.5")]<-
  c("year", "sep.mean.hypP")
septmean_TPhyp$year<-as.numeric(septmean_TPhyp$year)
names(septmax_TPhyp)[names(septmax_TPhyp)==c("year","TotP2.elv_0.5")]<-
  c("year", "sep.max.hypP")
septmax_TPhyp$year<-as.numeric(septmax_TPhyp$year)
names(septmed_TPhyp)[names(septmed_TPhyp)==c("year","TotP2.elv_0.5")]<-
  c("year", "sep.med.hypP")
septmed_TPhyp$year<-as.numeric(septmed_TPhyp$year)
names(septmean_TPepi)[names(septmean_TPepi)==c("year","TotP2_0.5")]<-
  c("year", "sep.mean.epiP")
septmean_TPepi$year<-as.numeric(septmean_TPepi$year)
names(septmax_TPepi)[names(septmax_TPepi)==c("year","TotP2_0.5")]<-
  c("year", "sep.max.epiP")
septmax_TPepi$year<-as.numeric(septmax_TPepi$year)
names(septmed_TPepi)[names(septmed_TPepi)==c("year","TotP2_0.5")]<-
  c("year", "sep.med.epiP")
septmed_TPepi$year<-as.numeric(septmed_TPepi$year)

names(summermean_chla)[names(summermean_chla)==c("year","PHY_TCHLA_0.5")] <- #!!!
  c("year","summer.mean.chla")
names(summermed_chla)[names(summermed_chla)==c("year","PHY_TCHLA_0.5")] <- #!!!
  c("year","summer.med.chla")
names(summermax_chla)[names(summermax_chla)==c("year","PHY_TCHLA_0.5")] <- #!!!
  c("year","jja.mx.chl")
names(septmean_chla)[names(septmean_chla)==c("year","PHY_TCHLA_0.5")] <- #!!!
  c("year","sep.mean.chl")
names(septmed_chla)[names(septmed_chla)==c("year","PHY_TCHLA_0.5")] <- #!!!
  c("year","sept.med.chla")
names(septmax_chla)[names(septmax_chla)==c("year","PHY_TCHLA_0.5")] <- #!!!
  c("year","sep.mx.chl")

names(annual_precip)[names(annual_precip)==c("year","Rain_m_hr")] <- #!!!
  c("year","Rain_m")
names(mam.precip)[names(mam.precip)==c("year","x")] <- #!!!
  c("year","mam.Rain_m")
mam.precip$year<-as.numeric(mam.precip$year)
names(jja.precip)[names(jja.precip)==c("year","x")] <- #!!!
  c("year","jja.Rain_m")
jja.precip$year<-as.numeric(jja.precip$year)
annual_precip$year<-as.numeric(annual_precip$year)
names(annualmean_temp)[names(annualmean_temp)==c("year","AirTemp")] <- #!!!
  c("year","mean.annual.T")
annualmean_temp$year<-as.numeric(annualmean_temp$year)
names(summermean_temp)[names(summermean_temp)==c("year","AirTemp")] <- #!!!
  c("year","mean.jja.T")
summermean_temp$year<-as.numeric(summermean_temp$year)
names(septmean_temp)[names(septmean_temp)==c("year","AirTemp")] <- #!!!
  c("year","mean.sep.T")
septmean_temp$year<-as.numeric(septmean_temp$year)
names(septmax_temp)[names(septmax_temp)==c("year","AirTemp")] <- #!!!
  c("year","max.sept.T")
septmax_temp$year<-as.numeric(septmax_temp$year)
names(annualmax_temp)[names(annualmax_temp)==c("year","AirTemp")] <- #!!!
  c("year","max.T")
annualmax_temp$year<-as.numeric(annualmax_temp$year)
names(annualmin_temp)[names(annualmin_temp)==c("year","AirTemp")] <- #!!!
  c("year","min.T")
annualmin_temp$year<-as.numeric(annualmin_temp$year)

names(annual_505_Pload_kg)[names(annual_505_Pload_kg)==c("year","x")] <- #!!!
  c("year","TP")
annual_505_Pload_kg$year<-as.numeric(annual_505_Pload_kg$year)
names(mam_505_Pload_kg)[names(mam_505_Pload_kg)==c("year","x")] <- #!!!
  c("year","mam TP")
mam_505_Pload_kg$year<-as.numeric(mam_505_Pload_kg$year)
names(mam_505_Nload_kg)[names(mam_505_Nload_kg)==c("year","x")] <- #!!!
  c("year","mam.TNload.kg")
mam_505_Nload_kg$year<-as.numeric(mam_505_Nload_kg$year)
names(jja_505_Pload_kg)[names(jja_505_Pload_kg)==c("year","x")] <- #!!!
  c("year","jja.TPload.kg")
jja_505_Pload_kg$year<-as.numeric(jja_505_Pload_kg$year)
#summermean_chla<-summermean_chla[which(summermean_chla$year>1993),]
#basecorrs<-left_join(summermean_chla,summermax_chla)
#basecorrs<-left_join(basecorrs,summermed_chla)
#basecorrs<-left_join(basecorrs,septmax_chla)
#basecorrs<-left_join(basecorrs,septmean_chla)
#basecorrs<-left_join(basecorrs,septmed_chla)
#basecorrs<-left_join(basecorrs,annual_precip) #note correlated
#basecorrs<-left_join(basecorrs,annualmean_temp)
#basecorrs<-left_join(basecorrs,jja.precip)
#basecorrs<-left_join(basecorrs,mam.precip)
basecorrs<-left_join(summermean_temp,mam.precip)
#basecorrs<-left_join(basecorrs,summermean_temp)
basecorrs<-left_join(basecorrs,septmean_temp)
#basecorrs<-left_join(basecorrs,septmax_temp)
#basecorrs<-left_join(basecorrs,annualmax_temp)
#basecorrs<-left_join(basecorrs,annualmin_temp) #not correlated
#basecorrs<-left_join(basecorrs,annual_505_Pload_kg)
basecorrs<-left_join(basecorrs,mam_505_Pload_kg)
#basecorrs<-left_join(basecorrs,mam_505_Nload_kg)
basecorrs<-left_join(basecorrs,jja_505_Pload_kg)
#basecorrs<-left_join(basecorrs,summermean_schmidt)
#basecorrs<-left_join(basecorrs,summermed_schmidt)
#basecorrs<-left_join(basecorrs,summermax_schmidt)
#basecorrs<-left_join(basecorrs,septmean_schmidt)
#basecorrs<-left_join(basecorrs,septmed_schmidt)
#basecorrs<-left_join(basecorrs,septmax_schmidt)
#basecorrs<-left_join(basecorrs,septmin_schmidt)
basecorrs<-left_join(basecorrs,summermean_TPhyp)
#basecorrs<-left_join(basecorrs,summermax_TPhyp)
#summermed_TPhyp
basecorrs<-left_join(basecorrs,summermean_TPepi)
#basecorrs<-left_join(basecorrs,summermax_TPepi)
#summermed_TPepi
basecorrs<-left_join(basecorrs,septmean_TPhyp)
#septmax_TPhyp
#septmed_TPhyp
basecorrs<-left_join(basecorrs,septmean_TPepi)
#basecorrs<-left_join(basecorrs,septmax_TPepi)
basecorrs<-left_join(basecorrs,summermean_surchla)
basecorrs<-left_join(basecorrs,septmean_surchla)
#septmed_TPepi

dev.off()
pairs(basecorrs)
cormatrix<-cor(basecorrs)
# install.packages("PerformanceAnalytics")
library("PerformanceAnalytics")
chart.Correlation(basecorrs, histogram=TRUE, pch=19,method = "pearson")

## turn the function into a character string
tmpstr <- deparse(chart.Correlation)
## modify the relevant lines
panelcorline <- grep("^ *panel.cor",tmpstr)
tmpstr[panelcorline] <- paste(tmpstr[panelcorline],"cex.cor.scale=1,")
rscaleline <- grep("^ *text\\(0.5",tmpstr)
tmpstr[rscaleline] <- gsub("cex \\* r","cex*r^cex.cor.scale",tmpstr[rscaleline])
## convert back to a function (don't mask the original function)
my.chart.Correlation <- eval(parse(text=tmpstr))
## no scaling
my.chart.Correlation(basecorrs, histogram=TRUE, pch="+",cex.cor.scale=0)

plot(basecorrs$sur.chla.jja.mean,basecorrs$`mam TP`,pch=16, ylab = "mar-apr-may TP load",cex=2,
     xlab = "surface chla mean jun-jul-aug",cex.axis=1.5, cex.lab=1.5)
s<-cor.test(basecorrs$sur.chla.jja.mean,basecorrs$`mam TP`,method = "spearman")
rho.1<-s[[4]]
text(1,300,paste("spearmans rho",round(rho.1,digits = 3)))

plot(basecorrs$sur.chla.jja.mean,basecorrs$mean.jja.T,pch=16, ylab = "mean jun-jul-aug Temp",cex=2,
     xlab = "surface chla mean jun-jul-aug",cex.axis=1.5, cex.lab=1.5)
s.2<-cor.test(basecorrs$sur.chla.jja.mean,basecorrs$mean.jja.T,method = "spearman")
rho.2<-s.2[[4]]
text(2,17,paste("spearmans rho",round(rho.2,digits = 3)))

plot(basecorrs$sur.chla.sept.mean,basecorrs$`mam TP`, pch=16, ylab = "mar-apr-may TP load",cex=2,
     xlab = "surface chla mean Sept",cex.axis=1.5, cex.lab=1.5)
s.3<-cor.test(basecorrs$sur.chla.sept.mean,basecorrs$`mam TP`,method = "spearman")
rho.3<-s.3[[4]]
text(1,300,paste("spearmans rho",round(rho.3,digits = 3)))

plot(basecorrs$sur.chla.sept.mean,basecorrs$mean.sep.T, pch=16, ylab = "mean sept Temp",cex=2,
     xlab = "surface chla mean Sept",cex.axis=1.5, cex.lab=1.5)
s.4<-cor.test(basecorrs$sur.chla.sept.mean,basecorrs$mean.sep.T,method = "spearman")
rho.4<-s.4[[4]]
text(1,13,paste("spearmans rho",round(rho.4,digits = 3)))

write.csv(basecorrs,"annual_data_surchla.csv",row.names = FALSE,quote = FALSE)
library("corrplot")
M<-cor(basecorrs)
head(round(M,2))

corrplot(M, method="circle")
corrplot(M, method="number")
corrplot(M, method="color")
corrplot(M, type="upper")
corrplot(M, type="lower")
# correlogram with hclust reordering
corrplot(M, type="upper", order="hclust",)
# Using different color spectrum
col<- colorRampPalette(c("red", "white", "blue"))(20)
corrplot(M, type="upper", order="hclust", col=col)
# Change background color to lightblue
corrplot(M, type="upper", order="hclust", col=c("black", "white"),
         bg="lightblue")
library(RColorBrewer)
corrplot(M, type="upper", order="hclust",
         col=brewer.pal(n=8, name="RdBu"))
corrplot(M, type="upper", order="hclust",
         col=brewer.pal(n=8, name="PuOr"))
#tl.col (for text label color) and
#tl.srt (for text label string rotation)
#are used to change text colors and rotations.
corrplot(M, type="upper", order="hclust", tl.col="black", tl.srt=45)
# mat : is a matrix of data
# ... : further arguments to pass to the native R cor.test function
cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat<- matrix(NA, n, n)
  diag(p.mat) <- 0
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  p.mat
}
# matrix of the p-value of the correlation
p.mat <- cor.mtest(basecorrs)
head(p.mat[, 1:5])
# Leave blank on no significant coefficient
corrplot(M, type="upper", order="hclust", diag=FALSE,tl.srt=45,
         col=brewer.pal(n=8, name="PiYG"),
         p.mat = p.mat, sig.level = 0.01, insig = "blank",tl.col = "black")


col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(M, method="color", col=col(200),
         type="upper", order="hclust",
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat, sig.level = 0.01, insig = "blank",
         # hide correlation coefficient on the principal diagonal
         diag=FALSE
)

col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(M, method="color", col=col(200),
         type="upper", order="hclust",
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat, sig.level = 0.01, insig = "blank",
         # hide correlation coefficient on the principal diagonal
         diag=FALSE
)



corrplot.mixed(cor(basecorrs), order="hclust", tl.col="black")
corrmatrix(data = basecorrs,alpha = 0.05)

#### time series analysis ####
basecorrs<-basecorrs[which(basecorrs$year>1986),]
plot(basecorrs$year,basecorrs$summer.mean.chla)
#This will plot the time series
abline(reg=lm(basecorrs$summer.mean.chla~basecorrs$year))

## temporal autocorrelation
mdl <- lm(summer.mean.chla ~year,data=basecorrs)
summary(mdl)
par(mfrow=c(2,2))
plot(mdl)
par(mfrow=c(1,1))
plot(residuals(mdl))
plot(residuals(mdl),type="b")
abline(h=0,lty=3)
acf(residuals(mdl))

### http://r-statistics.co/Time-Series-Analysis-With-R.html
summer.mean<-as.numeric(basecorrs$summer.mean.chla)
mean.ts<-ts (summer.mean, start=c(1987), end=c(2015), frequency=1) # Yea
decomposedRes <- decompose(mean.ts, type="mult") # use type = "additive" for additive components
plot (decomposedRes) # see plot below
stlRes <- stl(tsData, s.window = "periodic")
acf(mean.ts)
# Use Augmented Dickey-Fuller Test (adf test).
#A p-Value of less than 0.05 in adf.test() indicates that it is stationary.
library(tseries)
adf.test(mean.ts) # p-value < 0.05 indicates the TS is stationary
library(forecast)
ndiffs(mean.ts)


# temporal autocorrelation based on summer max
mdl <- lm(max.chla ~year,data=basecorrs)
summary(mdl)
par(mfrow=c(2,2))
plot(mdl)
par(mfrow=c(1,1))
plot(residuals(mdl))
plot(residuals(mdl),type="b")
abline(h=0,lty=3)
acf(residuals(mdl))

#### regression plots for GLEON ####
basecorrs<-basecorrs[which(basecorrs$year>1985),]

septlm<-lm(sept.max.chla~mam.TPload.kg + mean.sept.T + mam.TPload.kg*mean.sept.T,
           data = basecorrs)
summary(septlm)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(septlm)

summlm<-lm(summer.max.chla~mam.TPload.kg + mean.summer.T + mam.TPload.kg*mean.summer.T,
           data = basecorrs)
summary(summlm)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(summlm)

plot(basecorrs$mam.TPload.kg,basecorrs$sept.max.chla,
     pch=16,ylab="September Maximum Chl-a (ug/L)",cex=2,col="chartreuse4",
     xlab="Spring (Mar-Apr-May) Phosphorus Load (kg/3 months)",cex.lab=1.5,
     cex.axis=1.5)
abline(septlm,lwd=2)


septlm<-lm(sept.max.chla~mam.TPload.kg,data = basecorrs)
plot(basecorrs$mam.TPload.kg,basecorrs$sept.max.chla,
     pch=16,ylab="September Maximum Chl-a (ug/L)",cex=2,col="chartreuse4",
     xlab="Spring (Mar-Apr-May) Phosphorus Load (kg/3 months)",cex.lab=1.5,
     cex.axis=1.5)
abline(septlm,lwd=2)
septlm<-lm(sept.max.chla~mam.TPload.kg,data = basecorrs)
plot(basecorrs$mean.sept.T,basecorrs$sept.max.chla,
     pch=16,ylab="September Maximum Chl-a (ug/L)",cex=2,col="chartreuse4",
     xlab="mean September temperature (C)",cex.lab=1.5,
     cex.axis=1.5)
abline(septlm,lwd=2)
sumlm<-lm(sept.max.chla~mam.TPload.kg,data = basecorrs)
plot(basecorrs$mam.TPload.kg,basecorrs$sept.max.chla,
     pch=16,ylab="September Maximum Chl-a (ug/L)",cex=2,col="chartreuse4",
     xlab="Spring (Mar-Apr-May) Phosphorus Load (kg/3 months)",cex.lab=1.5,
     cex.axis=1.5)
abline(septlm,lwd=2)

### 3d plots for GLEON#####
# Load the package that contains the full dataset.
library(car)
library(corrplot) # We'll use corrplot later on in this example too.
library(visreg) # This library will allow us to show multivariate graphs.
library(rgl)
library(knitr)
library(scatterplot3d)
plot(basecorrs)

set.seed(1)
summary(basecorrs)
##### sept rgdal########
# Center predictors.
mean.sept.T.c = scale(basecorrs$mean.sept.T, center=TRUE, scale=FALSE)
mam.TP.c = scale(basecorrs$mam.TPload.kg, center=TRUE, scale=FALSE)
sept.chla.c = scale(basecorrs$sept.max.chla, center=TRUE, scale=FALSE)
# bind these new variables into newdata and display a summary.
basecorrs.c = cbind(mean.sept.T.c, mam.TP.c,sept.chla.c)
newdata = cbind(basecorrs, basecorrs.c)
names(newdata)[14:16] = c("mean.sept.T.c", "mam.TP.c","sept.chla.c")
mod1 = lm(sept.chla.c ~ mean.sept.T.c + mam.TP.c +(mean.sept.T.c*mam.TP.c), data=newdata)
summary(mod1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(mod1)


newdat <- expand.grid(mam.TP.c=seq(-300,200,by=1),mean.sept.T.c=seq(-3,4,by=0.07))
newdat$pp <- predict(mod1,newdata=newdat)
with(newdata,plot3d(mam.TP.c,mean.sept.T.c,sept.chla.c, col="sienna2", size=4,
                    type="s", main="",ylab="",xlab="",zlab="",cex.axis=3,
                    cex.lab=3,cex=2))
with(newdat,surface3d(unique(mam.TP.c),unique(mean.sept.T.c),pp,col="darkorange4",
                      colorkey=TRUE,
                      alpha=0.3,front="line", back="line"))
writeWebGL(dir = "webGL", filename = file.path(sim_folder, "index.html"))

#### sumer rgdal #####
# Center predictors.
mean.summer.T.c = scale(basecorrs$mean.summer.T, center=TRUE, scale=FALSE)
mam.TP.c = scale(basecorrs$mam.TPload.kg, center=TRUE, scale=FALSE)
summ.chla.c = scale(basecorrs$summer.mean.chla, center=TRUE, scale=FALSE)
# bind these new variables into newdata and display a summary.
basecorrs2.c = cbind(mean.summer.T.c, mam.TP.c,summ.chla.c)
newdata2 = cbind(basecorrs, basecorrs2.c)
names(newdata2)[14:16] = c("mean.summer.T.c", "mam.TP.c","summer.chla.c")
mod2 = lm(summer.chla.c ~ mean.summer.T.c + mam.TP.c +(mean.summer.T.c*mam.TP.c), data=newdata2)
summary(mod2)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(mod2)
dev.off()
plot(mod1) #, pch=16, which=1)

newdat2 <- expand.grid(mam.TP.c=seq(-250,200,by=1),mean.summer.T.c=seq(-2,2,by=0.07))
newdat2$pp <- predict(mod2,newdata = newdat2)
with(newdata2,plot3d(mam.TP.c,mean.summer.T.c,summer.chla.c, col="slateblue2", size=4,
                    type="s", main="",ylab="",xlab="",zlab="",cex.axis=3,
                    cex.lab=3,cex=2))
with(newdat2,surface3d(unique(mam.TP.c),unique(mean.summer.T.c),pp,col="slateblue4",
                      colorkey=TRUE,
                      alpha=0.3,front="line", back="line"))
writeWebGL(dir = "webGL", filename = file.path(sim_folder, "index.html"))


### https://www.datascience.com/blog/introduction-to-forecasting-with-arima-in-r-learn-data-science-tutorials
trucCHLA<-CHLa[which(CHLa$DateTime>"1987-12-31"),]
library('ggplot2')
library('forecast')
library('tseries')
count_ma = ts(na.omit(CHLa$PHY_TCHLA_0.5), frequency=365)
decomp = stl(count_ma, s.window="periodic")
deseasonal_cnt <- seasadj(decomp)
plot(decomp)
# Fitting an ARIMA model requires the series to be stationary.
#A series is said to be stationary when its mean, variance, and
#autocovariance are time invariant.
adf.test(count_ma, alternative = "stationary")
count_bc = ts(na.omit(basecorrs$summer.mean.chla), frequency=1)
adf.test(count_bc, alternative = "stationary")
Acf(count_ma, main='')
Acf(count_bc, main='')
Acf(basecorrs$summer.max.chla)

Pacf(count_ma, main='')

count_d1 = diff(deseasonal_cnt, differences = 1)
plot(count_d1)
adf.test(count_d1, alternative = "stationary")
Acf(count_d1)
Pacf(count_d1)
auto.arima(deseasonal_cnt, seasonal=FALSE)
##### modify driver data ######
test <- strsplit(as.character(oneinflow$time), "-")
oneinflow$year<-sapply(test, "[", 1)
oneinflow$month<-sapply(test, "[", 2)


mutate_cond <- function(.data, condition, ..., envir = parent.frame()) {
  condition <- eval(substitute(condition), .data, envir)
  .data[condition, ] <- .data[condition, ] %>% mutate(...)
  .data
}
# add 50 % of observed range for ch 1 scenario tests
inflow.springP<-oneinflow%>% mutate_cond(as.numeric(month) > 2 & as.numeric(month) < 6,
                                         PHS_frp=PHS_frp+0.02436,
                                       OGM_dop=OGM_dop+0.1185,OGM_pop=OGM_pop+0.27,
                                       PHS_frp_ads=PHS_frp_ads+0.41295)
index<-subset(inflow.springP,select=c("time","FLOW","SALT", "TEMP","OGM_doc","OGM_poc","OGM_don","NIT_nit","NIT_amm","OGM_pon",  #!!!
                             "PHS_frp","OGM_dop","OGM_pop","PHS_frp_ads"))
write.csv(index,file = paste("inflow_50percmoreSpringP.csv",sep=""), row.names = FALSE, quote = FALSE)

MetData<-read.csv("SunapeeMet_1979_2016EST.csv", header=TRUE)
MetData$time<-as.character(MetData$time)
MetData$time<-as.POSIXct(as.character(MetData$time), format="%Y-%m-%d %H:%M:%S",tz = "EST")
test <- strsplit(as.character(MetData$time), "-")
MetData$year<-sapply(test, "[", 1)
MetData$month<-sapply(test, "[", 2)
MetData$month<-as.numeric(as.character(MetData$month))
myData<-na.omit(MetData)
MetData_summerTplus1p5<-myData%>% mutate_cond(month > 5 & month < 9,
                                        AirTemp=AirTemp+1.5)
index<-subset(MetData_summerTplus1p5,select=c("time","ShortWave","LongWave","AirTemp",
                                      "RelHum","WindSpeed","Rain" ))
write.csv(index,file = paste("MetData_summerTplus1p5.csv",sep=""), row.names = FALSE, quote = FALSE)
MetData_septTplus2p3<-myData%>% mutate_cond(month > 8 & month < 10,
                                              AirTemp=AirTemp+2.345)
index<-subset(MetData_septTplus2p3,select=c("time","ShortWave","LongWave","AirTemp",
                                              "RelHum","WindSpeed","Rain" ))
write.csv(index,file = paste("MetData_septTplus2p3.csv",sep=""), row.names = FALSE, quote = FALSE)

####### Ch1 scenario outputs############
library(tidyr)

setwd('/Users/nicoleward/Documents/VirginiaTech/Manuscripts/SunapeeGLM/transfer_from_frankenstein/GLM_run')
SimDir ='/Users/nicoleward/Documents/VirginiaTech/Manuscripts/SunapeeGLM/transfer_from_frankenstein/GLM_run'
SimFile = paste(SimDir,'/','output.nc',sep = '')
mv = get_var(SimFile,var_name = 'PHY_TCHLA', z_out=0:3, reference = "surface") #
a = mv %>% gather(key = 'depth',value = 'PHY_TCHLA',PHY_TCHLA_0:PHY_TCHLA_3) %>% #changing from wide to long
  mutate(depth = gsub("PHY_TCHLA_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)
sur.chla<-  aggregate(as.numeric(as.character(a$PHY_TCHLA)),
                                by=list(date=a$DateTime),
                                FUN=mean)
sur.chla<-mutate(sur.chla, year = year(date))
sur.chla<-mutate(sur.chla,month=month(date))
sur.chlasub<-sur.chla[which(sur.chla$month>5),]
sur.chlasub<-sur.chlasub[which(sur.chlasub$month<9),]
sur.chlasept<-sur.chla[which(sur.chla$month>8),]
sur.chlasept<-sur.chlasept[which(sur.chlasept$month<10),]
summermean_surchla<-aggregate(x~year,sur.chlasub,mean)
names(summermean_surchla)[names(summermean_surchla)==c("year","x")] <- #!!!
  c("year","jja.surchla")
summermean_surchla$year<-as.numeric(summermean_surchla$year)
septmean_surchla<-aggregate(x~year,sur.chlasept,mean)
names(septmean_surchla)[names(septmean_surchla)==c("year","x")] <- #!!!
  c("year","sept.surchla")
septmean_surchla$year<-as.numeric(septmean_surchla$year)

setwd('/Users/nicoleward/Documents/VirginiaTech/Manuscripts/SunapeeGLM/transfer_from_frankenstein/GLM_run_septT')
SimDir ='/Users/nicoleward/Documents/VirginiaTech/Manuscripts/SunapeeGLM/transfer_from_frankenstein/GLM_run_septT'
SimFile = paste(SimDir,'/','output.nc',sep = '')
mv = get_var(SimFile,var_name = 'PHY_TCHLA', z_out=0:3, reference = "surface") #
a = mv %>% gather(key = 'depth',value = 'PHY_TCHLA',PHY_TCHLA_0:PHY_TCHLA_3) %>% #changing from wide to long
  mutate(depth = gsub("PHY_TCHLA_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)
sur.chla.SeptTscen<-  aggregate(as.numeric(as.character(a$PHY_TCHLA)),
                      by=list(date=a$DateTime),
                      FUN=mean)
sur.chla.SeptTscen<-mutate(sur.chla.SeptTscen, year = year(date))
sur.chla.SeptTscen<-mutate(sur.chla.SeptTscen,month=month(date))
sur.chlasub.SeptTscen<-sur.chla.SeptTscen[which(sur.chla.SeptTscen$month>5),]
sur.chlasub.SeptTscen<-sur.chlasub.SeptTscen[which(sur.chlasub.SeptTscen$month<9),]
sur.chlasept.SeptTscen<-sur.chla.SeptTscen[which(sur.chla.SeptTscen$month>8),]
sur.chlasept.SeptTscen<-sur.chlasept.SeptTscen[which(sur.chlasept.SeptTscen$month<10),]
summermean_surchla.SeptTscen<-aggregate(x~year,sur.chlasub.SeptTscen,mean)
names(summermean_surchla.SeptTscen)[names(summermean_surchla.SeptTscen)==c("year","x")] <- #!!!
  c("year","jja.surchla.SeptTscen")
summermean_surchla.SeptTscen$year<-as.numeric(summermean_surchla.SeptTscen$year)
septmean_surchla.SeptTscen<-aggregate(x~year,sur.chlasept.SeptTscen,mean)
names(septmean_surchla.SeptTscen)[names(septmean_surchla.SeptTscen)==c("year","x")] <- #!!!
  c("year","sept.surchla.SeptTscen")
septmean_surchla.SeptTscen$year<-as.numeric(septmean_surchla.SeptTscen$year)

setwd('/Users/nicoleward/Documents/VirginiaTech/Manuscripts/SunapeeGLM/transfer_from_frankenstein/GLM_run_jjaT')
SimDir ='/Users/nicoleward/Documents/VirginiaTech/Manuscripts/SunapeeGLM/transfer_from_frankenstein/GLM_run_jjaT'
SimFile = paste(SimDir,'/','output.nc',sep = '')
mv = get_var(SimFile,var_name = 'PHY_TCHLA', z_out=0:3, reference = "surface") #
a = mv %>% gather(key = 'depth',value = 'PHY_TCHLA',PHY_TCHLA_0:PHY_TCHLA_3) %>% #changing from wide to long
  mutate(depth = gsub("PHY_TCHLA_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)
sur.chla.jjaTscen<-  aggregate(as.numeric(as.character(a$PHY_TCHLA)),
                                by=list(date=a$DateTime),
                                FUN=mean)
sur.chla.jjaTscen<-mutate(sur.chla.jjaTscen, year = year(date))
sur.chla.jjaTscen<-mutate(sur.chla.jjaTscen,month=month(date))
sur.chlasub.jjaTscen<-sur.chla.jjaTscen[which(sur.chla.jjaTscen$month>5),]
sur.chlasub.jjaTscen<-sur.chlasub.jjaTscen[which(sur.chlasub.jjaTscen$month<9),]
sur.chlasept.jjaTscen<-sur.chla.jjaTscen[which(sur.chla.jjaTscen$month>8),]
sur.chlasept.jjaTscen<-sur.chlasept.jjaTscen[which(sur.chlasept.jjaTscen$month<10),]
summermean_surchla.jjaTscen<-aggregate(x~year,sur.chlasub.jjaTscen,mean)
names(summermean_surchla.jjaTscen)[names(summermean_surchla.jjaTscen)==c("year","x")] <- #!!!
  c("year","jja.surchla.jjaTscen")
summermean_surchla.jjaTscen$year<-as.numeric(summermean_surchla.jjaTscen$year)
septmean_surchla.jjaTscen<-aggregate(x~year,sur.chlasept.jjaTscen,mean)
names(septmean_surchla.jjaTscen)[names(septmean_surchla.jjaTscen)==c("year","x")] <- #!!!
  c("year","sept.surchla.jjaTscen")
septmean_surchla.jjaTscen$year<-as.numeric(septmean_surchla.jjaTscen$year)

setwd('/Users/nicoleward/Documents/VirginiaTech/Manuscripts/SunapeeGLM/transfer_from_frankenstein/GLM_run_mamTP')
SimDir ='/Users/nicoleward/Documents/VirginiaTech/Manuscripts/SunapeeGLM/transfer_from_frankenstein/GLM_run_mamTP'
SimFile = paste(SimDir,'/','output.nc',sep = '')
mv = get_var(SimFile,var_name = 'PHY_TCHLA', z_out=0:3, reference = "surface") #
a = mv %>% gather(key = 'depth',value = 'PHY_TCHLA',PHY_TCHLA_0:PHY_TCHLA_3) %>% #changing from wide to long
  mutate(depth = gsub("PHY_TCHLA_","",depth)) %>% # change column headers
  mutate(depth = as.numeric(depth)) %>%
  arrange(DateTime,depth)
sur.chla.mamTPscen<-  aggregate(as.numeric(as.character(a$PHY_TCHLA)),
                               by=list(date=a$DateTime),
                               FUN=mean)
sur.chla.mamTPscen<-mutate(sur.chla.mamTPscen, year = year(date))
sur.chla.mamTPscen<-mutate(sur.chla.mamTPscen,month=month(date))
sur.chlasub.mamTPscen<-sur.chla.mamTPscen[which(sur.chla.mamTPscen$month>5),]
sur.chlasub.mamTPscen<-sur.chlasub.mamTPscen[which(sur.chlasub.mamTPscen$month<9),]
sur.chlasept.mamTPscen<-sur.chla.mamTPscen[which(sur.chla.mamTPscen$month>8),]
sur.chlasept.mamTPscen<-sur.chlasept.mamTPscen[which(sur.chlasept.mamTPscen$month<10),]
require(doBy)
summermean_surchla.mamTPscen<-summaryBy(x~year, data = sur.chlasub.mamTPscen, FUN = max)

max(sur.chlasub$x)
max(sur.chlasub.jjaTscen$x)
max(sur.chlasub.mamTPscen$x)
max(sur.chlasub.SeptTscen$x)
max(sur.chlasept$x)
max(sur.chlasept.jjaTscen$x)
max(sur.chlasept.mamTPscen$x)
max(sur.chlasept.SeptTscen$x)

mean(sur.chlasub$x)
mean(sur.chlasub.jjaTscen$x)
mean(sur.chlasub.mamTPscen$x)
mean(sur.chlasub.SeptTscen$x)
mean(sur.chlasept$x)
mean(sur.chlasept.jjaTscen$x)
mean(sur.chlasept.mamTPscen$x)
mean(sur.chlasept.SeptTscen$x)


summermean_surchla.mamTPscen<-aggregate(x~year,sur.chlasub.mamTPscen,FUN = max)
names(summermean_surchla.mamTPscen)[names(summermean_surchla.mamTPscen)==c("year","x")] <- #!!!
  c("year","jja.surchla.mamTPscen")
summermean_surchla.mamTPscen$year<-as.numeric(summermean_surchla.mamTPscen$year)
septmean_surchla.mamTPscen<-aggregate(x~year,sur.chlasept.mamTPscen,mean)
names(septmean_surchla.mamTPscen)[names(septmean_surchla.mamTPscen)==c("year","x")] <- #!!!
  c("year","sept.surchla.mamTPscen")
septmean_surchla.mamTPscen$year<-as.numeric(septmean_surchla.mamTPscen$year)

#summermean_chla<-summermean_chla[which(summermean_chla$year>1993),]
basecorrs<-left_join(septmean_surchla,summermean_surchla)
basecorrs<-left_join(basecorrs,septmean_surchla.mamTPscen)
basecorrs<-left_join(basecorrs,summermean_surchla.mamTPscen)
basecorrs<-left_join(basecorrs,septmean_surchla.jjaTscen)
basecorrs<-left_join(basecorrs,summermean_surchla.jjaTscen)
basecorrs<-left_join(basecorrs,septmean_surchla.SeptTscen)
basecorrs<-left_join(basecorrs,summermean_surchla.SeptTscen)
basecorrs<-basecorrs[which(basecorrs$year>1986),]
#### extra plots@#####

plot(val.epi.mean$modeled,val.epi.mean$observed)
jpeg(filename = "C:/Users/nkward/Desktop/Sunapee/Calibration_Figures/val_epi_dailymean.jpeg",width = 10,height = 10,
     units = "in",res = 300)
plot(val.epi.mean$date,val.epi.mean$modeled,type = "l",lwd=2,ylim=c(10,28),
     ylab="mean daily epilimnion temperature (to 6m)", xlab="date",main="Validation Period: 1989 - 2004")
lines(val.epi.mean$date,val.epi.mean$observed,col="blue",lwd=2)
legend("topleft",legend = c("simulated","observed"),col=c("black","blue"),lwd=c(2,2))
dev.off()


jpeg(filename = "C:/Users/nkward/Desktop/Sunapee/Calibration_Figures/cal_epi_dailymean.jpeg",width = 10,height = 10,
     units = "in",res = 300)
plot(cal.epi.mean$date,cal.epi.mean$modeled,type = "l",lwd=2,
     ylab="mean daily epilimnion temperature (to 6m)", xlab="date",main="Validation Period: 1989 - 2004")
lines(cal.epi.mean$date,cal.epi.mean$observed,col="blue",lwd=2)
legend("bottomleft",legend = c("simulated","observed"),col=c("black","blue"),lwd=c(2,2))
dev.off()

jpeg(filename = "C:/Users/nkward/Desktop/Sunapee/Calibration_Figures/temp_simobs.jpeg",width = 10,height = 10,
     units = "in",res = 300)
plot(myTempResampled$Modeled_temp,myTempResampled$Observed_temp, main = "all depths, daily timestep",
     ylab="observed temperature", xlab="modeled temperature")
points(myTempResampled$Modeled_temp[which(myTempResampled$Depth<1)],
       myTempResampled$Observed_temp[which(myTempResampled$Depth<1)], col="red",pch=16,cex=2)
points(myTempResampled$Modeled_temp[which(myTempResampled$Depth>0.9& myTempResampled$Depth<5.6)],
       myTempResampled$Observed_temp[which(myTempResampled$Depth>0.9& myTempResampled$Depth<5.6)], col="green",pch=16)
points(myTempResampled$Modeled_temp[which(myTempResampled$Depth>5.9& myTempResampled$Depth<7.6)],
       myTempResampled$Observed_temp[which(myTempResampled$Depth>5.9& myTempResampled$Depth<7.6)], col="grey",pch=16)
points(myTempResampled$Modeled_temp[which(myTempResampled$Depth>7.6& myTempResampled$Depth<14.1)],
       myTempResampled$Observed_temp[which(myTempResampled$Depth>7.6& myTempResampled$Depth<14.1)], col="orange",pch=16)
points(myTempResampled$Modeled_temp[which(myTempResampled$Depth>14)],
       myTempResampled$Observed_temp[which(myTempResampled$Depth>14)], col="slateblue",pch=16)
legend("topleft",pch=c(16,16,16,16,16),col=c("red","green","grey","orange","slateblue"),legend=c("< 1m","1-6m","6 - 7.5m",
                                                                                    "7.5 - 14m",">14m"))
text(paste())
dev.off()


thermodepths<-compare_to_field(SimFile, tempTemp, metric = 'thermo.depth', as_value = TRUE,
                       na.rm = TRUE, precision = 'days',method = 'interp')

jpeg(filename = "C:/Users/nkward/Desktop/Sunapee/Calibration_Figures/depth2thermocline.jpeg",width = 10,height = 10,
     units = "in",res = 600)
plot(test$DateTime,test$obs,type = "l",ylim=c(0,30),ylab="depth to thermocline (m)",
     xlab="Date",main="Simulated (line) and Observed (points) Depth to Thermocline",
     cex.axis=1.5,cex.lab=1.5)
lines(test$DateTime,test$mod,col="blue")
dev.off()

rmse.depthtothermo<-compare_to_field(SimFile, tempTemp, metric = 'thermo.depth', as_value = FALSE,
                       na.rm = TRUE, precision = 'days',method = 'interp')

thermodepths$DateTime<-as.Date(thermodepths$DateTime)
jpeg(filename = "C:/Users/nkward/Desktop/Sunapee/Calibration_Figures/depth2thermoclineGGOF.jpeg",width = 20,height = 20,
     units = "in",res = 600)
ggof(sim = thermodepths$mod,obs = thermodepths$obs,ylab = "depth to thermocline (m)")
dev.off()
metrics$Variable[10]<-"alldates_depth2thermo_buoyandhand"
thermo.lm<-lm(formula = mod ~ obs,data = thermodepths)
thermo.rq<-summary(thermo.lm)$r.squared
metrics$r.squared[10]<-thermo.rq
metrics$n[10]<-nrow(thermodepths)
metrics$RMSE[10]<-5.69
metrics$PBIAS[10]<-34.1
metrics$NSE[10]<--4.15
metrics$r[10]<-0.44


cal.thermo<-thermodepths[which(thermodepths$DateTime>"2004-12-31"),]
cal.thermo<-cal.thermo[which(cal.thermo$DateTime<"2011-01-01"),]
ggof(sim = cal.thermo$mod,obs = cal.thermo$obs)

metrics$Variable[11]<-"calibration_depth2thermo_buoyandhand"
cal.thermo.lm<-lm(formula = mod ~ obs,data = cal.thermo)
calthermo.rq<-summary(cal.thermo.lm)$r.squared
metrics$r.squared[11]<-calthermo.rq
metrics$n[11]<-nrow(cal.thermo)
metrics$RMSE[11]<-5.04
metrics$PBIAS[11]<-33.2
metrics$NSE[11]<--4.7
metrics$r[11]<-0.08
metrics$MAE[11]<-4.06



val.thermo<-thermodepths[which(thermodepths<"2005-01-01"),]
ggof(sim = val.thermo$mod,obs = val.thermo$obs)

metrics$Variable[12]<-"validation_depth2thermo_buoyandhand"
val.thermo.lm<-lm(formula = mod ~ obs,data = val.thermo)
valthermo.rq<-summary(val.thermo.lm)$r.squared
metrics$r.squared[12]<-valthermo.rq
metrics$n[12]<-nrow(val.thermo)
metrics$RMSE[12]<-8.36
metrics$PBIAS[12]<-65.7
metrics$NSE[12]<--7.55
metrics$r[12]<-0.25
metrics$MAE[12]<-7.4

metrics<-subset(metrics,select = c("Variable","r.squared","n","RMSE","PBIAS","NSE","r","MAE"))
write.csv(x = metrics,file = "GOFmetrics.csv",quote = FALSE, row.names = FALSE)

ObsFileNutrients = "/Users/nicoleward/Downloads/transfer_from_frankenstein/GLM_run/limnol_buoydeep_to2013_05Jan2017.csv"

myNutrients = read.csv(ObsFileNutrients)
myDO = myNutrients %>% filter(variable == "DO_mgL") %>% filter(depth.m == 1) %>%
  dplyr::select(datetime = date,depth=depth.m, DO = value)
myDO$datetime<-as.POSIXct(myDO$datetime,format="%Y-%m-%d")
plot(DO$DateTime,DO$DO_1, type="l",ylim=c(4,20))
points(myDO$datetime,myDO$DO)

TP<-get_var(SimFile,var_name='TotP2',z_out = 1.5,reference = 'surface')
myTP = myNutrients %>% filter(variable == "TP_mgL") %>%filter(depth.m < 4) %>%
  dplyr::select(datetime = date,depth=depth.m, TP = value)
myTP$datetime<-as.POSIXct(myTP$datetime,format="%Y-%m-%d")
plot(TP$DateTime,TP$TotP2_1, type="l",ylim=c(0,0.007))
points(myTP$datetime,myTP$TP)

CHLa<-get_var(SimFile,var_name='PHY_TCHLA',z_out = 0.1,reference = 'surface')
myCHLa = myNutrients %>% filter(variable == "chla_ugL") %>%
  dplyr::select(datetime = date,depth=depth.m, CHLa = value)
myCHLa$datetime<-as.POSIXct(myCHLa$datetime,format="%Y-%m-%d")
plot(CHLa$DateTime,CHLa$PHY_TCHLA_0.5, type="l",ylim=c(0,12))
points(myCHLa$datetime,myCHLa$CHLa)
lines(myCHLa$datetime,myCHLa$CHLa,lty=2)

mySD = myNutrients %>% filter(variable == "SD_m") %>%
  dplyr::select(datetime = date,depth=depth.m, SD = value)
lec<-get_var(SimFile,var_name = 'extc_coef',z_out=1,reference = 'surface')
sd<-1.7/lec[,2]
plot(lec[,1],sd,type='l',ylim=c(4,12))
mySD$datetime<-as.POSIXct(mySD$datetime,format="%Y-%m-%d")
points(mySD$datetime,mySD$SD)
