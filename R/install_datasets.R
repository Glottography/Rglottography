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
#' @return Invisibly returns the installed datasets,
#'   or \code{NULL} if none were installed.
#' @export
install_datasets <- function(datasets,
                             update = c("missing", "outdated", "always")) {

  if (!httr2::is_online()) {
    cli::cli_abort("No internet connection detected. Cannot install datasets.")
    }

  update <- match.arg(update)
  registry <- .get_registry()

  datasets_to_install <- .get_installation_instructions(datasets, registry,
                                                        update)

  if (!length(datasets_to_install)) {
    cli::cli_alert_warning("No new datasets will be installed")
    return(invisible(NULL))
  }

  .download_datasets(datasets_to_install, registry)
  invisible(datasets_to_install)
}


