#' Check the status of local Glottography datasets
#'
#' Checks if specified Glottography datasets are present locally and whether they are up-to-date.
#'
#' @param datasets Character vector. Names of the dataset(s) to check, or `"all"` to check all datasets. Defaults to `"all"`.
#' @param online Logical. Should the function attempt to check online for the latest versions? Defaults to TRUE.
#'
#' @return Invisible list of three data.frames:
#'   - `not_installed`: datasets available online but not downloaded locally
#'   - `outdated`: datasets installed but not up-to-date
#'   - `up_to_date`: datasets that are installed and up-to-date
#' @export
check_status_datasets <- function(datasets = "all", online = TRUE) {

  # Load registry
  registry <- list_datasets(online = online)

  # Check all datasets?
  if (identical(datasets, "all")) {
    concept_ids <- registry$concept_id
  } else {

    if (any(duplicated(datasets))) {
      cli::cli_warn("Duplicate dataset names detected; duplicates will be ignored.")
      datasets <- unique(datasets)
    }

    # Do the datasets exist on Glottography?
    dataset_exists <- .dataset_exists(datasets, registry)

    if (any(!dataset_exists)) {
      missing <- datasets[!dataset_exists]
      cli::cli_abort(
        "These datasets do not exist on Glottography:
        {paste(missing, collapse = ', ')}. Did you misspell them?"
      )
    }

    concept_ids <- registry[
      match(datasets, registry$name),
      "concept_id"
    ]
  }

  not_installed <- subset(registry,(concept_id %in% concept_ids) & !installed)


  outdated <- subset(registry,
                     (concept_id %in% concept_ids) &
                       installed &
                       (
                         !.is_latest_version(version_local, version) |
                         !.includes_latest_changes(modified_local, modified)
                       )
  )

  up_to_date <- subset(registry,
                       (concept_id %in% concept_ids) &
                         installed &
                         (
                           .is_latest_version(version_local, version) &
                             .includes_latest_changes(modified_local, modified)
                         )
  )

  .print_dataset_status(not_installed[order(not_installed$name), ],
                        "The following Glottography datasets are available, but not installed:")
  .print_dataset_status(outdated[order(outdated$name), ],
                        "The following Glottography datasets have updates:",
                        alert_type = "warning")
  .print_dataset_status(up_to_date[order(up_to_date$name), ],
                        "The following Glottograpy datasets are up-to-date:",
                        alert_type = "success")

  return (invisible(list("not_installed" = not_installed,
                         "outdated" = outdated,
                         "up_to_date" = up_to_date)))
}








