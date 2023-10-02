dispatch_current_print <- function(x, ...) {
  PACKAGE_ENV$printer_fns[[PACKAGE_ENV$printer_index]](x, ...)
}
