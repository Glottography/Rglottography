#' Validate user-provided dataset names and filter out invalid ones
#'
#' This internal helper verifies that the provided dataset names are valid and that
#' each dataset exists. Invalid dataset names trigger a warning message via
#' `.specify_valid_dataset_message()`, and are removed from the returned list.
#'
#' @param datasets character. A vector of dataset names provided by the user.
#' @param registry the (synced) local registry as data.frame.
#' @param install logical. Is the function called when
#' installing (`TRUE`) or loading a dataset (`FALSE`).
#' @return A character vector containing only valid dataset names. Returns `NULL`
#'   if `datasets` is `NULL`.
#' @keywords internal
#' @noRd
.validate_user_datasets <- function(datasets, registry, install) {

  if (is.null(datasets)) {
    .specify_valid_dataset_message(install = installe)
    return(NULL)
  }

  valid_datasets <- Filter(function(d) .dataset_exists(d, registry), datasets)
  invalid_datasets <- setdiff(datasets, valid_datasets)

  for (d in invalid_datasets) {
    .specify_valid_dataset_message(install = install, ds=d)
  }
  return(valid_datasets)
}
