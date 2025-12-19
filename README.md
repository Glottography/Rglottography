# Rglottography

<!-- badges: start -->
[![R-CMD-check](https://github.com/Glottography/Rglottography/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Glottography/Rglottography/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Rglottography provides programmatic access to Glottography, an online repository of geospatial speaker-area polygons for the world’s languages. The package allows users to list available datasets, download them from Zenodo, and load them as standard spatial (`sf`) objects in R.

## Installation

You can install the development version of Rglottography from GitHub using `remotes`. If not already installed, first install  `remotes`, then use it to install Rglottography from GitHub:

```r
# install.packages("remotes")
remotes::install_github("Glottography/Rglottography")
```

## Example 

The following commands demonstrate usage:

```r
library(Rglottography)

# List available datasets
list_datasets()

# Load the dataset matsumae2021exploring, downloading it from Zenodo on first use.
glottography <- load_datasets("matsumae2021exploring")
languages <- glottography$languages
```

See the package vignettes for more detailed examples.
