flip_on <- function() {
	if (is.null(PACKAGE_ENV$registered) || PACKAGE_ENV$registered == FALSE) {
		rlang::abort("Can't enable flipping tables, call register_flips() with config first.")
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

  invisible()

}

flip_off <- function() {
	if (is.null(PACKAGE_ENV$registered) || PACKAGE_ENV$registered == FALSE) {
		rlang::abort("Can't disable flipping tables, call register_flips() with config first.")
	}
	lapply(PACKAGE_ENV$printed_classes, function(x) {
		if (isNamespaceLoaded(x$pkg_namespace)) {
			restore_print(x)
		} else {
			setHook(packageEvent(x$pkg_namespace, "onLoad"), function(...) {
				restore_print(x)
			})
		}
	})

  invisible()
}

replace_print <- function(print_override_info) {
  PACKAGE_ENV$default_prints[[print_override_info$class]] <-
    getFromNamespace(paste0("print.", print_override_info$class), print_override_info$pkg_namespace)
  .S3method("print", print_override_info$class, dispatch_current_print)
}

restore_print <- function(print_override_info) {
  .S3method("print", print_override_info$class, PACKAGE_ENV$default_prints[[print_override_info$class]])
}
