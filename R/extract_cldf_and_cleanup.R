#' Extract and organize CLDF data files
#'
#' Copies selected CLDF data files (`features`, `languages`, `families`,
#' `languages.csv`, and `sources.bib`) from a dataset's `cldf/` directory into
#' the specified dataset directory. If the `cldf/` directory contains segment
#' subfolders (identified by the presence of a `languages.csv` file), each
#' subfolder is treated as a separate segment and its structure is preserved.
#' Otherwise, the `cldf/` directory itself is treated as a single segment.
#'
#' After copying, the original extracted dataset directory is deleted to clean
#' up temporary files.
#'
#' @param dataset_dir Character. Path to the dataset directory where CLDF files
#'   should be organized.
#' @return A data frame with columns `segment` and `path`, listing segment names
#'   (or `NA` for unsegmented datasets) and the corresponding local folder paths.
#' @keywords internal
#' @noRd
.extract_cldf_and_cleanup <- function(dataset_dir) {

  main <- list.files(dataset_dir, full.names = TRUE)[1]
  cldf <- file.path(main, "cldf")
  sub_cldf <- list.dirs(cldf, recursive = FALSE, full.names = TRUE)

  has_segments <- length(sub_cldf) > 0 &&
    any(file.exists(file.path(sub_cldf, "languages.csv")))

  segments_path <- if (has_segments) {
    # keep only valid segment folders
    sub_cldf[file.exists(file.path(sub_cldf, "languages.csv"))]
  } else {
    cldf
  }

  copy_plan <- expand.grid(
    source_dir = segments_path,
    filename   = c("features.geojson", "languages.geojson",
                   "families.geojson", "languages.csv", "sources.bib"),
    stringsAsFactors = FALSE)

  if (length(segments_path) == 1) {
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
