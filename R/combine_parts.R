#' Combines Glottography datasets or segments of a dataset
#'
#' Combines several datasets or the segments of a single dataset consisting of
#' unified tables for features, languages, and families
#'
#' @param parts A list of datasets or dataset segments. Each part should
#'   contain the sf data frames `features`, `languages`, `families` and the bibentry `sources`
#' @param level Character vector specifying the levels to process:
#'   - `"features"`: speaker areas according to the original source classification
#'   - `"languages"`: areas aggregated at the Glottolog language level
#'   - `"families"`: areas aggregated at the Glottolog family level
#' @param tag_source Logical. Add identifiers for each part to its source.
#' @return A list with four components:
#'   - `features`: data frame of combined feature-level data, or `NULL` if not requested
#'   - `languages`: data frame of combined language-level data, or `NULL` if not requested
#'   - `families`: data frame of combined family-level data, or `NULL` if not requested
#'   - `sources`: combined bibentry `sources`
#' @keywords internal
#' @noRd
#'
.combine_parts <- function(parts, level, tag_source = FALSE) {
  if ("features" %in% level) {
    # Some features have extra columns (number_legend)
    aligned_features <- .align_columns(lapply(parts, function(x) x$features))
    features <- do.call(rbind, aligned_features)
  } else {
    features <- NULL
  }
  if ("languages" %in% level){
    languages <- do.call(rbind, lapply(parts, function(x) x$languages))
  } else{
    languages <- NULL
  }
  if("families" %in% level){
    families <- do.call(rbind, lapply(parts, function(x) x$families))
  } else{
    families <- NULL
  }

  if (length(parts) == 1 & !tag_source) {
    sources <- parts[[1]]$sources
  } else {
    sources <- lapply(parts, function(x) x$sources)
  }

  list(features = features,
       languages = languages,
       families = families,
       sources = sources)
}
