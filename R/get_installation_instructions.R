#' Generate installation instructions based on user input
#'
#' This internal helper evaluates the dataset registry and user-specified input
#' to determine which datasets need to be installed or updated. It considers the dataset's
#' current version, local modification date, and the `update` policy (`"always"`,
#' `"missing"`, or `"outdated"`). It returns a data frame with installation instructions
#' including flags and comments for each dataset.
#'
#' @param datasets character. A vector of dataset names provided by the user, or
#'   one of the special keywords `"all"`, `"missing"`, or `"outdated"`.
#' @param registry data.frame. The dataset registry including metadata for all
#'   datasets
#' @param update character. One of `"always"`, `"missing"`, or `"outdated"` specifying
#'   which datasets should be installed if user-specified datasets are given.
#' @return A data.frame of all available datasets with additional columns:
#'   - `to_install` (logical): TRUE if the dataset should be installed
#'   - `comment` (character): reason for install (`"always"`, `"missing"`, `"outdated"`)
#' @keywords internal
#' @noRd
#'
.get_installation_instructions <- function(datasets, registry, update) {
  instructions <- registry[, c(
    "name", "installed", "version", "version_local",
    "modified", "modified_local"
  )]

  # Determine dataset states
  instructions$is_latest_version <- .is_latest_version(
    instructions$version_local, instructions$version
  )

  instructions$includes_latest_changes <- .includes_latest_changes(
    instructions$modified_local, instructions$modified
  )

  instructions$to_install <- FALSE
  instructions$comment <- ""

  # Handle user-specified datasets
  if (is.null(datasets) || !length(datasets)) {
    .provide_valid_dataset_abort()
  }
  if (length(datasets) == 1 && identical(datasets, "all")) {
    instructions$to_install <- TRUE
    instructions$comment <- "always"

  } else if (identical(datasets[1], "missing")) {
    instructions$to_install[!instructions$installed] <- TRUE
    instructions$comment[!instructions$installed] <- "missing"

  } else if (identical(datasets[1], "outdated")) {
    outdated <- !(instructions$is_latest_version & instructions$includes_latest_changes)
    instructions$to_install[outdated] <- TRUE
    instructions$comment[outdated] <- "outdated"

  } else {
    # Validate user-specified datasets
    valid_datasets <- .validate_datasets(datasets, registry, TRUE)
    is_valid <- instructions$name %in% valid_datasets
    outdated <- !(instructions$is_latest_version &
                    instructions$includes_latest_changes)

    if (identical(update, "always")) {
      instructions$to_install[is_valid] <- TRUE
      instructions$comment[is_valid] <- "always"

    } else if (identical(update, "missing")) {

      instructions$to_install[is_valid & !instructions$installed] <- TRUE
      instructions$comment[is_valid & !instructions$installed] <- "missing"
      instructions$comment[is_valid & instructions$installed] <- "not missing"

    } else if (identical(update, "outdated")) {

      instructions$to_install[is_valid & outdated] <- TRUE
      instructions$comment[is_valid & outdated] <- "outdated"
      instructions$comment[is_valid & !outdated] <- "not outdated"
    }
  }

  .summarise_installation_message(instructions)

  datasets_to_install <- instructions$name[instructions$to_install]
  datasets_to_install
}





