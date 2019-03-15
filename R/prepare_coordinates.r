#' Prepare coordinates file
#'
#' This function allows you to read coordinates.dat file and
#' extract the coordinates of all the nodes in a saturn network
#' Use ufs_to_sf for link coordinates and an SF object
#' @param wd character; the working directory where the coordinates file exist
#' @param dat character; the name of the file to read e.g. "coordinates.dat"
#' @param save_file  logical; TRUE to save the final file as .csv, else FALSE; default to TRUE
#' @param output_file the name of the output csv file
#' @keywords coordinates, nodes
#' @export
#' @examples
#' prepare_coordinates("2014_coordinates.dat")

prepare_coordinates <- function(dat, wd = ".", save_file = TRUE,
								output_file = if(save_file) "Coordinates.csv") {


		# Read file
		setwd(wd)
		coord <- read.delim(dat, header = FALSE,
							sep = ",", comment.char = "*",
							stringsAsFactors = FALSE)
		# Modify node column
		coord$Node <- sapply(1:nrow(coord), function(i) {
							V1 <- strsplit(coord$V1[i], " ")[[1]]
							return(V1[length(V1)])
							})
		# Check which are zones in order to remove (those with C at the start)
		coord$Zone <- sapply(1:nrow(coord), function(i) {
							V1 <- strsplit(coord$V1[i], " ")[[1]]
							return(V1[1])
							})

		# Remove zone entries
		coord <- coord[-which(coord$Zone == "C"), c(4,2,3)]
		coord <- coord[!duplicated(coord$Node),]
		names(coord) = c("node", "easting", "northing")

		# Save file
		if(save_file) write.csv(coord, output_file, row.names = FALSE)

		return(coord)

	}
