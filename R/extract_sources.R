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
