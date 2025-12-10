#' Load Glottography datasets
#'
#' Loads speaker and metadata from the Glottography collection, optionally installing
#' missing datasets and synchronising the local registry.
#'
#' @param datasets Character vector giving the names of datasets to load, or one
#'   of the following special values:
#'   - `"installed"`: all datasets already installed and available locally
#'   - `"all"`: all datasets (attempts to install any missing datasets)
#' @param level Character vector specifying the level of aggregation:
#'   - `"features"`:  return speaker areas according to the original source classification
#'   - `"languages"`:  return speaker areas aggregated at the Glottolog language level
#'   - `"families"`: return speaker areas aggregated at the Glottolog family level
#'   - `"all"`: return all levels
#' @param install Logical. If `TRUE`, allows automatic downloading and installation of missing
#'   datasets when needed.
#' @param sync_registry Logical. If `TRUE`, refreshes the local registry before
#'   loading datasets.
#'
#' @return A list of `sf` objects.
#' @keywords internal
#' @noRd
#'
load_glottography <- function(datasets = "installed",
                              level = c("all", "features",
                                        "languages", "families"),
                              install = FALSE,
                              sync_registry = FALSE) {

  level <- .check_level()
  registry <- .get_registry(sync = sync_registry)

  datasets_to_read <- .identify_datasets_to_read(datasets, registry)
  ## CHECK IF THIS WORKS!
  datasets_to_install <- .identify_datasets_to_install(datasets, registry)

  # STOPP: CHECK FOR character_0
  if (install & datasets_to_install){
    install_datasets(datasets_to_install, "missing")
  } else (
    # Print warning
    datasets_to_install
  )

  datasets <- lapply(datasets_to_read, .read_dataset,
                     registry = registry,
                     level = level)

  names(datasets) <- datasets_to_read

  collection <- .combine_parts(datasets, level, tag_source=TRUE)
  return(collection)
}
