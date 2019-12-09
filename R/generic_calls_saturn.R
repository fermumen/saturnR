# Generic calls


#' P1X Generic Call
#'
#' @param net1 ufs of the main network
#' @param net2 ufs of the second network
#' @param mat1 ufm of the first matrix (if not detected automatically)
#' @param mat2 ufm of the first matrix (if not detected automatically)
#' @param key key file to use
#'
#' @return nothing executes call
#' @export
#'
p1x <- function(net1, net2, mat1, mat2, key) {
  # we define p1x using get xexes
  P1X <- file.path(get_xexes(), "$P1X.exe")
  if (missing(net1)) {
    stop("net1 argument missing, you need to define a ufs file as net1")
  }
  command <- c(dQuote(P1X), dQuote(net1))
  # for every non missing argument we append an argument to the system command.
  if (!missing(net2)) {
    command <- c(command, dQuote(net2))
  }

  if (!missing(mat1)) {
    mat <- paste("M 10", dQuote(mat1))
    command <- c(command, mat)
  }

  if (!missing(mat2)) {
    mat <- paste("M 9", dQuote(mat2))
    command <- c(command, mat)
  }

  if (!missing(key)) {
    mat <- paste("KEY", dQuote(key), "VDU vdu")
    command <- c(command, mat)
  }

  command <- paste(command, collapse = " ")
  system(command)

}
