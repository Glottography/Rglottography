#' Retrieve the contents of a BibTeX file
#'
#' Reads a BibTeX file from the specified path and returns its contents
#' as a single string, preserving line breaks. This is useful for providing
#' the BibTeX entries in a format that can be written directly to a file
#' or displayed.
#'
#' @param path Character scalar; path to the BibTeX file.
#' @return A character vector of length 1 containing the full contents
#'   of the BibTeX file. Can be written to a `.bib` file using
#'   \code{writeLines()}
#' @keywords internal
#' @noRd
.read_sources <- function(path) {
  paste(readLines(path), collapse = "\n")
}
