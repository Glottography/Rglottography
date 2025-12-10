#' Print the status of datasets with CLI messages
#'
#' Displays a header and a bullet list of dataset names using the `cli` package.
#' The message type can be a warning or success, and an optional footer can be added.
#'
#' @param df data.frame. Must contain a column `name` with dataset names to display.
#' @param header Character. The header message to display above the bullet list.
#' @param alert_type Character. Either `"warning"` (default) or `"success"`. Determines the type of CLI alert.
#' @param installation_prompt Character. Optional message on how to install the data displayed below the bullet list.
#'
#' @return Invisibly returns `NULL`. The function is called for its side effect of printing messages.

#' @export
.print_dataset_status <- function(df, header, alert_type = c("warning", "success"),
                                  installation_prompt = "") {
  alert_type <- match.arg(alert_type)

  if (nrow(df) == 0) return(invisible(NULL))

  # Show the header
  if (alert_type == "warning") {
    cli::cli_alert_warning(header)
  } else {
    cli::cli_alert_success(header)
  }

  # Show the dataset names as bullets
  cli::cli_text("\n")
  cli::cli_bullets(.names_to_bullet_list(df$name))

  # Optional footer message
  if (!is.null(installation_prompt) && nzchar(installation_prompt)) {
    cli::cli_text(paste0('Use function_name(dataset="', installation_prompt,'")
           to install.'))
  }

  invisible(NULL)
}

#' Convert a vector of names in a named vector for use in cli::cli_bullets()
#'
#' @param names character. Vector of names
#' @return named vector for use in cli::cli_bullets()
#' @keywords internal
#' @noRd
.names_to_bullet_list <- function(names){
  bullet_list <- stats::setNames(
    names,
    rep("*", length(names))
  )
  bullet_list
}

#' CLI message when no or unknown dataset name is provided
#'
#' Signals an error using `cli::cli_abort()` when the user does not specify
#' a valid dataset name. If a dataset name is given but not recognized,
#' it issues a warning instead. The message also lists accepted special values.
#'
#' @param ds Character. The dataset name (optional).
#' @param install Logical. Is the function called when
#' installing (`TRUE`) or loading a dataset (`FALSE`).
#' @return This function always stops execution (via `cli_abort()`) when `ds` is NULL.
#' @keywords internal
#' @noRd
.specify_valid_dataset_message <- function(install,
                                           ds = NULL) {
  if (install){
    message_lines <- c(
      "Please specify a valid dataset name or one of the following special values:",
      "*" = "{.val all}       → install all Glottography datasets",
      "*" = "{.val missing}   → install datasets missing locally",
      "*" = "{.val outdated}  → install datasets that are outdated")
  } else{
    message_lines <- c(
      "Please specify a valid dataset name or one of the following special values:",
      "*" = "{.val installed}   → load all installed Glottography datsets",
      "*" = "{.val all}   → load all Glottography datasets")
  }

  if (is.null(ds)) {
    cli::cli_abort(message_lines)
  } else {
    cli::cli_alert_warning("No Glottography dataset named {.val {ds}} found. Skipping.")
    cli::cli_bullets(message_lines)
  }
}

#' CLI message when up-to-date dataset is installed
#'
#' Signals a warning using `cli::cli_warning()` when the user installs a
#' dataset that is already up-to-date
#'
#' @param ds Character. The dataset name.
#' @keywords internal
#' @noRd
.up_to_date_message <- function(ds) {
  cli::cli_alert_warning("Glottography dataset named {.val {ds}} is already installed and up-to-date. Skipping.")
  cli::cli_text("💡 Hint: To force a fresh installation, set {.code update = 'always'}.")
  }




