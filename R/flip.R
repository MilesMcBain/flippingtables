#' @export
flip <- function(last_value = .Last.value) {
  PACKAGE_ENV$printer_index <-
    PACKAGE_ENV$printer_index + 1
  if (PACKAGE_ENV$printer_index > length(PACKAGE_ENV$printer_fns)) {
    PACKAGE_ENV$printer_index <- 1
  }
  intersecting_classes <-
    intersect(
      vapply(printed_classes, function(x) x$class, character(1)),
      class(last_value)
    )
  if (length(intersecting_classes) > 1) {
    print(last_value)
  }
}

