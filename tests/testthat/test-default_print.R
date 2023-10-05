test_that("default_print works with argument routing", {
  palmerpenguins::penguins


  register_flips(
    printer_fns = list(
      function(x) default_print(x, .args = list(
        print_arg(c("n", "max"), 1),
        print_arg(c("width"), 40)
      )),
      function(x) default_print(x, .args = list(
        print_arg(c("n"), 2),
        print_arg(c("max"), 20),
        print_arg(c("width"), 40)
      ))
    ),
    printed_classes = list(
      print_override(class = "tbl", pkg_namespace = "pillar"),
      print_override(class = "data.frame", pkg_namespace = "base")
    )
  )
  flip_on()

  expect_snapshot(print(mtcars))

  expect_snapshot(print(palmerpenguins::penguins))

  flip()

  expect_snapshot(print(mtcars))

  expect_snapshot(print(palmerpenguins::penguins))
})
