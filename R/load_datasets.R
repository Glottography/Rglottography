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
#' @param install_missing Logical. If `TRUE`, allows automatic downloading and installation of missing
#'   datasets when needed.
#' @param sync_registry Logical. If `TRUE`, synchronises the locale registry with Zenodo before
#'   loading datasets.
#'
#' @return A list of `sf` objects.
#' @keywords internal
#' @noRd
#'
load_datasets <- function(datasets = "installed",
                          level = c("all", "features",
                                    "languages", "families"),
                          install_missing = FALSE,
                          sync_registry = FALSE) {

  level <- .check_level()
  registry <- .get_registry(sync = sync_registry)

  datasets_to_read <- .identify_datasets_to_read(datasets, registry)
  datasets_to_install <- .identify_datasets_to_install(datasets_to_read,
                                                       registry)
  if (length(datasets_to_install) > 0) {
    if (install_missing) {

      .install_information(datasets_to_install)
      .download_datasets(datasets_to_install, registry)

      return(load_datasets(datasets = datasets,
                           level = level,
                           install_missing = FALSE,
                           sync_registry = sync_registry))

    } else {
      .skip_not_installed_warning(datasets_to_install)
      datasets_to_read <- setdiff(datasets_to_read, datasets_to_install)
    }
  }

  datasets <- lapply(datasets_to_read, .read_dataset,
                     registry = registry,
                     level = level)

  names(datasets) <- datasets_to_read

  collection <- .combine_parts(datasets, level, tag_source=TRUE)
  return(collection)
}
