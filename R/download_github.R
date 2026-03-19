#' Download a Glottography dataset from a GitHub repository
#'
#' Downloads a predefined set of CLDF data files from a given GitHub
#' repository into a specified local directory. If the repository contains
#' segments, files are downloaded into subdirectories per segment.
#' Otherwise, files are downloaded directly into `data_dir`.
#'
#' The function constructs a download plan for required files, generates
#' the corresponding GitHub raw file URLs, and downloads each file to its
#' target location.
#'
#' @param github_parts Named list with elements `owner`, `repo`, and `tag`.
#' @param data_dir Character string. The local directory where files
#'   should be downloaded.
#'
#' @return A data frame with columns `segment` and `path`, listing segment names
#'   (or `NA` for unsegmented datasets) and the corresponding local folder paths.
#'
#' @keywords internal
#' @noRd
.download_github <- function(github_repository, data_dir) {

  github_parts <- .deconstruct_url_github(github_repository)
  has_segments <- .has_segments_cldf_github(github_parts)
  filenames <- c("features.geojson", "languages.geojson",
                 "families.geojson", "languages.csv", "sources.bib")

  segments <- if (has_segments) {
    .find_segments_github(github_parts)
  } else {
    NA_character_
  }

  download_plan <- expand.grid(
    segment  = segments,
    filename = filenames,
    stringsAsFactors = FALSE
  )

  download_plan$target_dir <- ifelse(
    is.na(download_plan$segment),
    data_dir,
    file.path(data_dir, download_plan$segment)
  )

  download_plan$rel_target_dir <- ifelse(
    is.na(download_plan$segment),
    basename(data_dir),
    file.path(basename(data_dir), download_plan$segment)
  )

  download_plan$file_url <- mapply(
    .make_github_raw_url,
    MoreArgs = list(github_parts = github_parts),
    file    = download_plan$filename,
    segment = download_plan$segment
  )

  download_plan$file_path <- file.path(download_plan$target_dir,
                                       download_plan$filename)

  mapply(.download_file_github, download_plan$file_url,
         download_plan$file_path,
         SIMPLIFY = FALSE)

  unique(stats::setNames(download_plan[, c("segment", "rel_target_dir")],
                         c("segment", "path")))

}


