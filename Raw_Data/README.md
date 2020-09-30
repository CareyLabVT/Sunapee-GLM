#### README for GLM Raw_Data files

last modified 30September2020 by B. Steele (steeleb@caryinstitute.org)

files in this folder are the result of collation by B. Steele from a number of sources for Lake Sunapee GLM modeling 
	
'Inflow' and 'Lake' files were created from the R program 'Scripts_Data/GLM_sunapee_nutrientcollation_update.R'
'HyspographyStorage' files were created in the R program 'Scripts_Data/CNH-GLM_sunapee_volumearea_82-19_v29Sept2020.R'


# Inflow
*inflowchem_onevalperday_21Sept2020* <- all chemistry data for streams available 1986-2019. 
	Data have been aggregated to a mean value where multiple values per parameter per stream
	per day were recorded. Data provenance varies. Notes of attribution are within the R program
	file.
	
	* date: date of observation in yyyy-mm-dd format	
	* stream_no: stream where data obtained (stream number from LSPA LMP files)
	* DOC_rep: number of values aggregated to mean in 'DOC_mmolm3' field	
	* DOC_mmolm3: dissolved organic carbon in millimols per meter cubed	
	* DOC_flag: lists pertinent flags, 'suspect' observations should be handled with care	
	* TN_rep: number of values aggregated to mean in 'TN_mmolm3'	
	* TN_mmolm3: total nitrogen in millimols per meter cubed	
	* TN_flag: lists pertinent flags, 'suspect' observations should be handled with care	
	* TP_rep: number of values aggregated to mean in 'TP_mmolm3'	
	* TP_mmolm3: total phosphorus in millimols per miter cubed
	* TP_flag: lists pertinent flags, 'suspect' observations should be handled with care
	
	
# Lake

*chlorophylla_1986-2019_v28Sept2020* <- all chlorophyll data for years 1986-2019. Data provenence
	listed in datasource column, the primary sources are the LSPA's LMP files and the trophic
	reports provided by Woody.
	
	* date: date of observation in yyyy-mm-dd format	
	* station: site of observation	
	* depth_m: depth of observation or measurement in meters
	* parameter: parameter measured or observed with unit
	* value: value of parameter measured or observed	
	* depth.measurement: how depth was derived
		* actual - reported depth by datasource
		* assumed - 0.1m depth assumed for chlA data without depth reported
		* mean - in the LMP database (from the LSPA), prior to 2000 there were only layers
						reported in the database, not explicit depths. Data was summarized by
						site, layer and depth to provide a mean value for littoral sites without
						explicit depth data. per CCC, these samples are a hodge-podge of surface
						or integrated samples. see the file 'layer_depth_summary.csv'
		* median - in the LMP database (from the LSPA), prior to 2000 there were only layers
						reported in the database, not explicit depths. Data were summarized by
						site, layer and depth to provide a median value for pelagic sites without
						explicit depth data. see the file 'layer_depth_summary.csv'
	* datasource: source of data
		* LMP DO - data from the LSPA's LMP database (oxygen and temperature as profiles) (v27Jul2020)
		* LMP chem  - data from the LSPA's LMP database (hydrogen ion, alkalinity, total phosphorus, 
			conductivity, turbidity) (v27Jul2020)
		* LMP bio - data from the LSPA's LMP database (secchi depth and chlorophyll a) (v27Jul2020)
		* Trophic Reports Woody - from DES trophic reports via Woody (LSPA)	
	* flag: lists pertinent flags, 'suspect' observations should be handled with care	

*lake_chem_1986-2019_v28Sept2020* <- any available chemistry/nutrient data for Sunapee for years
	1986-2019. Data provenece listed in datasource column, the primary sources are the LSPA's 
	LMP files and the trophic reports provided by Woody.

	* date: date of observation in yyyy-mm-dd format	
	* station: site of observation	
	* depth_m: depth of observation or measurement in meters
	* parameter: parameter measured or observed with unit
	* value: value of parameter measured or observed	
	* depth.measurement: how depth was derived
		* actual - reported depth by datasource
		* assumed - 0.1m depth assumed for chlA data without depth reported
		* mean - in the LMP database (from the LSPA), prior to 2000 there were only layers
						reported in the database, not explicit depths. Data was summarized by
						site, layer and depth to provide a mean value for littoral sites without
						explicit depth data. per CCC, these samples are a hodge-podge of surface
						or integrated samples. see the file 'layer_depth_summary.csv'
		* median - in the LMP database (from the LSPA), prior to 2000 there were only layers
						reported in the database, not explicit depths. Data were summarized by
						site, layer and depth to provide a median value for pelagic sites without
						explicit depth data. see the file 'layer_depth_summary.csv'
	* datasource: source of data
		* LMP DO - data from the LSPA's LMP database (oxygen and temperature as profiles) (v27Jul2020)
		* LMP chem  - data from the LSPA's LMP database (hydrogen ion, alkalinity, total phosphorus, 
			conductivity, turbidity) (v27Jul2020)
		* LMP bio - data from the LSPA's LMP database (secchi depth and chlorophyll a) (v27Jul2020)
		* Trophic Reports Woody - from DES trophic reports via Woody (LSPA)	
	* sitetype: indicates whether site is littoral or pelagic	

