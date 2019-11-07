#' Get path to saturnR example
#'
#' saturnR comes bundled with some example files in its `inst/extdata`
#' directory. This function make them easy to access. (Obtained from readxl package)
#'
#' @param path Name of file. If `NULL`, the example files will be listed.
#' @export
#' @examples
#' readxl_example()
saturnR_example <- function(path = NULL) {
  if (is.null(path)) {
    dir(system.file("extdata", package = "saturnR"))
  } else {
    system.file("extdata", path, package = "saturnR", mustWork = TRUE)
  }
}
