
# -- functions ----------------------------------------------------------------
raster2points <- function(raster.stack, muni.list, raster.name, folder.name = "", temp.dir.path = "", free.cores = 1, spdf.crs.original = "", return.objname = "") {
    # Apply ExtractCellsForPolygonsMapBiomas in a parallel way.
    #
    # ARGS:
    #   raster.stack:  Stack with desired rasters;
    #   muni.list:     Dataframe with desired munis
    #   folder.name:   Name of the folder to save the output
    #   temp.dir.path: Directory path for temporary files
    #   free.cores:    Number of cores it will not use on proccess

    # -- PARALLEL OPS ---------------------------------------------------------


    # detect number of cores for possible use
    nCores = detectCores()
    # build core clusters for parallelization
    cl = makeCluster(nCores - free.cores)
    # activate clusters
    registerDoSNOW(cl)


    # apply parallized function to crop all rasters files by all munis
        foreach(i = seq_along(muni.list),
                .packages = c('raster', 'rgdal', 'rgeos', 'foreach', 'data.table')) %dopar% {
                  source(file.path("code/raw2clean/geography/weather_ncepDoeReanalysis/function_ExtractCellsForPolygonsReanalysis.R"))
                  ExtractRasterCellsForPolygonsReanalysis(fctn.rasterLayer         = raster.stack,
                                                         fctn.spdf                = muni.list[i, ],
                                                         fctn.raster.layers.names = raster.name,
                                                         fctn.spdf.idcol          = "muni_code",
                                                         fctn.return.folder       = folder.name,
                                                         fctn.temp.dir.path       = temp.dir.path,
                                                         fctn.spdf.crs.original   = spdf.crs.original,
                                                         fctn.return.objname      = return.objname)

                }


    stopCluster(cl)
    gc()

}
