#' Collect sources referenced by a Glottography object
#'
#' Extracts and returns the unique source identifiers referenced by a
#' Glottography object. If the input is a \code{glottography_collection},
#' sources are taken directly from the object. Otherwise, the function
#' determines the associated datasets, reads them from the local registry,
#' and collects all referenced sources.
#'
#' @param glottography A Glottography object of class
#'   \code{glottography_features}, \code{glottography_languages}, or
#'   \code{glottography_families}; a \code{data.frame} derived from a
#'   Glottography object (containing a \code{dataset} column); or a
#'   \code{glottography_collection}. For non-collection inputs, the function
#'   identifies the associated datasets and retrieves their sources from the
#'   local registry.
#'
#' @return A character vector of unique source identifiers referenced by the
#'   input \code{glottography} object, in BibTeX format.
#'
#' @export
collect_sources <- function(glottography) {

  if (inherits(glottography, "glottography_collection")) {

    unique_sources <- glottography$sources |>
      unlist(recursive = TRUE, use.names = FALSE) |>
      unique()
    return (unique_sources)
  }

  datasets <- unique(.extract_datasets(glottography))
  registry <- .get_registry(sync = FALSE)

  unique_sources <- lapply(datasets, .read_dataset,
                           registry = registry, level = NULL) |>
    .extract_sources() |>
    unlist(recursive = TRUE, use.names = FALSE) |>
    unique()

  unique_sources
}
