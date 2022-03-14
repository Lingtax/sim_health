#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @return The result of calling `rhs(lhs)`.
NULL

#' Put scores in range
#'
#' @param x numeric to put in range
#' @param decimals number of decimal places
#' @param min minimum value
#' @param max maximum value
#'
#' @return a numeric
#'
#' @examples
#' ranger(3.4, decimals = 0, min = 1, max = 7)
#' ranger(0, decimals = 0, min = 1, max = 7)
ranger <- function(x, decimals = 0, min, max) {

  rnded <- round(x, decimals)

  ifelse(rnded < min,  min,
         ifelse(x > max, max,
                rnded))

}
