#' Check whether a CLDF directory on GitHub has segments
#'
#' Determines whether a GitHub repository has subfolders in its `cldf/`
#' directory (i.e., a segmented structure) rather than storing files
#' directly in the top-level `cldf/` folder. The function checks for the
#' presence of `features.geojson` in `cldf/`; if the file is absent,
#' the repository is assumed to use a segmented structure.
#'
#' @param github_parts Named list with elements `owner`, `repo`, and `tag`
#'
#' @return Logical scalar:
#'   - `TRUE` if CLDF files are stored in subfolders (segmented structure)
#'   - `FALSE` if `features.geojson` exists directly in `cldf/`
#'
#' @keywords internal
#' @noRd
.has_segments_cldf_github <- function(github_parts) {

  file_url <- .make_github_raw_url(github_parts, file = "features.geojson")
  !.file_exists_github(file_url)
}
