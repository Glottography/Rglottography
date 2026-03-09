#' Recursively extract `sources` elements from a nested list
#'
#' Collects all elements named `sources` from a potentially deeply nested list.
#' If an element contains a `sources` field, its value is returned and
#' recursion does not continue deeper at that branch.
#' Non-list inputs return an empty list.
#'
#' @param sources_nested A (possibly nested) list that may contain elements
#'   named `sources` at arbitrary depths.
#'
#' @return A list of all extracted `sources` elements. Returns an empty list
#'   if `sources_nested` is not a list or if no `sources` elements are found.
#' @keywords internal
#' @noRd
.extract_sources <- function(sources_nested) {
  if (!is.list(sources_nested)) {
    return(list())
  }

  # If this level has a "sources" element, collect it and stop here
  if (!is.null(names(sources_nested)) && "sources" %in% names(sources_nested)) {
    return(list(sources_nested[["sources"]]))
  }

  # Otherwise recurse into all elements
  unlist(
    lapply(sources_nested, .extract_sources),
    recursive = FALSE
  )
}
