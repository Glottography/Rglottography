#' Rglottography: Programmatic Access to the 'Glottography' Geolinguistic Data Platform
#'
#' @description
#' Provides programmatic access to Glottography, an online repository of
#' geospatial speaker-area polygons for the world's languages. This package
#' allows users to list available datasets, download and install them, and
#' load speaker-area polygons as standard spatial 'sf' objects in R.
#'
#' @details
#' The package is the primary R interface for the Glottography data platform.
#' It simplifies the workflow of obtaining georeferenced speaker areas
#' linked to 'Glottolog' identifiers.
#'
#' @section Key functions:
#' \itemize{
#'   \item \code{\link{list_datasets}}: View available datasets.
#'   \item \code{\link{install_datasets}}: Download Glottography datasets from GitHub or Zenodo.
#'   \item \code{\link{load_datasets}}: Load Glottography datasets into the current R session.
#'   \item \code{\link{set_cache_dir}}: Manage where datasets are stored locally.
#' }
#'
#' @references
#' Ranacher, P., et al. (2026). "Glottography: an open-source geolinguistic
#' data platform for mapping the world’s languages." Journal of Open Humanities Data.
#' \doi{10.5334/johd.459}
#'
#' @docType package
#' @name Rglottography
"_PACKAGE"
