#' Install Glottography datasets
#'
#' Installs Glottography datasets by checking their status in the registry and
#' downloading them from the Zenodo Glottography community according to
#' user-specified rules.
#'
#' @param datasets Character vector specifying the datasets to install, or one
#'   of the following special values:
#'   \itemize{
#'     \item \code{"all"}: install all available datasets.
#'     \item \code{"outdated"}: install all datasets for which an update is
#'       available (new version or updated timestamp).
#'     \item \code{"missing"}: install all datasets that are not yet installed.
#'   }
#'
#' @param update Character string indicating when selected datasets should be
#'   installed. One of:
#'   \itemize{
#'     \item \code{"outdated"}: install only if an update is available on Zenodo.
#'     \item \code{"missing"}: install only if the dataset is not present locally.
#'     \item \code{"always"}: install regardless of local status.
#'   }
#'
#'   This argument is ignored when \code{datasets} is \code{"all"}, \code{"outdated"},
#'   or \code{"missing"}.
#'
#' @return Invisibly returns \code{NULL}.
#' @export
install_datasets <- function(datasets,
                             update = c("missing", "outdated", "always")){

  update <- match.arg(update)
  registry <- .get_registry()

  # Check the user input and return installation instructions
  instructions <- .get_installation_instructions(datasets, registry, update)
  .generate_installation_messages(instructions)

  datasets_to_install <- instructions$name[instructions$to_install]

  if (length(datasets_to_install) == 0) {
    cli::cli_alert_warning("No new datasets will be installed")
    return(invisible(NULL))
  }
  else {
    .download_datasets(datasets_to_install, registry)
    return(invisible(NULL))
  }
}


