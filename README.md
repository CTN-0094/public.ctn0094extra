# public.ctn0094extra
Helper functions for the CTN-0094 data package public.ctn0094data.


## Introduction
Because this is the "Extra" package which supplements the information in the primary `public.ctn0094data::` package, we muse have the most recent version of this primary data package built first. To build this package from "zipped" source file, run the following code (make sure to set the correct version and the path for your machine):
```r
install.packages(
  '/Users/gabrielodom/Desktop/public.ctn0094data_0.9.0.tar.gz',
  repos = NULL,
  type = 'source'
)
```

If you have access to the private GitHub repo for the data package, use
```r
remotes::install_github('https://github.com/CTN-0094/public.ctn0094data')
```


## Workflow
In order to recreate the data sets in this package, first build this package (`public.ctn0094extra::`) and then run the following scripts in order, rebuilding the package and restarting your R session after each script:

1. `inst/scripts/create_inductDelay_20220308.R`
2. `inst/scripts/create_visitImputed_20220308.R`
3. `inst/scripts/create_weeklyOpioidPattern_20220308.R`
4. `inst/scripts/create_weeklyTLFBPattern_20220511.R`
5. `inst/scripts/create_raceEthnicity_20220816.R`
