## README for GLM Raw_Data files

last modified 28September2020 by B. Steele (steeleb@caryinstitute.org)

files in this folder are the result of collation by B. Steele from a number of sources
	for Lake Sunapee GLM modeling 
	
files were created from the R program 'Scripts_Data/GLM_sunapee_nutrientcollation_update.R'


# Inflow Chemistry
inflowchem_onevalperday_21Sept2020 <- all chemistry data for streams available 1986-2019. 
	Data have been aggregated to a mean value where multiple values per parametere per stream
	per day were recorded. Data provenance varies. Notes of attribution are within the R program
	file.
	
	
# For Calibration:
chlorophylla_1986-2019_v28Sept2020 <- all chlorophyll data for years 1986-2019. Data provenence
	listed in datasource column, the primary sources are the LSPA's LMP files and the trophic
	reports provided by Woody.

lake_chem_1986-2019_v28Sept2020 <- any available chemistry/nutrient data for Sunapee for years
	1986-2019. Data provenece listed in datasource column, the primary sources are the LSPA's 
	LMP files and the trophic reports provided by Woody.

LMP_lowresDOTemp_1986-2019_v28Sept2020 <- any available low-resolution dissolved oxygen or 
	temperature data (from profiles) for Sunapee for years 1986-2019. Data provenece listed in 
	datasource column, the primary sources are the LSPA's LMP files and the trophic reports 
	provided by Woody.
	
	
column header definitions
		date			date of observation in yyyy-mm-dd format
		loc				site of observation
		sitetype		littoral or pelagic
		depth_m			depth of observation in meters
		depth.measurement	how the depth was derived
					actual - reported depth by datasource
					assumed - 0.1m depth assumed for chlA data without depth reported
					mean - in the LMP database (from the LSPA), prior to 2000 there were only layers
						reported in the database, not explicit depths. Data was summarized by
						site, layer and depth to provide a mean value for littoral sites without
						explicit depth data. per CCC, these samples are a hodge-podge of surface
						or integrated samples. see the file 'layer_depth_summary.csv'
					median - in the LMP database (from the LSPA), prior to 2000 there were only layers
						reported in the database, not explicit depths. Data was summarized by
						site, layer and depth to provide a median value for pelagic sites without
						explicit depth data. see the file 'layer_depth_summary.csv'
		layer			reported lake layer that the sample was taken at. likely unnecessary for calibration
		parameter		variable observed (see full list of variables listed in the file 'varnames.csv') with
						unit
		value			observed value of the varible listed
		datasource		source of data
					LMP DO - data from the LSPA's LMP database (oxygen and temperature as profiles) (v27Jul2020)
					LMP chem  - data from the LSPA's LMP database (hydrogen ion, alkalinity, total phosphorus, 
						conductivity, turbidity) (v27Jul2020)
					LMP bio - data from the LSPA's LMP database (secchi depth and chlorophyll a) (v27Jul2020)
					Trophic Reports Woody - from DES trophic reports via Woody (LSPA)
		




