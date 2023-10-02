#' @export
register_flips <- function(printer_fns, printed_classes) {
	if (!is.list(printed_classes)) {
		rlang::abort(
			"printed_classes must be a list",
			"printed_classes_not_list"
		)
	}
	if (!all(vapply(printed_classes, inherits, logical(1), "print_override_target"))) {
		rlang::abort(
			"printed_classes should be a list of print_override() calls",
			"missing_print_override_target_class"
		)
	}
	specified_classes <-
		vapply(printed_classes, function(x) x$class, character(1))
	if (any(duplicated(specified_classes))) {
		rlang::abort(
			"printed_classes contains repeated entries for 1 or more classes",
			"repeated_class_printed_classes"
		)
	}
	if (any(vapply(printer_fns, function(x) identical(body(x), quote(UseMethod("print"))), logical(1)))) {
		rlang::abort(
			"print() was supplied as a printer_fns this would cause an infinite dispatch loop, please use default_print() to signify the default print method for the class",
			"print_generic_used_as_printer_fns"
		)
	}

	if (any(specified_classes == "data.frame")) {
		# if data.frame was specified move it to last,
		# since when searching for the default print for a class
		# we will want to consider printing the data.frame last since all other
		# classes are a specialisation of it.
		data.frame_index <- which(specified_classes == "data.frame")
		printed_classes <- c(printed_classes[-data.frame_index], printed_classes[data.frame_index])
	}


	PACKAGE_ENV$printer_fns <- printer_fns
	PACKAGE_ENV$printed_classes <- printed_classes
	PACKAGE_ENV$printer_index <- 1
	PACKAGE_ENV$default_prints <- list()


	PACKAGE_ENV$registered <- TRUE

	TRUE
}

#' @export
print_override <- function(class, pkg_namespace) {
	if (!(rlang::is_string(class) && rlang::is_string(pkg_namespace))) {
		rlang::abort("'class' and 'pkg_namespace' must both be length 1 character vectors")
	}
	structure(
		list(class = class, pkg_namespace = pkg_namespace),
		class = "print_override_target"
	)
}


function() {
	printed_classes <- register_flips(
		printer_fns = list(paint::paint, knitr::kable, default_print),
		printed_classes = list(
			print_override(class = "tbl", pkg_namespace = "pillar"),
			print_override(class = "data.frame", pkg_namespace = "base"),
			print_override(class = "data.table", pkg_namespace = "data.table")
		)
	)
	flip_on()
	penguins
	flip()
	flip()
	# it's sticky!
	penguins
	flip()
}
