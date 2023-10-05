# default_print works with argument routing

    Code
      print(mtcars)
    Output
           mpg cyl disp hp drat wt qsec vs am gear carb
       [ reached 'max' / getOption("max.print") -- omitted 32 rows ]

---

    Code
      print(palmerpenguins::penguins)
    Output
      # A tibble: 344 x 8
        species island    bill_length_mm
        <fct>   <fct>              <dbl>
      1 Adelie  Torgersen           39.1
      # i 343 more rows
      # i 5 more variables:
      #   bill_depth_mm <dbl>,
      #   flipper_length_mm <int>,
      #   body_mass_g <int>, sex <fct>,
      #   year <int>

---

    Code
      print(mtcars)
    Output
                mpg cyl disp  hp drat   wt  qsec vs am gear carb
      Mazda RX4  21   6  160 110  3.9 2.62 16.46  0  1    4    4
       [ reached 'max' / getOption("max.print") -- omitted 31 rows ]

---

    Code
      print(palmerpenguins::penguins)
    Output
      # A tibble: 344 x 8
        species island    bill_length_mm
        <fct>   <fct>              <dbl>
      1 Adelie  Torgersen           39.1
      2 Adelie  Torgersen           39.5
      # i 342 more rows
      # i 5 more variables:
      #   bill_depth_mm <dbl>,
      #   flipper_length_mm <int>,
      #   body_mass_g <int>, sex <fct>,
      #   year <int>

