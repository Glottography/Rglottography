#' Read a Glottography dataset
#'
#' Loads all segments of a single Glottography dataset and combines them
#' into unified objects for features, languages, families, and sources.
#'
#' @param dataset Character. Name of the dataset to read.
#' @param registry A data.frame representing the registry.
#' @param level Character vector specifying which levels of
#'   aggregation to load and combine. Possible values:
#'   - `"features"`: speaker areas according to the original source classification
#'   - `"languages"`: areas aggregated at the Glottolog language level
#'   - `"families"`: areas aggregated at the Glottolog family level
#'
#' @return A list containing combined data for the dataset, with the following components:
#'   - `features`: combined `sf` object of feature-level data, or `NULL`
#'   - `languages`: combined `sf` object of language-level data, or `NULL`
#'   - `families`: combined `sf` object of family-level data, or `NULL`
#'   - `sources`: combined `bibentry` object
#'
#' @keywords internal
#' @noRd
#'
.read_dataset <- function(dataset, registry, level) {
  idx <- match(dataset, registry$name)
  local_paths <- registry$local_paths[[idx]]

  use_names <- ifelse(nrow(local_paths) == 1, FALSE, TRUE)
  segments <- mapply(.read_segment, local_paths$segment, local_paths$path,
                     MoreArgs = list(dataset, level),
                     SIMPLIFY = FALSE,
                     USE.NAMES = use_names)

  dataset <- .combine_parts(segments, level)
  dataset
}