*LMP_lowresDOTemp_1986-2019_v28Sept2020* <- any available low-resolution dissolved oxygen or 
	temperature data (from profiles) for Sunapee for years 1986-2019. Data provenece listed in 
	datasource column, the primary sources are the LSPA's LMP files and the trophic reports 
	provided by Woody.
	
	* station: site of observation	
	* date: date of observation in yyyy-mm-dd format	
	* depth_m: depth of observation or measurement in meters
	* flag: lists pertinent flags, 'suspect' observations should be handled with care	
	* parameter: parameter measured or observed with unit
	* value: value of parameter measured or observed	
	* depth.measurement: how depth was derived
		* actual - reported depth by datasource
		* assumed - 0.1m depth assumed for chlA data without depth reported
		* mean - in the LMP database (from the LSPA), prior to 2000 there were only layers
						reported in the database, not explicit depths. Data was summarized by
						site, layer and depth to provide a mean value for littoral sites without
						explicit depth data. per CCC, these samples are a hodge-podge of surface
						or integrated samples. see the file 'layer_depth_summary.csv'
		* median - in the LMP database (from the LSPA), prior to 2000 there were only layers
						reported in the database, not explicit depths. Data were summarized by
						site, layer and depth to provide a median value for pelagic sites without
						explicit depth data. see the file 'layer_depth_summary.csv'
	* sitetype: indicates whether site is littoral or pelagic	
	* datasource: source of data
		* LMP DO - data from the LSPA's LMP database (oxygen and temperature as profiles) (v27Jul2020)
		* LMP chem  - data from the LSPA's LMP database (hydrogen ion, alkalinity, total phosphorus, 
			conductivity, turbidity) (v27Jul2020)
		* LMP bio - data from the LSPA's LMP database (secchi depth and chlorophyll a) (v27Jul2020)
		* Trophic Reports Woody - from DES trophic reports via Woody (LSPA)	

*secchi_1986-2019_v28Sept2020.csv* <- this file lists secchi depths measured in Sunapee at all sites. Data
	provenence listed in the datasource column.
	
	* date: date of observation in yyyy-mm-dd format	
	* station: site of observation	
	* parameter: parameter measured or observed with unit
	* value: value of parameter measured or observed	
	* datasource: source of data
		* LMP DO - data from the LSPA's LMP database (oxygen and temperature as profiles) (v27Jul2020)
		* LMP chem  - data from the LSPA's LMP database (hydrogen ion, alkalinity, total phosphorus, 
			conductivity, turbidity) (v27Jul2020)
		* LMP bio - data from the LSPA's LMP database (secchi depth and chlorophyll a) (v27Jul2020)
		* Trophic Reports Woody - from DES trophic reports via Woody (LSPA)	
	* flag: lists pertinent flags, 'suspect' observations should be handled with care	


# HypsographyStorage

Historical dam/lake depth calculations were made in the program dam_collation.R

Hyspography and Storage calulations were made and applied in the program GLM_sunapee_volumearea_82-19_v29Sept2020.R

*historical area and volume according to dam depth.csv* - this file contains daily lake depth, area, volume on a daily
	timestep for 1982-2019
		
		* date: calendar date in format yyyy-mm-dd
		* lake_depth_m: depth of the lake according to the DES dam data (calculated as: 'lake_level_asl_m' lake level 
		in meters above sea level minus 299.443m, the lowest depth of the true DEM for Lake Sunapee)
		* lake_level_asl_m: lake level in meters above sea level (calculated as the sum of local lake elevation provided by 
		the DES in feet and 1082.65 feet then multiplied by 0.3048 to convert to meters)
		* dataflag: indication of data manipulation - '2' is presumed transcription error that was corrected; '3' depth 
		was interpolated from surrounding measurements (linear interpolation)
		* depth_index: this column is the result of rounding lake_depth_m to a single value after decimal in order to join
		with storage information - see 'hypsography_forstoragecalc_matrix_0p1m_29Sept2020.csv'
		* area_m2: surface area of the lake at the given depth_index in meters squared (according to the true DEM)
		* volume_m3: volume/storage of the lake at the given depth_index in meters cubed (according to the true DEM)

*sunapee_hypsography_matrix_0p5m_29Sept2020.csv* - this is the hypsography matrix in 0.5m intervals for 'depths' (according to 
	the true DEM) up to 33.5m.
	
		* .id: reference column used to subset DEM data
		* act_depth_m: depth of the lake in meters
		* area_m2: area covered by lake at 'act_depth_m' 
	
*hypsography_forstoragecalc_matrix_0p1m_29Sept2020.csv* - this can be associated with the lake depth via the DES dam data
	to calculate storage when the lake depth is between 32.5-34.5m	in 0.1m increments
		
		* depth_index: column representing the depth of the lake at any given time (historically, this has ranged from 
		32.8 through 34.3 meters over time, included a few additional increments just in case.
		* area_m2: surface area of the lake at the given depth_index in meters squared (according to the true DEM)
		* volume_m3: volume/storage of the lake at the given depth_index in meters cubed (according to the true DEM)

