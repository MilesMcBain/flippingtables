
<!-- README.md is generated from README.Rmd. Please edit that file -->

# flippingtables

<!-- badges: start -->
<!-- badges: end -->

The goal of flippingtables is to …

## Installation

You can install the development version of flippingtables from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("MilesMcBain/flippingtables")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(flippingtables)
library(palmerpenguins)

register_flips(
        printer_fns = list(
      paint::paint,
      pillar::glimpse,
      default_print),
        printed_classes = list(
            print_override(class = "tbl", pkg_namespace = "pillar"),
            print_override(class = "data.frame", pkg_namespace = "base"),
            print_override(class = "data.table", pkg_namespace = "data.table")
        )
    )
#> [1] TRUE
    flip_on()
    penguins
#> tibble [344, 8]
#> species           fct Adelie Adelie Adelie Adelie Adelie Ad~
#> island            fct Torgersen Torgersen Torgersen Torgers~
#> bill_length_mm    dbl 39.1 39.5 40.3 NA 36.7 39.3
#> bill_depth_mm     dbl 18.7 17.4 18 NA 19.3 20.6
#> flipper_length_mm int 181 186 195 NA 193 190
#> body_mass_g       int 3750 3800 3250 NA 3450 3650
#> sex               fct male female female NA female male
#> year              int 2007 2007 2007 2007 2007 2007

    flip()
#> Rows: 344
#> Columns: 8
#> $ species           <fct> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adel…
#> $ island            <fct> Torgersen, Torgersen, Torgersen, Torgersen, Torgerse…
#> $ bill_length_mm    <dbl> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, …
#> $ bill_depth_mm     <dbl> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, …
#> $ flipper_length_mm <int> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186…
#> $ body_mass_g       <int> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, …
#> $ sex               <fct> male, female, female, NA, female, male, female, male…
#> $ year

    # it's sticky!
    penguins
#> Rows: 344
#> Columns: 8
#> $ species           <fct> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adel…
#> $ island            <fct> Torgersen, Torgersen, Torgersen, Torgersen, Torgerse…
#> $ bill_length_mm    <dbl> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, …
#> $ bill_depth_mm     <dbl> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, …
#> $ flipper_length_mm <int> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186…
#> $ body_mass_g       <int> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, …
#> $ sex               <fct> male, female, female, NA, female, male, female, male…
#> $ year              <int> 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007…

    flip()
## A tibble: 344 × 8
#    species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
#    <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
#  1 Adelie  Torgersen           39.1          18.7               181        3750
#  2 Adelie  Torgersen           39.5          17.4               186        3800
#  3 Adelie  Torgersen           40.3          18                 195        3250
#  4 Adelie  Torgersen           NA            NA                  NA          NA
#  5 Adelie  Torgersen           36.7          19.3               193        3450
#  6 Adelie  Torgersen           39.3          20.6               190        3650
#  7 Adelie  Torgersen           38.9          17.8               181        3625
#  8 Adelie  Torgersen           39.2          19.6               195        4675
#  9 Adelie  Torgersen           34.1          18.1               193        3475
# 10 Adelie  Torgersen           42            20.2               190        4250
## ℹ 334 more rows
## ℹ 2 more variables: sex <fct>, year <int>
## ℹ Use `print(n = ...)` to see more rows
```
