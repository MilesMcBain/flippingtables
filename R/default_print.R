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

