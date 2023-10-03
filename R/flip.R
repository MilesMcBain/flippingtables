#' Cycle through configured print methods
#'
#' `print()`` methods are kept in the order supplied in [register_flips()], calling
#' this function cycles between them changing the active print method.
#'
#' if the `.Last.value` hs a class in `printed_classes` supplied to
#' `[register_flips()]`, it is reprinted using the current print method when this
#' function is called.
#'
#' @param last_value The value to be printed with the
#'   next active print method cycled to by `flip()` defaults to `.Last.value`. Mainly used for testing.
#' @export
flip <- function(last_value = .Last.value) {
  PACKAGE_ENV$printer_index <-
    PACKAGE_ENV$printer_index + 1
  if (PACKAGE_ENV$printer_index > length(PACKAGE_ENV$printer_fns)) {
    PACKAGE_ENV$printer_index <- 1
  }
  intersecting_classes <-
    intersect(
      vapply(PACKAGE_ENV$printed_classes, function(x) x$class, character(1)),
      class(last_value)
    )
  if (length(intersecting_classes) > 1) {
    last_value
  } else {
    invisible(last_value)
  }

}

