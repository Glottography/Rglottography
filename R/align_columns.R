#' Ensure all data.frames have the same columns (fill missing with NA)
#'
#' Given a list of data frames, compute the union of
#' all column names and return a list where each input data frame has every
#' column (missing columns are added filled with NA). Column order is
#' unified to the union order.
#'
#' @param dfs A list of data frames.
#' @return A list of data frames with identical column sets (and identical
#'   column ordering).
#' @keywords internal
#' @noRd
.align_columns <- function(dfs) {


  # Compute union of all column names in stable order
  all_cols <- unique(unlist(lapply(dfs, names), use.names = FALSE))

  # Add missing columns (as NA) and reorder to all_cols
  aligned <- lapply(dfs, function(df) {
    missing <- setdiff(all_cols, names(df))
    if (length(missing) > 0) {
      # Add missing columns; use [[ to preserve classes when possible
      for (col in missing) df[[col]] <- NA
    }
    # Reorder columns to a consistent order
    df[, all_cols, drop = FALSE]
  })

  aligned
}
