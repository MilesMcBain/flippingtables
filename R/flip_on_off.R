#' Enable cycling between print methods with flip()
#'
#' When a configuration has been created with [register_flips()] this function
#' uses that config to reroute the print methods of the configured classes,
#' enabling printing with user-defined methods and cycling between them.
#'
#' @export
flip_on <- function() {
	if (is.null(PACKAGE_ENV$enabled)) {
    no_config_error()
	}
	if (PACKAGE_ENV$enabled) {
		return(invisible())
	}
	lapply(PACKAGE_ENV$printed_classes, function(x) {
		if (isNamespaceLoaded(x$pkg_namespace)) {
			replace_print(x)
		} else {
			setHook(packageEvent(x$pkg_namespace, "onLoad"), function(...) {
				replace_print(x)
			})
		}
	})
  PACKAGE_ENV$enabled <- TRUE
	on_message()
  invisible()

}

#' Disable cycling between print methods with flip()
#'
#' This undoes the print method rerouting done by [flip_on()]. Print methods are
#' returned to defaults for all configured classes. The configuration created by
#' [register_flips()] remains and can be enabled again using [flip_on()].
#'
#' @export
flip_off <- function() {
	if (is.null(PACKAGE_ENV$enabled)) {
    no_config_error()
	}
	if (!PACKAGE_ENV$enabled) {
		return(invisible())
	}
	PACKAGE_ENV$enabled <- FALSE
	lapply(PACKAGE_ENV$printed_classes, function(x) {
		if (isNamespaceLoaded(x$pkg_namespace)) {
			restore_print(x)
		} else {
			setHook(packageEvent(x$pkg_namespace, "onLoad"), function(...) {
				restore_print(x)
			})
		}
	})
	off_message()
  invisible()
}

replace_print <- function(print_override_info) {
  PACKAGE_ENV$default_prints[[print_override_info$class]] <-
    utils::getFromNamespace(paste0("print.", print_override_info$class), print_override_info$pkg_namespace)
  .S3method("print", print_override_info$class, dispatch_current_print)
}

restore_print <- function(print_override_info) {
  .S3method("print", print_override_info$class, PACKAGE_ENV$default_prints[[print_override_info$class]])
}

no_config_error <- function(.frame = parent.frame()) {
		rlang::abort(
			"Can't enable flipping tables, call register_flips() with config first.",
			"no_config_registered",
			.frame = .frame
		)
}

on_message <- function() {
	rlang::inform(crayon::silver("Ready to flip tables."))
}

off_message <- function() {
	rlang::inform(crayon::silver("Flipping tables stopped. Default print methods now in-use."))
}
