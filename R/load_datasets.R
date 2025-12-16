#' Load Glottography datasets
#'
#' Loads speaker area data and associated metadata from the Glottography collection,
#' optionally installing missing datasets and synchronising the local registry.
#'
#' @param datasets Character vector specifying the names of datasets to load, or
#'   one of the following special values:
#'   \itemize{
#'     \item \code{"installed"}: all datasets already installed locally.
#'     \item \code{"all"}: all datasets (attempts to install any missing datasets).
#'   }
#'
#' @param level Character vector specifying the level(s) of aggregation to load:
#'   \itemize{
#'     \item \code{"features"}: speaker areas according to the original source classification.
#'     \item \code{"languages"}: speaker areas aggregated at the Glottolog language level.
#'     \item \code{"families"}: speaker areas aggregated at the Glottolog family level.
#'     \item \code{"all"}: all levels.
#'   }
#'   Only valid levels will be selected.
#'
#' @param install_missing Logical. If \code{TRUE}, allows automatic downloading and installation
#'   of missing datasets.
#'
#' @param sync_registry Logical. If \code{TRUE}, synchronises the local registry with Zenodo
#'   before loading datasets.
#'
#' @return A validated Glottography collection (S3 class \code{glottography_collection})
#'   containing the following components (if requested):
#'   \itemize{
#'     \item \code{features}: a \code{glottography_features} object; speaker areas according to the original source classification.
#'     \item \code{languages}: a \code{glottography_languages} object; speaker areas aggregated at the Glottolog language level.
#'     \item \code{families}: a \code{glottography_families} object; speaker areas aggregated at the Glottolog family level.
#'     \item \code{sources}: a \code{glottography_sources} object; list of bibliographic references in BibTeX format.
#'   }
#'   Components not requested are omitted.
#'
#' @export

load_datasets <- function(datasets = "installed",
                          level = c("all", "features",
                                    "languages", "families"),
                          install_missing = FALSE,
                          sync_registry = FALSE) {

  level <- .check_level(level)

  datasets_to_read <- .get_load_instructions(datasets,
                                             install_missing,
                                             sync_registry)

  registry <- .get_registry(sync = sync_registry)

  datasets <- lapply(datasets_to_read,
                     .read_dataset,
                     registry = registry,
                     level = level)

  names(datasets) <- datasets_to_read

  collection <- .combine_parts(datasets, level, tag_source = TRUE)
  return (.as_glottography(collection))
}
