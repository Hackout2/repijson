# Operators for epijson classes
#
###############################################################################

#' Add an object to a metadata object
#' @param metadata an ejMetadata object
#' @param x the object to be added
#' @export 
`+.ejMetadata` <- function(metadata, x){
	#if x is an ejAttribute then add it to the metadata
	if (class(x) == "ejAttribute"){
		result <- create_ejMetadata(c(metadata, list(x)))
	} else if (class(x) == "ejMetadata"){
		#combine two lots of metadata
		result <- create_ejMetadata(c(metadata, x))
	} else if (class(x) == "list"){
		#lets assume that this is a list of ejAttributes
		result <- create_ejMetadata(c(metadata, x))
	} else {
		#TODO: could be clever here and use the attributes from list to generate
		# attributes
		stop("Cannot add ", class(x), " to an ejMetadata object.")
	}
	return(result)
}

