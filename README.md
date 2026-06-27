---
title: "README -- Data and Code for: \"DETERring Deforestation in the Amazon: Environmental Monitoring and Law Enforcement\""
subtitle: "openicpsr-132281"
author: "Juliano Assunção, Clarissa Gandour, Romero Rocha"
date: DEC/17/2021
output:
  html_document: default
  pdf_document: default
knit: (function(inputFile, encoding) {
  rmarkdown::render(inputFile, encoding = encoding, output_format = "all") })
---


Overview 
----------------------------

The code in this replication package cleans the raw data for each data source (approximately 20 sources), builds intermediate datasets, extracts the relevant information specifically for the project, combines it, and generates the results using R and Stata. Two master files (one for the R scripts and the other for the Stata do-files) run all of the code to generate the data for the 3 figures and 4 tables in the paper (2 figures and 3 tables in the online appendix). The replicator should expect the code to run for about 22 days divided into 14 days in the cleaning part, 7 days in the building part, 4 hours in the extraction/merge part, and less than 1 hour in the final analysis part. The majority of the individual scripts are fast (few seconds or minutes) but there a few scripts that require a very long time of processing (one of them is responsible for 7 days for example), specific times for individual scripts are reported in the master files. All the data is provided, from raw to final including intermediate, so it is possible to skip any individual script.

Note that we provide a Code Ocean replication capsule (provisional DOI: 10.24433/CO.5098352.v1) for the analysis, which includes code, data, and necessary software for a full reproducible run.


Description of Files Structure 
----------------------------

1. `"README.md"`: a markdown file used to generate `"README.html"`.
 
2. `"README.html"`: This document. Provides the necessary information about the structure of the replication folder, data sources and access, computational requirements, and ultimately explains how to fully replicate the analysis presented in the paper.
 
3. `"code`: a folder containing all scripts to clean, build, merge, and prepare the data for analysis.

    a. `"code/raw2clean"`: R scripts that clean the raw data on input and save on the output for each dataset.
    b. `"code/built"`: R scripts that combine different cleaned datasets.
    c. `"code/projectSpecific"`: R scripts that select the information relevant for this project from the built and raw2clean outputs and creates the sample for analysis. Stata do-files that prepare the data for analysis (separated into annual and monthly datasets for analysis).
    e. `"code/_functions"`: auxiliary folder with custom R functions used in multiple R scripts. 
    f. `"code/config_proj.do"`: Stata do-file to create global file paths and adjust ado path.
  
4. `"data"`: a folder containing data in a variety of formats: raw, clean, and built datasets.

    a. `"data/raw2clean"`: raw datasets (`"/input"`) and cleaned (`"/output"`) folder separated by theme/source/geographic scope and accompanied by a `"documentation"` folder containing at least a `"_metadata.txt"` file with some general information and instructions on how to obtain the data from original source if a direct link is not available.
    b. `"data/built"`: intermediate folder separated by theme/source/geographic scope to combine different cleaned datasets.
    c. `"data/projectSpecific"`: datasets containing the relevant variables for this project, sample creation, and merged panel for analysis.
    e. `"data/_temp"`: temporary files output (to be filled when running some .R scripts).

5. `"deter_proj.Rproj"`: R project to automatically adjust file path references. Always open RStudio from this file when running any R script.

6. `"deter_proj.stpr"`: Stata project to automatically set the root directory file path. Always open Stata from this file when running any do-file. 

7. `".checkpoint"`: an empty folder to be filled with all the necessary R packages with the correct version. It is an independent library to guarantee the use of the same versions of the packages and avoid changing personal libraries.

8. `"ado"`: a folder containing Stata user-written libraries to guarantee the same version is used.

9. `"LICENSE.txt"`: a text file with a dual-license setup.


Data Availability and Provenance Statements
----------------------------

### Statement about Rights

- [X] I certify that the authors of the manuscript have legitimate access to and permission to use the data used in this manuscript. 


### License for Data 

The data is licensed under a Creative Commons Attribution 4.0 International Public License. See [LICENSE.txt](LICENSE.txt) for details.

### Summary of Availability

The data used to support the findings of this study comes from multiple data sources, all of them are publicly available online, and have been deposited in the AEA Data and Code Repository (Assunção, Gandour, and Rocha, 2021). Each raw dataset is listed and described in more detail below. Access to download from the original source is guaranteed by either providing a persistent link, using the Save a Page feature from Archive.org, pointing directly to the data download, or by providing the original link and directions on where to find more detailed instructions:

### Details on each Data Source

