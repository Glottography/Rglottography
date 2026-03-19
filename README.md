# Rglottography

<!-- badges: start -->
[![R-CMD-check](https://github.com/Glottography/Rglottography/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Glottography/Rglottography/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Rglottography provides programmatic access to the Glottography dataset, a collection of language area polygons hosted on Zenodo and GitHub. The package allows users to list available datasets, download them, and load them as standard spatial (`sf`) objects in R.

---

## Intended Users

Linguists, geographers, cultural anthropologists, and others working with areal linguistic data.

---

## Core Functionality

- `set_cache_dir(path)`: Set the location of the cache directory. 
- `list_datasets()`: Lists all available Glottography datasets.  
- `download_dataset(dataset)`: Downloads one or more datasets to the local cache.  
- `load_glottography(dataset, install_missing = TRUE)`: Loads downloaded datasets as `sf` spatial objects.

## Optional Functions

- `set_cache_dir(path)`: Sets a custom location for the cache directory. Use this if you want to change where datasets are stored.

---

## Data Model and Storage

- Datasets are organised by scientific source publication.
- To avoid repeated downloads, datasets are cached in a user-specific directory (default: `tools::R_user_dir("Rglottography", "data")`). Users can change this location using `set_cache_dir()`.
- Metadata is shipped with the package in `inst/extdata/registry.json` and copied to the cache directory.
---

## Design Principles

- Datasets are only downloaded when requested.  
- All outputs are returned as standard spatial (`sf`) objects for compatibility with geospatial analysis in R.

---

## Installation

You can install the development version of Rglottography from GitHub using `remotes`. If not already installed, first install  `remotes`, then use it to install Rglottography from GitHub:

```r
# install.packages("remotes")
remotes::install_github("Glottography/Rglottography")
```
---

## Example 

The following commands demonstrate usage:

```r
library(Rglottography)

# List available datasets
list_datasets()

# Load the dataset matsumae2021exploring, downloading it on first use.
glottography <- load_datasets("matsumae2021exploring", install_missing = TRUE)
languages <- glottography$languages
```

See the package vignettes for more detailed examples.
