#' Extract and organize CLDF data files
#'
#' Copies the main CLDF data files (`features`, `languages`, `families`) and
#' `sources.bib` from their segment sub-folders into the specified dataset directory,
#' preserving the segment structure. After copying, the original extracted folders
#' are deleted to clean up temporary files.
#'
#' @param dataset_dir Character. Path to the dataset directory where CLDF files
#'   should be organized.
#' @return A data frame listing the original segment names and the corresponding
#'   local folder paths where files were copied.
#' @keywords internal
#' @noRd
.extract_cldf_and_cleanup <- function(dataset_dir) {

  main <- list.files(dataset_dir, full.names = TRUE)[1]
  cldf <- file.path(main, "cldf")
  sub_cldf <- list.dirs(cldf, recursive = FALSE, full.names = TRUE)
  segments <- if (length(sub_cldf) == 0) cldf else sub_cldf

  copy_plan <- expand.grid(
    source_dir = segments,
    filename   = c("features.geojson", "languages.geojson",
                   "families.geojson", "languages.csv", "sources.bib"),
    stringsAsFactors = FALSE)

  if (length(segments) == 1) {
    # single segment: no segment subfolder and segment column NA
    copy_plan$segment <- NA_character_
    copy_plan$target_dir <- dataset_dir

  } else {
    # multiple segments: use basename of source_dir as segment and include it in target_dir
    copy_plan$segment <- basename(copy_plan$source_dir)
    copy_plan$target_dir <- file.path(dataset_dir, copy_plan$segment)
  }

  copy_plan$source <- file.path(copy_plan$source_dir, copy_plan$filename)
  copy_plan$target <- file.path(copy_plan$target_dir, copy_plan$filename)

  mapply(function(from, to) {
    dir.create(dirname(to), recursive = TRUE, showWarnings = FALSE)
    file.copy(from = from, to = to, overwrite = TRUE)},
    from = copy_plan$source,
    to   = copy_plan$target)

  unlink(main, recursive = TRUE)
  unique(stats::setNames(copy_plan[, c("segment", "target_dir")],
                         c("segment", "path")))
}
