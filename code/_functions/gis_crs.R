
# > PROJECT INFO
# NAME: FUNCTION REPOSITORY
# LEAD: TEAM EFFORT
#
# > THIS SCRIPT
# AIM: BUILD CATALOG OF COMMONLY USED GEOGRAPHIC CRS FUNCTIONS
# AUTHOR: CLARISSA GANDOUR
#
# > EDIT DETAILS
# BY: CLARISSA GANDOUR
# ON: JUN/10/16
#
# > NOTES
# 1: -





# NOT PROJECTED -------------------------------------------------------------------------------------------------------------------------------------

CRSUnprojected <- function(CRSunproj) {

  # ASSOCIATES UNPROJECTED CRS NAMES TO PROJ4STRING STRING DEFINITIONS
  #
  # ARGS
  #   CRS: coordinate reference system name
  #
  # RETURNS
  #   CRS-specific proj4string string (character)


  # SAD69
  # EPSG:4618
  # source: https://epsg.io/4618 (general)
  #         https://wiki.osgeo.org/wiki/Brazilian_Coordinate_Reference_Systems (Brazil only)
  # use: Brazil - onshore and offshore; in rest of South America - onshore north of approximately 45°S and Tierra del Fuego
  # obs: uses GRS 1967 ellipsoid with 1/f to exactly 2 decimal places; in Brazil only, replaced by SAD69(96) (CRS code 5527)
  if (CRSunproj == "SAD69longlat_pre96")   {return("+proj=longlat +ellps=aust_SA +towgs84=-57,1,-41,0,0,0,0 +no_defs ")}
  if (CRSunproj == "SAD69longlat_pre96BR") {return("+proj=longlat +ellps=aust_SA +towgs84=-66.8700,4.3700,-38.5200,0.0,0.0,0.0,0.0 +no_defs")}  # for use with BR only
                                                                                                                 # https://trac.osgeo.org/proj/ticket/241

  # SAD69(96)
  # EPSG:5527
  # source: https://epsg.io/5527 (general)
  #         https://wiki.osgeo.org/wiki/Brazilian_Coordinate_Reference_Systems (Brazil only)
  # use: Brazil - onshore and offshore (includes Rocas, Fernando de Noronha archipelago, Trindade, Ilhas Martim Vaz, Sao Pedro, Sao Paulo)
  # obs: uses GRS 1967 ellipsoid with 1/f to exactly 2 decimal places; in Brazil only, replaces SAD69 original adjustment (CRS code 4618)
  if (CRSunproj == "SAD69longlat")        {return("+proj=longlat +ellps=aust_SA +no_defs")}
  if (CRSunproj == "SAD69longlat_BR")     {return("+proj=longlat +ellps=aust_SA +towgs84=-67.35,3.88,-38.22")}  # for use with BR only
                                                                                                                # https://trac.osgeo.org/proj/ticket/241

  # SIRGAS 2000
  # EPSGE: 4674
  # source: https://epsg.io/4674
  # use: Central America and South America - onshore and offshore; Brazil - onshore and offshore
  # obs: replaces SIRGAS 1995 system for South America; expands SIRGAS to Central America
  # obs: "+proj=longlat +a=6378137 +b=6356752.312125548 +no_defs" is another possible proj4string for SIRGAS2000
  if (CRSunproj == "SIRGAS2000longlat")   {return("+proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs")}


  # WGS84
  # ESPG:4326
  # source: https://epsg.io/4326
  # use: world
  if (CRSunproj == "WGS84longlat")        {return("+proj=longlat +datum=WGS84 +no_defs")}
}





# PROJECTED -----------------------------------------------------------------------------------------------------------------------------------------

CRSProjected <- function(CRSproj) {

  # ASSOCIATES PROJECTED CRS NAMES TO PROJ4STRING STRING DEFINITIONS
  #
  # ARGS
  #   CRS: coordinate reference system name
  #
  # RETURNS
  #   CRS-specific proj4string string (character)


  # SAD69 BRAZIL POLYCONIC
  # EPSG:29101
  # source: https://epsg.io/29101
  # use: Brazil - onshore and offshore
  # obs: uses GRS 1967 ellipsoid with 1/f to exactly 2 decimal places; replaced by SAD69(96) Brazil Polyconic (CRS code 5530)
  if (CRSproj == "SAD69polyconic_pre96") {
      return("+proj=poly +lat_0=0 +lon_0=-54 +x_0=5000000 +y_0=10000000 +ellps=aust_SA +towgs84=-57,1,-41,0,0,0,0 +units=m +no_defs")}


  # SAD69(96) BRAZIL POLYCONIC
  # EPSG:5530
  # source: https://epsg.io/5530
  # use: Brazil - onshore and offshore
  # obs: uses GRS 1967 ellipsoid with 1/f to exactly 2 decimal places; replaces SAD69 / Brazil Polyconic (CRS code 29101)
  if (CRSproj == "SAD69polyconic") {return("+proj=poly +lat_0=0 +lon_0=-54 +x_0=5000000 +y_0=10000000 +ellps=aust_SA +units=m +no_defs")}


  # SIRGAS 2000 BRAZIL POLYCONIC
  # EPSG:5880
  # source: https://epsg.io/5880
  # use: Brazil - onshore and offshore
  # obs: replaces SAD69 Brazil Polyconic (CRS code 29101) and SAD69(96) Brazil Polyconic (CRS code 5530)
  if (CRSproj == "SIRGAS2000polyconic") {
    return("+proj=poly +lat_0=0 +lon_0=-54 +x_0=5000000 +y_0=10000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  }


  # SIRGAS 2000 ALBERS
  # EPSG: - [proj4string written from scratch - not available in EPSG repository]
  # source: - [proj4string written from scratch]
  # use: -
  # obs: proj4string written from content of .prj file downloaded with IBGE's Mapa de Uso da Terra 2014
  if (CRSproj == "SIRGAS2000albers") {return("+proj=aea +lat_1=-2 +lat_2=-22 +lat_0=-12 +lon_0=-54 +x_0=0 +y_0=0 +ellps=GRS80 +units=m +no_defs")}
}





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------