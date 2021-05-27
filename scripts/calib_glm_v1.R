library(glmtools)

setwd("C:/Users/wwoel/Desktop/Sunapee-GLM")
sim_folder <- getwd()
out_file <- file.path(sim_folder, "output","output.nc")
nml_file <- file.path(sim_folder, 'glm3_woAED.nml')
field_temp <- file.path(paste0(sim_folder, '/data/field_temp_noon_obs.csv'))
field_stage <- file.path(paste0(sim_folder, '/data/field_stage.csv'))
field_obs <- read.csv(field_temp)

var = 'temp'         # variable to which we apply the calibration procedure
path = getwd()       # simulation path/folder
nml_file = nml_file  # path of the nml configuration file that you want to calibrate on
glm_file = nml_file # # path of the gml configuration file
# which parameter do you want to calibrate? a sensitivity analysis helps
calib_setup <- data.frame('pars' = as.character(c('wind_factor','lw_factor','ch','sed_temp_mean',
                                                  'sed_temp_mean',
                                                  'coef_mix_hyp','Kw')),
                          'lb' = c(0.7,0.7,5e-4,3,8,0.4,0.1),
                          'ub' = c(2,2,0.002,8,20,0.6,0.8),
                          'x0' = c(1,1,0.0013,5,13,0.5,0.3))
print(calib_setup)
glmcmd = NULL        # command to be used, default applies the GLM3r function
# glmcmd = '/Users/robertladwig/Documents/AquaticEcoDynamics_gfort/GLM/glm'        # custom path to executable
# Optional variables
first.attempt = TRUE # if TRUE, deletes all local csv-files that stores the 
#outcome of previous calibration runs
period = get_calib_periods(nml_file, ratio = 2) # define a period for the calibration, 
# this supports a split-sample calibration (e.g. calibration and validation period)
# the ratio value is the ratio of calibration period to validation period
print(period)
scaling = TRUE       # scaling of the variables in a space of [0,10]; TRUE for CMA-ES
verbose = TRUE
method = 'CMA-ES'    # optimization method, choose either `CMA-ES` or `Nelder-Mead`
metric = 'RMSE'      # objective function to be minimized, here the root-mean square error
target.fit = 2.0     # refers to a target fit of 2.0 degrees Celsius (stops when RMSE is below that)
target.iter = 600    # refers to a maximum run of calibration iterations (stops after that many runs)
plotting = TRUE      # if TRUE, script will automatically save the contour plots
output = out_file    # path of the output file
field_file = field_temp # path of the field data
conversion.factor = 1 # conversion factor for the output, e.g. 1 for water temp.
file.copy(nml_file, "glm4.nml", overwrite = TRUE)
file.copy(nml_file, "glm3.nml", overwrite = TRUE)


calibrate_sim(var = 'temp', 
              path = sim_folder, 
              field_file = field_temp, 
              nml_file = 'glm3.nml', 
              glm_file = 'glm3.nml', 
              calib_setup = calib_setup, 
              #glmcmd = NULL, 
              first.attempt = TRUE, 
              period = period, 
              scaling = TRUE, method = 'CMA-ES', metric = 'RMSE', 
              target.fit = 2.0, 
              target.iter = 600, 
              plotting = TRUE, 
              output = output, 
              verbose = TRUE,
              conversion.factor = 1)


# copy calibrated nml file into original nml file
file.copy("glm3.nml", nml_file, overwrite = TRUE)
