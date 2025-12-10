#' Process and combine a single segment type across dataset segments
#'
#' Helper function that extracts a specific segment type (`features`, `languages`, or
#' `families`) from each segment of a dataset, optionally drops or renames columns,
#' and combines all segments into a single data frame.
#'
#' @param segments A named list of dataset segments. Each segment should be a list
#'   containing `features`, `languages`, and/or `families` data frames.
#' @param dataset Character. The name of the main dataset being processed.
#' @param segment_type Character. The name of the segment type to process; one of `"features"`,
#'   `"languages"`, or `"families"`.
#' @param drop_cols Character vector of column names to remove from the combined data frame.
#' @param rename_cols Named character vector for renaming columns. Names are original
#'   column names; values are the new names.
#'
#' @return A single data frame combining the specified segment type across all segments,
#'   with an additional `dataset` column and optionally renamed columns.
#' @keywords internal
#' @noRd
#'
.process_segment_type <- function(segment, dataset, segment_type,
                             drop_cols = character(), rename_cols = NULL) {

  lst <- Map(function(data, name) {
    data[[segment_type]]$sub <- ifelse(name == dataset, NA_character_, name)
    data[[segment_type]]
  }, segments, names(segments))

  df <- do.call(rbind, lst)
  df <- df[, setdiff(names(df), drop_cols), drop = FALSE]
  df$dataset <- dataset

  if (!is.null(rename_cols)) {
    for (col in names(rename_cols)) {
      names(df)[names(df) == col] <- rename_cols[[col]]
    }
  }

  df
}
