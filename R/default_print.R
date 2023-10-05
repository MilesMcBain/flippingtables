globalVariables('.')

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
#' Since this function stands in for many functions simultaneously, issues with
#' argument routing and partial matching can arise when forwarding arguments with `...`.
#'
#' An example would be `default_print(x, n = 100)`, targeting 100 rows for class
#' `tbl`. When the `n` arg is forwarded to [base::print.data.frame] instead of [pillar::print.tbl]
#' it ends up getting matched to `na.print` due to partial argument matching,
#' and thus causes an error.
#'
#' `.args` is provided as a mechanism to work around the argument partial
#' matching problem. If configured, it must be a list of [print_arg()] calls
#' which are pairs of argument name alias vectors and a value. For each entry in .args
#' the first alias that matches a formal argument in the print function to be
#' called is used as the name paried with the corresponding value. If there is
#' no match, that value is not passed. This means that partial argument matching
#' cannot occur, and that it is possible to account for the same concept being
#' represented by different argument names in different print functions.
#' @examples
#' \dontrun{
#' # This example demonstrates the use of .args. Arguments can still be
#' # forwarded to all default print methods using `...` if that would not create
#' # problems - there's no harm in trying and seeing that simpler method first.
#' register_flips(
#'   printer_fns = list(
#'     function(x) default_print(x, .args = list(
#'       print_arg(c("n", "max"), 1),
#'       # Here 'n' is matched ahead of 'max',  so if n matches a formal arg exactly
#'       # nothing will be passed for max.
#'       print_arg(c("width"), 40)
#'     )),
#'     function(x) default_print(x, .args = list(
#'       print_arg(c("n"), 2),
#'       print_arg(c("max"), 20),
#'       # Here 'n' and 'max' are matched independently, both, either, or neither
#'       # will be passed depending on whether they match a formal arg exactly
#'       print_arg(c("width"), 40)
#'     ))
#'   ),
#'   printed_classes = list(
#'     print_override(class = "tbl", pkg_namespace = "pillar"),
#'     print_override(class = "data.frame", pkg_namespace = "base")
#'   )
#' )
#' }
#'
#' @param x the table to print
#' @param ... args forwarded to the default print function
#' @param .args configured args forwarded to the default print function using
#'  special argument matching rules, avoiding partial argument matching.
#'  See Details.
#' @export
default_print <- function(x, ..., .args = NULL) {

  all_args_print_arguments <-
    all(vapply(.args, function(x) inherits(x, "print_argument"), logical(1)))
  if (!all_args_print_arguments) {
    rlang::abort(".args must be either NULL or a list of ")
  }


  obj_class <-
    intersect(class(x), vapply(PACKAGE_ENV$printed_classes, function(x) x$class, character(1)))[[1]]

  default_print_method <- PACKAGE_ENV$default_prints[[obj_class]]
  aliased_args <- resolve_arg_aliases(default_print_method, .args)

  if (is.null(default_print_method)) {
    rlang::abort(
      glue::glue("Failed lookup for default print method for {obj_class}"),
      "failed_lookup_for_default_print"
    )
  }
  do.call(default_print_method, args = c(list(x), list(...), aliased_args))
}

#' @rdname default_print
#' @param arg_aliases A vector of aliases to use for this argument. The first alias matching a formal argument of the default print function will be used for the name of `arg_value`.
#' @param arg_value The value to be bound to one of the `arg_aliases` that matches a formal argument of the default print function.
#' @export
print_arg <- function(arg_aliases, arg_value) {
  if (!is.character(arg_aliases)) {
    rlang::abort(
      "'arg_aliases' must be a character vector of print argument aliases",
      "arg_aliases_not_char_vector"
    )
  }
  structure(list(aliases = arg_aliases, value = arg_value), class = "print_argument")
}

resolve_arg_aliases <- function(method, .args) {
  if (length(.args) == 0) return(NULL)

  method_arg_names <- names(formals(method))
  name_value_pairs <- lapply(.args, function(arg) {
    arg_intersection <- intersect(arg$aliases, method_arg_names)
    if (length(arg_intersection) > 0) {
      list(name = arg_intersection[[1]], value = arg$value)
    } else {
      NULL
    }
  }) %>%
    Filter(function(x) !is.null(x), .)
  arg_list <-
    stats::setNames(
      lapply(name_value_pairs, function(x) x$value),
      lapply(name_value_pairs, function(x) x$name) %>% unlist()
    )
  arg_list
}

function() {
  .args <- list(
    print_arg(c("n", "max"), 100),
    print_arg(c("wideyness", "width"), 300)
  )
  default_print_method <- pillar:::print.tbl
  method <- default_print_method
}
