
<!-- README.md is generated from README.Rmd. Please edit that file -->

# saturnR

## Overview

This package is a wrapper on saturn traffic modelling software to
improve saturn and R workflow. It’s functions use SATURN built in XEXES
as a backend and allow R users to interact with the most common SATURN
files such as UFM matrices and UFS files

Currently you can:

  - read and write matrices (both single and multiuser) (MX backend)
  - read ufs files and extract the geometry and data (P1XDUMP + SATDB
    backend) which allows to obtain sf objects.

## Installation

``` r
# You can install the the development version from GitHub:
# install.packages("devtools")
devtools::install_github("r-aecom/saturnR")
```

## Intro to Matrix manipulation

Matrix manipulation using the built in tools in Saturn can be cumbersome
whith this package you can load the data into R modify it and save it
again.

The Package comes with some example files for you to test you can see
them with

``` r
library(saturnR)
saturnR_example()
#> [1] "2014_Coordinates.dat"     "BlckCt_2015_5UC_TS11.UFM"
#> [3] "Epsom98mat.UFM"           "Epsom98oba.UFS"
```

To modify the example Epsom98 matrix first we need to set up out XEXES
folder as our back end.

``` r
set_xexes("C:/Program Files (x86)/Atkins/SATURN/XEXES 11.4.07H MC X7/") # Using a particular version of the backend
```

The we can read the matrix. It only has one user class, 12 zones and 144
rows

``` r
epsom_mat <- saturnR_example("Epsom98mat.UFM") 

mat <- read_ufm(epsom_mat)

mat
#>      origin destination user_class   trips
#>   1:      1           1          1   0.000
#>   2:      1           2          1   8.361
#>   3:      1           3          1  31.500
#>   4:      1           4          1 226.728
#>   5:      1           5          1  84.735
#>  ---                                      
#> 140:     12           8          1  10.952
#> 141:     12           9          1   0.000
#> 142:     12          10          1   0.000
#> 143:     12          11          1   0.000
#> 144:     12          12          1   0.000
```

If we wanted to analyse the trips between zone 3 and 4 we could use:

``` r
selected_trips <- (mat$origin == 3 & mat$destination == 4) | # from 3 to 4
  (mat$origin == 4 & mat$destination == 3) # or from 4 to 3

mat[selected_trips,]
#>    origin destination user_class   trips
#> 1:      3           4          1  53.496
#> 2:      4           3          1 152.712
```

Then we can increase them by a fixed ammount.

``` r
fixed_increase <- 200 # A new development adds 200 trips

mat$trips[selected_trips] <- mat$trips[selected_trips] + 200

mat[selected_trips,]
#>    origin destination user_class   trips
#> 1:      3           4          1 253.496
#> 2:      4           3          1 352.712
```

Finally we could save the matrix

``` r
write_ufm(mat, "Epsom_new_dev.UFM")
```