* Brazilian Municipalities Division (IBGE, 2007)
    + input file path (raw data): `"data/raw2clean/administrative/territorial_ibge/brazil/input/2007"`
    + source: Brazilian Institute for Geography and Statistics (IBGE)
    + original link: [Downloaded on MAR/29/2017](ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2007/escala_2500mil/proj_policonica_sad69/brasil/)
    * web archive link: [Archived on SEP/08/2020](https://web.archive.org/web/20200908153308/ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2007/escala_2500mil/proj_policonica_sad69/brasil/55mu2500psd.zip)
    * description: shapefile of 2007 administrative municipalities boundaries 
    * notes: the shapefile is composed of multiple files with name pattern `"55mu2500gsd"`
    * provided: yes

* Legal Amazon Division (Ibama, 2007)
    + input file path (raw data): `"data/raw2clean/administrative/territorial_ibge/legal_amazon/input"`
    + source: Brazilian Institute for the Environment and Renewable Natural Resources (Ibama)
    + original link: [Downloaded on FEB/01/2013](http://siscom.ibama.gov.br/shapes/) (not working use archive link below)
    * web archive link: [Archived on JUL/21/2012](https://web.archive.org/web/20120721033244/http://siscom.ibama.gov.br/shapes//AMAZONIA_LEGAL_LIMITE.zip)
    * description: shapefile of legal amazon administrative boundaries 
    * notes: the shapefile is composed of multiple files with name pattern `"AMAZONIA_LEGAL_LIMITE"`
    * provided: yes
   
* Municipal Crop Production - selected crops (PAM) (IBGE, 2003-2017)
    + input file path (raw data): `"data/raw2clean/agriculture/pam_ibge/input"`
    + source: Brazilian Institute for Geography and Statistics (IBGE) 
    + original link: [Downloaded on JUN/06/2017](https://sidra.ibge.gov.br/tabela/1612) (more detailed instructions on how to download at `"data/raw2clean/agriculture/pam_ibge/documentation/_metadata.txt"`)
    * web archive link: not available
    * description: tabular data - crop-specific production 
    * notes: input contains one file for each crop with name pattern `"pam_*crop*_00_15.csv"`
    * provided: yes
   
* Municipal Crop Production - total production (PAM) (IBGE, 2001-2019)
    + input file path (raw data): `"data/raw2clean/agriculture/pam_ibge/input"`
    + source: Brazilian Institute for Geography and Statistics (IBGE) 
    + original link: [Downloaded on MAY/13/2019](https://sidra.ibge.gov.br/tabela/5457) (more detailed instructions on how to download at `"data/raw2clean/agriculture/pam_ibge/documentation/_metadata.txt"`)
    * web archive link: not available
    * description: tabular data - total production for temporary and permanent crops
    * notes: input file name `"pam_total_00_17.csv"`
    * provided: yes
   
* Municipal Livestock Survey (PPM) (IBGE, 2014-2018)
    + input file path (raw data): `"data/raw2clean/agriculture/ppm_ibge/input"`
    + source: Brazilian Institute for Geography and Statistics (IBGE) 
    + original link: [Downloaded on MAR/03/2018](https://sidra.ibge.gov.br/tabela/3939) (more detailed instructions on how to download at `"data/raw2clean/agriculture/ppm_ibge/documentation/_metadata.txt"`)
    * web archive link: not available
    * description: tabular data - livestock by types
    * notes: input file name `"pam_total_00_17.csv"`
    * provided: yes    
   
* Brazilian Biomes Division (IBGE, 2004)
    + input file path (raw data): `"data/raw2clean/geography/biomes_ibge/input"`
    + source: Brazilian Ministry of the Environment (MMA) [distributor] and Brazilian Institute for Geography and Statistics (IBGE) [publisher]
    + original link: [Downloaded on JAN/26/2016](http://mapas.mma.gov.br/i3geo/datadownload.htm) (more detailed instructions on how to download at `"data/raw2clean/geography/biomes_ibge/documentation/_metadata.txt"`)
    * web archive link: not able to archive - error
    * description: shapefile of Brazilian biomes boundaries 
    * notes: the shapefile is composed of multiple files with name pattern `"bioma"`
    * provided: yes
    
* Cloud Fraction (TERRA/MODIS) - MODIS Atmosphere L3 Monthly Product (V 6.01) (Platnick, King, and Hubanks, 2017)
    + input file path (raw data): `"data/raw2clean/geography/clouds_nasa/input"`
    + source: NASA MODIS Adaptive Processing System obtained through Giovanni online data system, developed and maintained by the NASA Goddard Earth Sciences Data and Information Services Center (NASA GES DISC)
    + original link: [Downloaded on JUL/21/2020](https://giovanni.gsfc.nasa.gov/giovanni/#service=MpAn&starttime=2000-08-01T00:00:00Z&endtime=2016-07-31T23:59:59Z&bbox=-75.94,-34.45,31.64,7.73&data=MOD08_M3_6_1_Cloud_Fraction_Mean_Mean&dataKeyword=cloud%20fraction) (more detailed instructions on how to download at `"data/raw2clean/geography/clouds_nasa/documentation/_metadata.txt"`)
    * web archive link: [Retrieved on SEP/23/2020](dx.doi.org/10.5067/MODIS/MOD08_M3.061) (documentation page only)
    * description: netCDF files with monthly-mean cloud fraction interpolated to a 1 by 1-degree grid resolution 
    * notes: file pattern `"g4.subsetted.MOD08_M3_6_1_Cloud_Fraction_Mean_Mean.YYYYMMDD.75W_34S_31W_7N"`
    * provided: yes

* CPC Global Temperature - Maximum (NOAA-CPC, 2018a)
    + input file path (raw data): `"data/raw2clean/geography/weather_CPCG/input"`
    + source: National Oceanic and Atmospheric Administration, Climate Prediction Center (NOAA-CPC) provided by Physical Sciences Laboratory (NOAA-PSL)
    + original link: [Downloaded on MAY/17/2018](https://psl.noaa.gov/cgi-bin/db_search/DBSearch.pl?Dataset=CPC+Global+Temperature&Statistic=Maximum&Variable=Maximum+Temperature&group=0&submit=Search) (more detailed instructions on how to download at `"data/raw2clean/geography/weather_CPCG/documentation/_metadata.txt"`)
    * web archive link: [Archived on SEP/10/2020](https://web.archive.org/web/20200910172109/https://psl.noaa.gov/data/gridded/data.cpc.globaltemp.html) (documentation only)
    * description: netCDF files with daily maximum temperature (0.5 by 0.5 degree grid resolution) 
    * notes: input file name pattern `"CPCG_temperature_max_YYYY_YYYY"`
    * provided: yes
  
* CPC Global Temperature - Minimum (NOAA-CPC, 2018b) 
    + input file path (raw data): `"data/raw2clean/geography/weather_CPCG/input"`
    + source:National Oceanic and Atmospheric Administration, Climate Prediction Center (NOAA-CPC) provided by Physical Sciences Laboratory (NOAA-PSL) 
    + original link: [Downloaded on JUN/11/2018](https://psl.noaa.gov/cgi-bin/db_search/DBSearch.pl?Dataset=CPC+Global+Temperature&Statistic=Minimum&Variable=Minimum+Temperature&group=0&submit=Search) (more detailed instructions on how to download at `"data/raw2clean/geography/weather_CPCG/documentation/_metadata.txt"`)
    * web archive link: [Archived on SEP/10/2020](https://web.archive.org/web/20200910172109/https://psl.noaa.gov/data/gridded/data.cpc.globaltemp.html) (documentation only)
    * description: netCDF files with daily maximum temperature (0.5 by 0.5 degree grid resolution) 
    * notes: input file name pattern `"CPCG_temperature_min_YYYY_YYYY"`
    * provided: yes 
    
* CPC Global Precipitation (NOAA-CPC, 2018c)
    + input file path (raw data): `"data/raw2clean/geography/weather_CPCG/input"`
    + source: National Oceanic and Atmospheric Administration, Climate Prediction Center (NOAA-CPC) provided by Physical Sciences Laboratory (NOAA-PSL) 
    + original link: [Downloaded on MAY/17/2018](https://psl.noaa.gov/cgi-bin/db_search/DBSearch.pl?Dataset=CPC+Global+Precipitation&Statistic=Total&Variable=Precipitation&group=0&submit=Search) (more detailed instructions on how to download at `"data/raw2clean/geography/weather_CPCG/documentation/_metadata.txt"`)
    * web archive link: [Archived on SEP/10/2020](https://web.archive.org/web/20200910170401/https://psl.noaa.gov/data/gridded/data.cpc.globalprecip.html) (documentation only)
    * description: netCDF files with daily precipitation (0.5 by 0.5 degree grid resolution) 
    * notes: input file name pattern `"CPCG_precipitation_YYYY_YYYY"`
    * provided: yes
    
* Precipitation NCEP-DOE Reanalysis 2 (NOAA-NCEP, 2019)
    + input file path (raw data): `"data/raw2clean/geography/weather_ncepDoeReanalysis/input"`
    + source: National Oceanic and Atmospheric Administration, National Centers for Environmental Prediction (NOAA-NCEP) provided by provided by Physical Sciences Laboratory (NOAA-PSL)
    + original link: [Downloaded on APR/24/2019](https://psl.noaa.gov/data/gridded/data.ncep.reanalysis2.surface.html)
    * web archive link: [Archived on SEP/10/2020](https://web.archive.org/web/20200910180228/ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis2.derived/surface/pr_wtr.eatm.mon.mean.nc)
    * description: netCDF file with mean monthly precipitation (2.5 by 2.5-degree grid resolution) 
    * notes: input file name `"pr_wtr.eatm.mon.mean"`
    * provided: yes       
    
* Terrestrial Air Temperature (V 5.01) (Matsuura and Willmott, 2018a)
    + input file path (raw data): `"data/raw2clean/geography/weather_uniDelaware/input"`
    + source: Matsuura and Willmott (2018)
    + original link: [Downloaded on JUL/11/2019](http://climate.geog.udel.edu/~climate/html_pages/download.html)
    * web archive link: [Archived on SEP/10/2020](https://web.archive.org/web/20200910183757/http://climate.geog.udel.edu/~climate/html_pages/Global2017/air_temp_2017.tar.gz)
    * description: annual table files with monthly air temperature (0.5 by 0.5-degree grid resolution) 
    * notes: input file name `"air_temp.YYYY"`
    * provided: yes   
    
* Terrestrial Precipitation (V 5.01) (Matsuura and Willmott, 2018b)
    + input file path (raw data): `"data/raw2clean/geography/weather_uniDelaware/input"`
    + source: Matsuura and Willmott (2018)
    + original link: [Downloaded on JUL/11/2019](http://climate.geog.udel.edu/~climate/html_pages/download.html)
    * web archive link: [Archived on SEP/10/2020](https://web.archive.org/web/20200910184200/http://climate.geog.udel.edu/~climate/html_pages/Global2017/precip_2017.tar.gz)
    * description: annual table files with monthly precipitation (0.5 by 0.5-degree grid resolution) 
    * notes: input file name `"precip.YYYY"`
    * provided: yes

 * DETER Alerts (INPE, 2017b)
    + input file path (raw data): `"data/raw2clean/land_cover/deter_inpe/input"`
    + source: Brazilian Institute for Space Research (INPE) 
    + original link: [Downloaded on 2016-2018](http://www1.dpi.inpe.br/obt/deter/dados/) (more detailed instructions on how to download at `"data/raw2clean/land_cover/deter_inpe/documentation/_metadata.txt"`)
    * web archive link: [Archived on FEB/03/2020](https://web.archive.org/web/20200203030335/http://www.obt.inpe.br/OBT/assuntos/programas/amazonia/deter/deter) (main page only)
    * description: shapefiles with deforestation/degradation hotspots in the Brazilian Legal Amazon
    * notes: the shapefiles are composed by multiple files with varying patterns - see  
    `"code/raw2clean/land_cover/deter_inpe/deter_raw2clean_alerts.R"` for more information
    * provided: yes, but in a zipped folder    
    
 * DETER Clouds (INPE, 2017c)
    + input file path (raw data): `"data/raw2clean/land_cover/deter_inpe/input"`
    + source: Brazilian Institute for Space Research (INPE)  
    + original link: [Downloaded on 2016-2018](http://www1.dpi.inpe.br/obt/deter/dados/) (more detailed instructions on how to download at   
    `"data/raw2clean/land_cover/deter_inpe/documentation/_metadata.txt"`)
    * web archive link: [Archived on FEB/03/2020](https://web.archive.org/web/20200203030335/http://www.obt.inpe.br/OBT/assuntos/programas/amazonia/deter/deter) (main page only)
    * description: shapefiles with cloud coverage in the Brazilian Legal Amazon
    * notes: the shapefiles are composed by multiple files with varying patterns - see   
    `"code/raw2clean/land_cover/deter_inpe/deter_raw2clean_clouds.R"` for more information
    * provided: yes, but in a zipped folder    

 * PRODES Legal Amazon Land Cover (INPE, 2017a)
    + input file path (raw data): `"data/raw2clean/land_cover/prodes_inpe/input"`
    + source: Brazilian Institute for Space Research (INPE)  
    + original link: [Downloaded on SEP/15/2020](http://www.dpi.inpe.br/prodesdigital/prodesmunicipal.php) (main page only)
    * web archive link: Archived on SEP/15/2020 (one link per year of input) [2000](https://web.archive.org/web/20200915164422/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2000&estado=&ordem=DESMATAMENTO2000&type=tabela&output=txt);
[2001](https://web.archive.org/web/20200915164614/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2001&estado=&ordem=DESMATAMENTO2001&type=tabela&output=txt&);
[2002](https://web.archive.org/web/20200915164920/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2002&estado=&ordem=DESMATAMENTO2002&type=tabela&output=txt);
[2003](https://web.archive.org/web/20200915165014/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2003&estado=&ordem=DESMATAMENTO2003&type=tabela&output=txt);
[2004](https://web.archive.org/web/20200915165038/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2004&estado=&ordem=DESMATAMENTO2004&type=tabela&output=txt);
[2005](https://web.archive.org/web/20200915165211/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2005&estado=&ordem=DESMATAMENTO2005&type=tabela&output=txt);
[2006](https://web.archive.org/web/20200915165249/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2006&estado=&ordem=DESMATAMENTO2006&type=tabela&output=txt);
[2007](https://web.archive.org/web/20200915165303/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2007&estado=&ordem=DESMATAMENTO2007&type=tabela&output=txt);
[2008](https://web.archive.org/web/20200915165337/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2008&estado=&ordem=DESMATAMENTO2008&type=tabela&output=txt);
[2009](https://web.archive.org/web/20200915165353/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2009&estado=&ordem=DESMATAMENTO2009&type=tabela&output=txt);
[2010](https://web.archive.org/web/20200915165427/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2010&estado=&ordem=DESMATAMENTO2010&type=tabela&output=txt);
[2011](https://web.archive.org/web/20200915165439/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2011&estado=&ordem=DESMATAMENTO2011&type=tabela&output=txt);
[2012](https://web.archive.org/web/20200915165504/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2012&estado=&ordem=DESMATAMENTO2012&type=tabela&output=txt);
[2013](https://web.archive.org/web/20200915165526/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2013&estado=&ordem=DESMATAMENTO2013&type=tabela&output=txt);
[2014](https://web.archive.org/web/20200915165551/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2014&estado=&ordem=DESMATAMENTO2014&type=tabela&output=txt);
[2015](https://web.archive.org/web/20200915165615/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2015&estado=&ordem=DESMATAMENTO2015&type=tabela&output=txt);
[2016](https://web.archive.org/web/20200915165626/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2016&estado=&ordem=DESMATAMENTO2016&type=tabela&output=txt)
    * description: land cover at the municipality level
    * notes: one input .txt file per year
    * provided: yes
    
* Agricultural Commodity Prices (SEAB-PR) (SEAB-PR, 2019)
    + input file path (raw data): `"data/raw2clean/macro/commodities_seabpr/input"`
    + source: Agriculture and Supply Secretariat of the State of Parana (SEAB-PR)
    + original link: [Downloaded on APR/16/2019](http://www.ipeadata.gov.br) (more detailed instructions on how to download at `"data/raw2clean/macro/commodities_seabpr/documentation/_metadata.txt"`)
    * web archive link: [Archived on SEP/15/2020](https://web.archive.org/web/20200915184800/http://www.ipeadata.gov.br/Default.aspx) (main page only)
    * description: product-specific price data (rice, sugarcane, cassava, corn, soybean, cattle)
    * notes: input file name `"commodities - crop and cattle.csv"` 
    * provided: yes  
    
* Deflator Index (IPA-DI) (FGV/Conj. Econ. - IGP, 2019)
    + input file path (raw data): `"data/raw2clean/macro/deflator_fgv/input"`
    + source: Fundacao Getulio Vargas, Conjuntura Economica - IGP (FGV/Conj. Econ. - IGP)
    + original link: [Downloaded on APR/17/2019](http://www.ipeadata.gov.br) (more detailed instructions on how to download at `"data/raw2clean/macro/deflator_fgv/documentation/_metadata.txt"`)
    * web archive link: [Archived on SEP/15/2020](https://web.archive.org/web/20200915184800/http://www.ipeadata.gov.br/Default.aspx) (main page only)
    * description: deflator monthly index (baseline Aug. 1944 = 100)
    * notes: input file name `"ipa_ep_di_indice.csv"`
    * provided: yes  

* Environmental Sanctions (Fines) (Ibama, 2016)
    + input file path (raw data): `"data/raw2clean/policy/fines_ibama/input"`
    + source: Brazilian Institute for the Environment and Renewable Natural Resources (Ibama)
    + original link: data was obtained upon request via [e-SIC](https://esic.cgu.gov.br/sistema/site/index.html) at the time, but now is publicly available [here](https://servicos.ibama.gov.br/ctf/publico/areasembargadas/ConsultaPublicaAreasEmbargadas.php) (more detailed instructions on how to download at   
    `"data/raw2clean/policy/fines_ibama/documentation/_metadata.txt"`)
    * web archive link: not available
    * description: the history of issued environmental fines
    * notes: original input file name `"amaz_legal_infracao_ambiental_original.xls"` exported as 4 .csv files with pattern `amaz_legal_infracao_ambiental (1-4)"`
    * provided: yes   
   
* Priority Municipalities (MMA, 2017)
    + input file path (raw data): `"data/raw2clean/policy/priorityMuni_mma/input"`
    + source: Brazilian Ministry of the Environment (MMA)
    + original link: [Collected on JAN/08/2018](http://combateaodesmatamento.mma.gov.br/images/conteudo/lista_municipios_prioritarios_AML_2017.pdf)
    * web archive link: [Archived on SEP/15/2020](https://web.archive.org/web/20200915211728/http://combateaodesmatamento.mma.gov.br/images/conteudo/lista_municipios_prioritarios_AML_2017.pdf)
    * description: list of Legal Amazon priority municipalities with entry/exit dates and legal documentation
    * notes: original data only available in pdf   
    (`"data/raw2clean/policy/priorityMuni_mma/input/MMA_muni_priority.pdf"` and   
    `"data/raw2clean/policy/priorityMuni_mma/input/MMA_muni_monitored.pdf"`); dataset built in R script  
    (`"code/raw2clean/policy/priorityMuni_mma/policy_la_prioritymuni_rawBuild.R"`)
    * provided: yes   
    
* Brazilian Protected Areas (CNUC, 2016)
    + input file path (raw data): `"data/raw2clean/policy/protectedAreas_mma/input"`
    + source: Brazilian National Registry for Conservation Units (CNUC), Brazilian Ministry of the Environment (MMA)
    + original links: [Downloaded on MAR/11/2016](http://mapas.mma.gov.br/i3geo/datadownload.htm) (more detailed instructions on how to download at `"data/raw2clean/policy/protectedAreas_mma/documentation/_metadata.txt"`)
    * web archive link: not able to archive - error
    * description: shapefile of Brazilian protected areas boundaries 
    * notes: the shapefile is composed of multiple files with name pattern `"ucstodas"`
    * provided: yes
    
* Brazilian Indigenous Lands (FUNAI) - Demarcation Status History (FUNAI, 2016a)
    + input file path (raw data): `"data/raw2clean/policy/indigenousLands_funaiIsa/input"`
    + source: Brazilian National Native Foundation (FUNAI)
    + original link: not available (see   
    `"data/raw2clean/policy/indigenousLands_funaiIsa/documentation/_metadata"` for more details)
    * web archive link: [Archived on SEP/18/2020](https://web.archive.org/web/20200918123106/http://geoserver.funai.gov.br/geoserver/Funai/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=Funai%3Avw_geo_ti_documentos_sii_sirgas2000&outputFormat=csv) (this link was not available at the time of download, it represents a more recent version)
    * description: table of Brazilian indigenous lands demarcation status history 
    * notes: this table complements the information of the shapefile - name `"Documentos_TI.csv"`
    * provided: yes
   
* Brazilian Indigenous Lands (FUNAI) - Shapefile (FUNAI, 2016b)
    + input file path (raw data): `"data/raw2clean/policy/indigenousLands_funaiIsa/input"`
    + source: FUNAI
    + original link: [Downloaded on JUN/22/2016](http://www.funai.gov.br/index.php/shape) 
    * web archive link: [Archived on SEP/18/2020](https://web.archive.org/web/20200918122942/http://geoserver.funai.gov.br/geoserver/Funai/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=Funai%3Ati_sirgas&outputFormat=SHAPE-ZIP) (this link was not available at the time of download)
    * description: shapefile of Brazilian indigenous lands boundaries 
    * notes: the shapefile is composed of multiple files with name pattern `"ti_sirgas2000"`
    * provided: yes
   
* Brazilian Indigenous Lands (ISA) - Demarcation Status History (ISA, 2016)
    + input file path (raw data): `"data/raw2clean/policy/indigenousLands_funaiIsa/input"`
    + source: Socio-Environmental Institute (ISA)
    + original link: [Downloaded on APR/29/2016](http://ti.socioambiental.org/) (see   
    `"data/raw2clean/policy/indigenousLands_funaiIsa/documentation/_metadata"` for more details)
    * web archive link: [Archived on SEP/18/2020](https://web.archive.org/web/20200716121054/https://terrasindigenas.org.br/) (main page only)
    * description: table of Brazilian indigenous lands demarcation status history using an alternative source to fill missing information in the FUNAI's database
    * notes: data was originally scrapped from the website (stored on   
    `"data/raw2clean/policy/indigenousLands_funaiIsa/input/data_scrappingoutput"`   
    file `"status_history_isa_scrapped.Rdata"`   
    (see `"data/raw2clean/policy/indigenousLands_funaiIsa/documentation/_metadata"` for an alternative method of download)
    * provided: yes    
   


Computational requirements
---------------------------

### Software Requirements
- Stata (code was last run with version 14.2) 
    - `"estout"` (as of 2021-01-07) 
    - `"ivreg2"` (as of 2021-01-07) 
    - `"mdesc"` (as of 2021-01-07) 
    - `"outreg2"` (as of 2021-01-07) 
    - `"xtivreg2"` (as of 2021-01-07)
    - `"ranktest"` (as of 2021-01-07) 
    - `"coefplot"` (as of 2021-02-10)

  - the program `"config_proj.do"` will set globals for directory reference and set ado path to user-written libraries in the project folder `"ado/plus"`. It is automatically sourced within `"code/MASTERFILE.do"`.
  - the file `"deter_proj.stpr"` will set the working directory to the project root (always open Stata from this file).

- R (code was last run with version 3.6.1)
    - `"checkpoint"` (0.4.8)
    - `"tidyverse"` (1.2.1)
    - `"sp"` (1.3-1)
    - `"rgdal"` (1.4-4)
    - `"rgeos"` (0.5-1)
    - `"cleangeo"` (0.2-2)
    - `"raster"` (3.0.2)
    - `"data.table"` (1.12.2)
    - `"ncdf4"` (1.16.1)
    - `"foreach"` (1.4.7)
    - `"doParallel"` (1.0.15)
    - `"doSNOW"` (1.0.18)
    - `"rts"` (1.0-49)
    - `"lubridate"` (1.7.4)
    - `"Hmisc"` (4.2-0)
    - `"reshape"` (0.8.8)
    - `"plyr"` (1.8.4)
    - `"tictoc"` (1.0)
    - `"haven"` (2.1.1)
    - `"spdep"` (1.1-2)
    - `"expp"` (1.2.4)
	- `"maptools"` (0.9-5)
	
  - the file `"code/_functions/setup.R"`" will install all libraries above and its dependencies (using `"checkpoint"` library to ensure reproducibility). It is automatically sourced within any .R script in the project.
  - the file `"deter_proj.Rproj"` will guarantee that the working directory is set to the root of the project (always open RStudio using this file).

### Memory and Runtime Requirements

The code was last run on an **8-core Desktop; Intel Core i7-2600 CPU @ 3.40 GHz processor; 32GB RAM; Windows 10 Pro**. 

Some portions of the code are intensive on RAM and may not run in machines with less than 32GB of RAM.

Some portions of the code run in parallel with intensive CPU use. Set to leave only 1 core free.

Total time of processing should take approximately 22 days.

The majority of the individual scripts are fast (few seconds or minutes) but there a few scripts that require a very long time of processing (there is one that lasts 7 days for example), specific time for individual scripts are reported in the master files.

Total disk size (expected) to be consumed by the project considering everything (including intermediate dataset, libraries, etc.) in an uncompressed format is approximately 6GB (~45.000 files).

Description of programs/code
----------------------------

- `"code/_MASTERFILE.R"` will run individual master files for each folder: 
  - `"code/raw2clean/_masterfile_raw2clean.R"` will run at least one R script to clean each input dataset (20 scripts).
  - `"code/built/_masterfile_build.R"` will transform datasets that are in other levels of aggregation to the municipality level (8 scripts)
  - `"code/projectSpecific/_masterfile_projectSpecific.R"` will construct the base sample, extract the information from each dataset relevant for this paper, construct the variables of interest, merge them with the base sample, and generate panels to be used in Stata (13 scripts).





### License for Code 

The code is licensed under a Modified BSD License. See [LICENSE.txt](LICENSE.txt) for details.


Instructions to Replicators 
---------------------------

- Download replication package.
- Unzip `"data/raw2clean/land_cover/deter_inpe/input.zip"` extracting the files to   
`"data/raw2clean/land_cover/deter_inpe"` in order to fill the existing and empty folder `"data/raw2clean/land_cover/deter_inpe/input"` without creating redundant directory levels.
- Open RStudio using `"deter_proj.Rproj"` to set the working directory to the project root.
- Run `"code/_MASTERFILE.R"` to run all R scripts in sequence (mostly data preparation).
- Access Code Ocean replication capsule (provisional DOI: 10.24433/CO.5098352.v1) for analysis-specific code, data, and documentation.

### Details

- `"code/_functions/_setup.R"`: will be the first script sourced by `"code/_MASTERFILE.R"`, and will install the `"checkpoint"` package, create the project library, and populate it with all needed packages with the correct versions.
  * Use of R version "3.6.1" is highly recommended to guarantee a successful installation of the necessary packages. It can be downloaded [here for Windows](https://cran.r-project.org/bin/windows/base/old/3.6.1/).
  * If you have more than one R version and need to select the 3.6.1 you can follow these [instructions](https://support.rstudio.com/hc/en-us/articles/200486138-Changing-R-versions-for-RStudio-desktop).
  * If you are trying to use a different R version you will need to manually change the line 40 of the script `"code/_functions/_setup.R"` from `"checkpoint::checkpoint(R.version = "3.6.1", snapshotDate = "2019-09-03", checkpointLocation = getwd())"` to   
  `"checkpoint::checkpoint(R.version = "numberOfYourVersion", snapshotDate = "2019-09-03", checkpointLocation = getwd())"`. However, this option is not recommended. For example, we tested it using R version "4.0.2" and it gave an error in the installation of the first package (`"cleangeo"`).
  
- Skipping one individual R program will not prevent others from running correctly, because all intermediate datasets are available. There are only two exceptions that require an additional manual step:
  * If you want to skip `"code/raw2clean/geography/weather_CPCG/geography_br_weather_CPCG_raw2clean.R"` (time of processing: 6 days), unzip `"data/raw2clean/geography/weather_CPCG/output.zip"` extracting the files to `"data/raw2clean/geography/weather_CPCG"` in order to fill the existing and empty folder `"data/raw2clean/geography/weather_CPCG/output"` without creating redundant directory levels.
   * If you want to skip   
   `"code/raw2clean/geography/weather_ncepDoeReanalysis/geo_br_weather_reanalysis_raw2clean.R"` (time of processing: 1 hour), unzip `"data/raw2clean/geography/weather_ncepDoeReanalysis/output.zip"` extracting the files to `"data/raw2clean/geography/weather_ncepDoeReanalysis"` in order to fill the existing and empty folder `"data/raw2clean/geography/weather_ncepDoeReanalysis/output"` without creating redundant directory levels.
   * The two output folders above and the input folder mentioned in the instructions had to be zipped due to the limit in the number of files allowed in the openICPSR deposit (1,000 files). We opted for the zip solution because the number of files was very concentrated in these 3 folders (~24,000 files), so even though it added an additional manual step it also allowed us to preserve a similar workflow structure for all data sources. 
   
- Skipping individual do-files is not recommended, there are some dependencies across do-files and the setup is only done in the `"code/_MASTERFILE.do"`.

- If running R programs individually note that sometimes ORDER IS IMPORTANT. 

List of tables and programs 
---------------------------

The provided code reproduces:

- [X] All tables and figures in the paper


|Fig,/Table| Script in "code/analysis/..."                    | Output in "results/..."                             |
|----------|--------------------------------------------------|-----------------------------------------------------|
| Table 1  | regs/table1_stage1_cloudsEnforcement.do          | regs/table1_stage1_cloudsEnforcement.xml            |
| Table 2  | regs/table2_stage2_enforcementDeforestation.do   | regs/table2_stage2_enforcementDeforestation.xml     |
| Table 3  | regs/table3_robustness.do                        | regs/table3_robustness.xml                          |
| Table 4  | regs/table4_placebo.do                           | regs/table4_placebo.xml                             |
| Table A.1| stats/tableA1_sumStats.do                        | stats/tableA1_sumStats.xlsx                         |
| Table B.2| sims/tableB2_counterfactual.do                   | sims/tableB2_counterfactual.xlsx                    |
| Table C.3| regs/tableC3_robustness_altWeather.do            | regs/tableC3_robustness_altWeather.xlsx             |
| Fig. 1   | NA; Ibama (2012)                                 | NA; Ibama (2012)                                    |
| Fig. 2a  | graphics/figure2_map_clouds_alerts.R             | graphics/figure2a_map_deter_cloudsAlerts_2011Q1.pdf |
| Fig. 2b  | graphics/figure2_map_clouds_alerts.R             | graphics/figure2b_map_deter_cloudsAlerts_2011Q2.pdf |
| Fig. 2c  | graphics/figure2_map_clouds_alerts.R             | graphics/figure2c_map_deter_cloudsAlerts_2011Q3.pdf |
| Fig. 2d  | graphics/figure2_map_clouds_alerts.R             | graphics/figure2d_map_deter_cloudsAlerts_2011Q4.pdf |
| Fig. 3   | regs/figure3_stage1_cloudsEnforcement_monthly.do | regs/figure3_stage1_cloudsEnforcement_monthly.pdf   |
| Fig. 4   | regs/figure4_placebo_preDeterClouds.do           | regs/figure4_placebo_preDeterClouds.pdf             |
| Fig. A.1 | graphics/figureA1_gph_fines_deforest.R           | graphics/figureA1_gph_deforestFines.pdf             |
| Fig. B.2 | graphics/figureB2_gph_counterfactual.do          | graphics/figureB2_gph_counterfactual.pdf            |

Important observation: the programs mentioned above generate "raw" versions of the tables in the paper, final style adjusts were made manually using Microsoft Excel then exported to LaTex using `"excel2latex"` add-in.

The numbers provided in the text in the paper come from other sources or can be reproduced by code in this replication package as specified below:

- `"Within less than a decade, Amazon forest clearing rates fell by nearly 85%"`
  * location in the paper: page 1
  * source: INPE (2020c) 
  * notes: See url (https://web.archive.org/web/20210209141742if_/http://terrabrasilis.dpi.inpe.br/app/dashboard/deforestation/biomes/legal_amazon/rateshttp://terrabrasilis.dpi.inpe.br/app/dashboard/deforestation/biomes/legal_amazon/rates) that contains the rates of 2004 and 2012 in the first panel on the left with the annual rates. Using them we see a fall of approximately 85% ((27,772-4,571)/27,772).

- `"By 2004, deforested area totaled over 600 thousand km2, nearly 15% of the country's original Amazon forest area"` 
  * location in the paper: page 5
  * sources: INPE (2017a); and IBGE (2004)
  * notes: Enter the url (http://www.dpi.inpe.br/prodesdigital/prodesmunicipal.php), change the category "Tipo" in "Gráficos" from "Estadual" to "Anual", and press "Histograma" button. A graphic will appear with the accumulated deforested area by year. For 2004 the area totals 670,689.1 square kilometers and the share is nearly 15% [670,689.1/4,196,943]. The denominator is the area of the Amazon biome explained better below.

- `"The Brazilian Amazon covers an area of approximately 4.2 million km2"`
  * location in the paper: page 5
  * source: IBGE (2004) 
  * notes: See the url (https://geoftp.ibge.gov.br/informacoes_ambientais/estudos_ambientais/biomas/mapas/biomas_5000mil.pdf) that contains a map representing the data and with the information that the Amazon Biome covers an area of approximately 4,196,943 square kilometers.
  
- `"Undesignated lands, where all clearings are illegal, extend over an estimated 700 thousand km2"`  
  * location in the paper: page 5
  * source: Azevedo-Ramos and Moutinho (2018)
  * See page 2, figure 1 of Azevedo-Ramos and Moutinho (2018)

- `"An additional 2.2 million km2 are under protection, as either indigenous lands or protected areas"` 
  * location in the paper: page 5
  * source: Gandour (2018)
  * notes: See page 37, figure 2.1 of Gandour (2018)
  
- `"The remaining 1.3 million km2 are either private landholdings or agrarian reform settlements"` 
  * location in the paper: page 5
  * source: IBGE (2004); Azevedo-Ramos and Moutinho (2018); and Gandour (2018)
  * notes: Residual number calculated using the numbers from the previous sources presented above. (4.2 million - 2.2 million - 0.7 million = 1.3 million).

- `"pasture occupies 63% and cropland 6% of cleared Amazon areas"`
  * location in the paper: page 6
  * source: INPE and EMBRAPA (2016)
  * notes: See slide 5 - last column of http://www.inpe.br/cra/projetos_pesquisas/arquivos/TerraClass_2014_v3.pdf. Pasture is the sum of the 4 rows containing "Pasto". Cropland is the first row "Agricultura Anual".
  
- `"The remaining cleared area is covered by forest regrowth (23%), or a mix of other uses (8%), including urban and mining areas."`
  * location in the paper: page 6 (footnote #6)
  * source: INPE and EMBRAPA (2016)
  * notes: See slide 5 - last column of http://www.inpe.br/cra/projetos_pesquisas/arquivos/TerraClass_2014_v3.pdf. Regrowth is the sum of rows "Reflorestamento" and "Vegetação secundária". The mix of other uses is the sum of the remaining rows.
  
- `"This eliminates 25 municipalities that did not contain a significant amount of forest cover at baseline, as evidenced by a 2% average ratio of forest to municipal area"` 
  * location in the paper: page 13
  * source: INPE (2017a)
  * notes: See output `"data/analysis/stats/supportStats_avgForestCover.txt"` generated by lines 105-112 of `"code/projectSpecific/dataPrep_forAnalysis.do"`
  
- `"95% of the area deforested in the Amazon since the adoption of the remote monitoring system occurred within the Amazon biome."`
  * location in the paper: page 13 (footnote #9)
  * source: INPE (2020a); and INPE (2020b)
  * notes: Enter the url (https://web.archive.org/web/20210211174346/http://terrabrasilis.dpi.inpe.br/app/dashboard/deforestation/biomes/amazon/increments) and sum the value of all years (2008-2020) in the panel "Incrementos de Desmatamento - Amazônia - Estados" that is equal to 90.2 thousand square kilometers, then enter the url (https://web.archive.org/web/20210211174800if_/http://terrabrasilis.dpi.inpe.br/app/dashboard/deforestation/biomes/legal_amazon/increments) and sum the value of all years (2008-2020) in the panel "Incrementos de Desmatamento - Amazônia Legal - Estados" that is equal to 94.8 square kilometers. Dividing 90.2 by 94.8 and multiplying by 100 we find 95%.
  
- `"This is consistent with the fact that at the time DETER was launched, tropical forest covered less than 5% of non-biome Legal Amazon territory"` 
  * location in the paper: page 13 (footnote #9)
  * source: IBGE (2004); IBGE (2007); Ibama (2007); and INPE (2017a)
  * notes: See output generated by line 71 of `"code/analysis/stats/supportStats_forest_laz_nonBiome.R"`
  
- `"Note that non-null deforestation is greater than 0.01 km2 for all observations in the raw data"` 
  * location in the paper: page 14 (footnote #12)
  * source: INPE (2017a)
  * notes: See output `"data/analysis/stats/supportStats_distribDeforestation"` generated by lines 65-76 of `"code/MASTERFILE.do"`
  
- `"Soybean, cassava, rice, and corn systematically account for more than 84% of the planted area in sample municipalities during the sample period"` 
  * location in the paper: [ONLINE APPENDIX] page 2 (footnote #3)
  * source: IBGE (2001-2019); IBGE (2003-2017)
  * notes: See output `"data/analysis/stats/supportStats_share_5crops_byYear.png"` generated by `"code/analysis/stats/supportStats_crops.R"`

## Acknowledgements

Adapted from Villhuber et al (2020).

## References

**Assunção, Juliano, Clarissa Gandour, Romero Rocha**. 2021. "Data and code for: DETERring Deforestation in the Amazon: Environmental Monitoring and Law Enforcement" *American Economic Association* [publisher], Inter-university Consortium for Political and Social Research [distributor]. http://doi.org/10.3886/E132281V1

**Azevedo-Ramos, C., and Paulo Moutinho**. 2018. "No man's land in the Brazilian Amazon: Could undesignated public forests slow Amazon deforestation?" *Land Use Policy*, 73:125-127.

**Cadastro Nacional de Unidade de Conservação (CNUC)**. 2016. "Unidades de Conservação." Cadastro Nacional de Unidade de Conservação, Ministério do Meio Ambiente. http://mapas.mma.gov.br/ms_tmp/ucstodas.shp; http://mapas.mma.gov.br/ms_tmp/ucstodas.shx; http://mapas.mma.gov.br/ms_tmp/ucstodas.dbf (accessed March 11, 2016)

**Fundação Getulio Vargas, Conjuntura Econômica - IGP (FGV/Conj. Econ. - IGP)**. 2019. "Índice de Preços ao Produtor Amplo - Disponibilidade Interna (IPA-DI) - geral: índice (ago. 1994 = 100), 1944-2019."  Fundação Getulio Vargas, Conjuntura Econômica - IGP (FGV/Conj. Econ. - IGP) [publisher], Instituto de Pesquisa Econômica Aplicada, Ministério da Economia [distributor]. http://www.ipeadata.gov.br (accessed April 17, 2019)

**Fundação Nacional do Índio (FUNAI)**. 2016a. "Terras Indígenas: Histórico do Status de Demarcação". Fundação Nacional do Índio, Ministério da Justiça. https://web.archive.org/web/20200918123106/http://geoserver.funai.gov.br/geoserver/Funai/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=Funai%3Avw_geo_ti_documentos_sii_sirgas2000&outputFormat=csv (link to updated version archived at Archive.org on September 18, 2020, but the raw data used was obtained upon direct request via e-mail on March 18, 2016)

**Fundação Nacional do Índio (FUNAI)**. 2016b. "Terras Indígenas: shapefile". Fundação Nacional do Índio, Ministério da Justiça. http://www.funai.gov.br/index.php/shape (accessed June 22, 2016)

**Gandour, Clarissa**. 2018. "Forest Wars: A Trilogy on Combating Deforestation in the Brazilian Amazon." PhD thesis, Economics Department, Pontifícia Universidade Católica do Rio de Janeiro (PUC-Rio).

**Instituto Brasileiro de Geografia e Estatística (IBGE)**. 2001-2019. "Produção Agrícola Municipal: Tabela 5457, 2000-2017." Instituto Brasileiro de Geografia e Estatística, Ministério da Economia. https://sidra.ibge.gov.br/tabela/5457 (accessed May 13, 2019).

**Instituto Brasileiro de Geografia e Estatística (IBGE)**. 2003-2017. "Produção Agrícola Municipal: Tabela 1612, 2000-2015." Instituto Brasileiro de Geografia e Estatística, Ministério da Economia. https://sidra.ibge.gov.br/tabela/1612 (accessed June 6, 2017).

**Instituto Brasileiro de Geografia e Estatística (IBGE)**. 2004. "Biomas do Brasil." Instituto Brasileiro de Geografia e Estatística, Ministério da Economia [publisher], Ministério do Meio Ambiente (MMA) [distributor]. http://mapas.mma.gov.br/ms_tmp/bioma.shp; http://mapas.mma.gov.br/ms_tmp/bioma.shx; http://mapas.mma.gov.br/ms_tmp/bioma.dbf  (accessed January 26, 2016).

**Instituto Brasileiro de Geografia e Estatística (IBGE)**. 2007. "Malha Municipal." Instituto Brasileiro de Geografia e Estatística, Ministério da Economia. ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2007/escala_2500mil/proj_policonica_sad69/brasil/ (accessed March 29, 2017).

 **Instituto Brasileiro de Geografia e Estatística (IBGE)**. 2014-2018. "Pesquisa da Pecuária Municipal: Tabela 3939, 2000-2017." Instituto Brasileiro de Geografia e Estatística, Ministério da Economia. https://sidra.ibge.gov.br/tabela/3939 (accessed March 3, 2018).

**Instituto Brasileiro do Meio Ambiente e dos Recursos Naturais Renováveis (Ibama)**. 2007. "Limite Amazônia Legal." Instituto Brasileiro do Meio Ambiente e dos Recursos Naturais Renováveis, Ministério do Meio Ambiente. https://web.archive.org/web/20120721033244/http://siscom.ibama.gov.br/shapes//AMAZONIA_LEGAL_LIMITE.zip (accessed via Archive.org on February 1, 2013).

**Instituto Brasileiro do Meio Ambiente e dos Recursos Naturais Renováveis (Ibama)**. 2012. DETER Satellite Image: Detected Deforestation. Instituto Brasileiro do Meio Ambiente e dos Recursos Naturais Renováveis, Ministério do Meio Ambiente. Received via personal correspondence with Ibama in 2012).

**Instituto Brasileiro do Meio Ambiente e dos Recursos Naturais Renováveis (Ibama)**. 2016. "Autuações Ambientais: Todos, 2000-2015." Instituto Brasileiro do Meio Ambiente e dos Recursos Naturais Renováveis, Ministério do Meio Ambiente. https://servicos.ibama.gov.br/ctf/publico/areasembargadas/ConsultaPublicaAreasEmbargadas.php (link to updated version available online, but the raw data used was obtained upon request via e-SIC and received by mail in physical media on May 2016).

**Instituto Nacional de Pesquisas Espaciais (INPE)**. 2017a. "Projeto PRODES - Monitoramento da Floresta Amazônica Brasileira por Satélite." Coordenação-Geral de Observação da Terra, Instituto Nacional de Pesquisas Espaciais, Ministério da Ciência, Tecnologia e Inovação. http://www.dpi.inpe.br/prodesdigital/prodesmunicipal.php (accessed September 15, 2020).

**Instituto Nacional de Pesquisas Espaciais (INPE)**. 2017b. "Sistema de Detecção de Desmatamento em Tempo Real (DETER): Alertas." Coordenação-Geral de Observação da Terra, Instituto Nacional de Pesquisas Espaciais, Ministério da Ciência, Tecnologia e Inovação. http://www1.dpi.inpe.br/obt/deter/dados/ (accessed multiple times through 2016-2018).

**Instituto Nacional de Pesquisas Espaciais (INPE)**. 2017c. "Sistema de Detecção de Desmatamento em Tempo Real (DETER): Nuvens." Coordenação-Geral de Observação da Terra, Instituto Nacional de Pesquisas Espaciais, Ministério da Ciência, Tecnologia e Inovação. http://www1.dpi.inpe.br/obt/deter/dados/ (accessed multiple times through 2016-2018).

**Instituto Nacional de Pesquisas Espaciais (INPE)**. 2020a. "Projeto PRODES: Incremento do Desmatamento - Amazônia". Coordenação-Geral de Observação da Terra, Instituto Nacional de Pesquisas Espaciais, Ministério da Ciência, Tecnologia e Inovação. https://web.archive.org/web/20210211174346if_/http://terrabrasilis.dpi.inpe.br/app/dashboard/deforestation/biomes/amazon/increments (accessed via Archive.org February 11, 2021).

**Instituto Nacional de Pesquisas Espaciais (INPE)**. 2020b. "Projeto PRODES: Incremento do Desmatamento - Amazônia Legal". Coordenação-Geral de Observação da Terra, Instituto Nacional de Pesquisas Espaciais, Ministério da Ciência, Tecnologia e Inovação. https://web.archive.org/web/20210211174800if_/http://terrabrasilis.dpi.inpe.br/app/dashboard/deforestation/biomes/legal_amazon/increments (accessed
via Archive.org February 11, 2021).

**Instituto Nacional de Pesquisas Espaciais (INPE)**. 2020c. "Projeto PRODES: Taxa de Desmatamento - Amazônia Legal". Coordenação-Geral de Observação da Terra, Instituto Nacional de Pesquisas Espaciais, Ministério da Ciência, Tecnologia e Inovação. https://web.archive.org/web/20210209141742if_/http://terrabrasilis.dpi.inpe.br/app/dashboard/deforestation/biomes/legal_amazon/rates (accessed via
Archive.org February 9, 2021).

**Instituto Nacional de Pesquisas Espaciais (INPE) & Empresa Brasileira de Pesquisa Agropecuária (Embrapa)** 2016. "TerraClass Amazônia: 2014". Instituto Nacional de Pesquisas Espaciais, Ministério da Ciência, Tecnologia e Inovação and Empresa Brasileira de Pesquisa Agropecuária, Ministério da Agricultura, Pecuária e Abastecimento. http://www.inpe.br/cra/projetos_pesquisas/terraclass2014.php (accessed August, 2016).

**Instituto Socioambiental (ISA)**. 2016. "De Olho nas Terras Indígenas." Instituto Socioambiental (ISA). http://ti.socioambiental.org/ (accessed April 29, 2016)

**Matsuura, K. and Willmott, C. J.**. 2018a. "Terrestrial Air Temperature: 1900-2017 Gridded Monthly Time Series (Version 5.01)." Department of Geography, University of Delaware, Newark, DE. http://climate.geog.udel.edu/~climate/html_pages/download.html (accessed July 11, 2019)https://web.archive.org/web/20200910183757/http://climate.geog.udel.edu/~climate/html_pages/Global2017/air_temp_2017.tar.gz (accessed via Archive.org on September 10, 2020).

**Matsuura, K. and Willmott, C. J.**. 2018b. "Terrestrial Precipitation: 1900-2017 Gridded Monthly Time Series (Version 5.01)." Department of Geography, University of Delaware, Newark, DE. https://web.archive.org/web/20200910180228/ftp://ftp.cdc.noaa.govhttps://web.archive.org/web/20200910184200/http://climate.geog.udel.edu/~climate/html_pages/Global2017/precip_2017.tar.gz (accessed via Archive.org on September 10, 2020).

 **Ministério do Meio Ambiente (MMA)**. 2017. "Lista de Municípios Prioritários da Amazônia." Ministério do Meio Ambiente. https://web.archive.org/web/20200915211728/http://combateaodesmatamento.mma.gov.br/images/conteudo/lista_municipios_prioritarios_AML_2017.pdf (accessed via Archive.org on September 15, 2020)

**National Oceanic and Atmospheric Administration, Climate Prediction Center (NOAA-CPC)**. 2018a. "CPC Global Daily Temperature: Maximum." National Oceanic and Atmospheric Administration, Climate Prediction Center [publisher], Physical Sciences Laboratory [distributor], Boulder, Colorado, USA. https://psl.noaa.gov/cgi-bin/db_search/DBSearch.pl?Dataset=CPC+Global+Temperature&Statistic=Maximum&Variable=Maximum+Temperature&group=0&submit=Search (accessed May 17, 2018)

**National Oceanic and Atmospheric Administration, Climate Prediction Center (NOAA-CPC)**. 2018b. "CPC Global Daily Temperature: Minimum." National Oceanic and Atmospheric Administration, Climate Prediction Center [publisher], Physical Sciences Laboratory [distributor], Boulder, Colorado, USA. https://psl.noaa.gov/cgi-bin/db_search/DBSearch.pl?Dataset=CPC+Global+Temperature&Statistic=Minimum&Variable=Minimum+Temperature&group=0&submit=Search (accessed June 11, 2018)

**National Oceanic and Atmospheric Administration, Climate Prediction Center (NOAA-CPC)**. 2018c. "CPC Global Unified Gauge-Based Analysis of Daily Precipitation." National Oceanic and Atmospheric Administration, Climate Prediction Center [publisher], Physical Sciences Laboratory [distributor], Boulder, Colorado, USA. https://psl.noaa.gov/cgi-bin/db_search/DBSearch.pl?Dataset=CPC+Global+Precipitation&Statistic=Total&Variable=Precipitation&group=0&submit=Search (accessed May 17, 2018)

**National Oceanic and Atmospheric Administration, National Centers for Environmental Prediction (NOAA-NCEP)**. 2019. "NCEP-DOE Reanalysis 2: Surface Grids: Precipitable water, Monthly Mean." National Oceanic and Atmospheric Administration, National Centers for Environmental Prediction [publisher], Physical Sciences Laboratory [distributor], Boulder, Colorado, USA. https://web.archive.org/web/20200910180228/ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis2.derived/surface/pr_wtr.eatm.mon.mean.nc accessed via Archive.org on September 10, 2020)

**Platnick, S., M. King, P. Hubanks**. 2017. "MODIS Atmosphere L3 Monthly Product, Version 6.01: Cloud Fraction from Cloud Mask (count of lowest 2 clear sky confidence levels, cloudy & probably cloudy / total count): Mean of Daily Mean". NASA MODIS Adaptive Processing System, Goddard Space Flight Center [publisher], NASA Goddard Earth Sciences Data and Information Services Center [distributor]. https://dx.doi.org/10.5067/MODIS/MOD08_M3.061 (accessed July 21, 2020).

**Secretaria da Agricultura e do Abastecimento do Estado do Paraná (SEAB-PR)**. 2019. "Preço Médio - Recebido pelo Agricultor: boi gordo, arroz (em casca), cana-de-açúcar, milho, mandioca, 1990-2019." Secretaria da Agricultura e do Abastecimento do Estado do Paraná, Departamento de Economia Rural [publisher], Instituto de Pesquisa Econômica Aplicada, Ministério da Economia [distributor]. http://www.ipeadata.gov.br (accessed April 16, 2019)

**Vilhuber, L., Connolly, M., Koren, M., Llull, J., and Morrow, P.**. 2020. "A template README for social science replication packages (Version v1.0.0)". Zenodo. http://doi.org/10.5281/zenodo.4319999 (accessed January 6, 2021)
 