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
  if (is.null(PACKAGE_ENV$enabled)) {
    no_config_error()
  }
  if (!PACKAGE_ENV$enabled) {
    rlang::inform("flip() is currently disabled, use flip_on() to enable it.")
    return(invisible(last_value))
  }
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
  method_name <- names(PACKAGE_ENV$printer_fns)[[PACKAGE_ENV$printer_index]]
  if (!is.null(method_name) && nzchar(method_name)) {
    flip_message(method_name)
  }
  if (length(intersecting_classes) > 1) {
    last_value
  } else {
    invisible(last_value)
  }

}

flip_message <- function(method_name) {
  name <- emphasised(method_name)
    glue::glue(
      preamble(),
      hype(),
      postamble()
    ) %>%
    cat()
}

plain <- function(...) {
  crayon::silver(crayon::italic(...))
}

emphasised <- function(...) {
  crayon::italic(crayon::bold(...))
}

preamble <- function() {
  plain("(╯°□°）╯︵ ┻━┻ \"")
}

postamble <- function() {
  plain("\"\n")
}

hypes <-
   c(
    "{name}, I choose you!",
    "It's up to you, {name}!",
    "{name}, you're up.",
    "You got this {name}.",
    "Let's go, {name}!",
    "Gooooooooo {name}!",
    "Let's do this, {name}.",
    "I believe in you, {name}.",
    "We can do this, {name}."
   )

hype <- function() {
  sample(hypes, 1)
}
