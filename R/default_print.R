#' Use the default print method for the table class
#'
#' This function will dispatch the default print method for the table, if any of
#' the table's classes have been registered for flipping. Where the table has
#' multiple classes registered, the priority is given to the order specified in
#' the registration config.
#'
#' Use this in `printer_fns` configuration in [register_flips()]. Do not use
#' `print()` as that creates an unavoidable S3 dispatch loop.
#'
#' @param x the table to print
#' @param ... args forwarded to the default print function
#' @export
default_print <- function(x, ...) {

  obj_class <-
    intersect(class(x), vapply(PACKAGE_ENV$printed_classes, function(x) x$class, character(1)))[[1]]

  default_print_method <- PACKAGE_ENV$default_prints[[obj_class]]
  if (is.null(default_print_method)) {
    rlang::abort(
      glue::glue("Failed lookup for default print method for {obj_class}"),
      "failed_lookup_for_default_print"
      )
  }
  default_print_method(x, ...)
}

