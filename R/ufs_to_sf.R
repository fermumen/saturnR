#' Read geometry function
#'
#' This function allows you to read UFS/N file's into an R SF.
#' @param file The file to read.
#' @param SATDB Path to the SATDB exe folder
#' @param lat_long when set to TRUE it will convert coordinates to
#' @param clean_up when TRUE removes the VDU, KEY and LPX files
#' @keywords read, ufs, coordinates
#' @export
#' @examples
#' UFS_to("file.UFS")
