
<!-- README.md is generated from README.Rmd. Please edit that file -->

# simhealth

<!-- badges: start -->
<!-- badges: end -->

The goal of simhealth is to simulate consumer data from a mental health
service to support training of data analysts, scientists, and engineers.

## Installation

You can install the development version of simhealth from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Lingtax/simhealth")
```

## Example

This is a basic example which shows you how to generate the 4 key
tables.

``` r
library(simhealth)
library(dplyr)
library(purrr)

demos <- purrr::rerun(200, create_client()) %>% 
  do.call(rbind.data.frame, .) %>%  
  dplyr::distinct(client_id, .keep_all = TRUE)

contacts <-  create_contacts(demos) %>% localise_clients()

intakes <- create_intakes(contacts)

k10s <- create_k10s(contacts, intakes) 
```

If the consumer has an entry in the client table, but no intake, assume
they presented for service navigation only.

Using these tables common reporting tasks can be completed such as the
following:

-   Summarise the demographics presenting in this service.
    (`dplyr::summarise`, and `janitor::tabyl`, or
    `tableone::CreateTableOne`, or `gtsummary::tbl_summary`)

-   Do as above, but break down by service location (`dplyr::left_join`
    & `dplyr::group_by`).

-   For only those consumers presenting with IAR = 5, give the breakdown
    of presenting issues (`dplyr::filter`, `janitor::tabyl`).

-   The consumer data system does not calculate totals for the k10,
    calculate a k10 total per measurement occasion (`dplyr::mutate`).

-   Calculate the average number of service contacts per IAR level
    (`dplyr::left_join`, `dplyr::group_by`, & `dplyr::summarise`).

-   Test the difference between entry and exit k10s
    (`tidyr::pivot_wider` & `stats::t.test` OR `lme4::lmer`).

-   Make a histogram of the intake dates (`ggplot2::ggplot`).

-   Replicate the above with one panel per service location (A join, and
    `ggplot2::facet_wrap`)
