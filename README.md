
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
