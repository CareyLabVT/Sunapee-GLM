# run sunapee glm with aed

# install these packages:
# install.packages("devtools")
# require(devtools)
# devtools::install_github("robertladwig/GLM3r", ref = "v3.1.1")
# devtools::install_github("GLEON/GLM3r")
# devtools::install_github("hdugan/glmtools", ref = "ggplot_overhaul")
# install.packages("rLakeAnalyzer")
# install.packages("tidyverse")

# we will need these packages
library(glmtools)
library(GLM3r)
library(rLakeAnalyzer)
library(tidyverse)
library(lubridate)

# check out which R version we're currently using
glm_version()

#### Example 1: reading the namelist file into R  ####
glm_template = 'glm3_wAED.nml' 
sim_folder <- getwd()
out_file <- file.path(sim_folder, "output","output_aed.nc")
field_data <- file.path(sim_folder,"data", "formatted-data",  "field_temp_oxy_noon_obs.csv")
file.copy(glm_template, 'glm3.nml', overwrite = TRUE)
nml_file <- file.path(sim_folder, 'glm3.nml')

nml <- read_nml(nml_file)
# nml$wq_setup <- NULL
write_nml(nml, nml_file)

# run GLM
GLM3r::run_glm(sim_folder, verbose = T)

# visualize change of surface water temp. over time
surface_temp <- get_var(file = out_file, 
                        var_name = 'temp',
                        reference = 'surface',
                        z_out = 2)
ggplot(surface_temp, aes(DateTime, temp_2)) +
  geom_line() +
  ggtitle('Surface water temperature') +
  xlab(label = '') + ylab(label = 'Temp. (deg C)') +
  theme_minimal()

# visualize change of bottom water temp. over time
bottom_temp <- get_var(file = out_file, 
                       var_name = 'temp',
                       reference = 'surface',
                       z_out = 20)
ggplot(bottom_temp, aes(DateTime, temp_20)) +
  geom_line() +
  ggtitle('Bottom water temperature') +
  xlab(label = '') + ylab(label = 'Temp. (deg C)') +
  theme_minimal()

plot_var(nc_file = out_file, 
         var_name = 'OXY_oxy')

