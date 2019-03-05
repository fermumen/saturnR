#' Read UFS function
#'
#' This function allows you to read UFS assignment data into R.
#' @param file The file to read.
#' @param MX Path to the MX exe folder
#' @param remove_txt when set to TRUE it will remove the interim txt files
#' @param clean_up when TRUE removes the VDU, KEY and LPX files
#' @keywords read, ufm
#' @export
#' @examples
#' read_ufm("file.UFM")
