#' Extract dataset names from a Glottography object
#'
#' Recursively extracts the names of datasets from a Glottography object, which
#' can be a single polygon, a collection, or a data.frame. If the object is a
#' list, the function traverses all elements and returns a character vector of
#' dataset names.
#'
#' @param glottography A Glottography object (e.g., `glottography_collection`,
#'   `glottography_polygons`, or a data.frame or list) from which to extract dataset names.
#'
#' @return A character vector of dataset names, or `NULL` if none are found.
#'
#' @keywords internal
#' @noRd

.extract_datasets <- function(glottography) {

  # Single Glottography polygons object
  if (inherits(glottography, "glottography_polygons")) {
    return(glottography$dataset)
  }

  # Plain data.frame
  if (is.data.frame(glottography)) {
    cli::cli_warn("This is not a Glottography object. I will try to infer source information from the dataset column.")
    if ("dataset" %in% names(glottography)) {
      return(as.character(glottography$dataset))}
    return(NULL)
  }

  # List / collection: recursively extract
  if (is.list(glottography)) {
    return(unlist(lapply(glottography, .extract_datasets), use.names = FALSE))
  }

  # Anything else: return NULL
  NULL
}
