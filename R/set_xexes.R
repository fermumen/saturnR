
#' Set XEXES
#'
#' @param x character string with pat to location
#'
#' @return Nothing sets up a global option
#' @export
#'
set_xexes <- function(x){
  if(dir.exists(x)){
    options(XEXES = normalizePath(x))
  } else{
    stop("Could not find XEXES folder")
  }

}

#' Get XEXES
#'
#' @return character string with the path to the xexes folder
#' @export
#'
get_xexes <- function(){
  if(is.null(getOption("XEXES"))) {
    stop('XEXES not defined, use set_xexes("path")')} else{
      getOption("XEXES")
    }
}


#' dQuote
#'
#' @param x character string
#'
#' @return character with quotes around it for system calls (Windows)
#'
dQuote <- function(x){
  if (!length(x)) return(character())
  before <- after <- "\""
  paste0(before, x, after)
}

