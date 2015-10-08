#' Generate a UUID
#'
#' Use R's random number generator to create a version 4 UUID following RFC4122
#' @author Tom Finnie (Thomas.Finnie@@phe.gov.uk)
#' @examples
#' generateUUID()
#' @export
generateUUID <- function(){
	rhex <- function(n=1){
		sample(c(0:9,letters[1:6]), n, replace=TRUE)
	}
	paste(c(rhex(8), "-", rhex(4), "-", "4", rhex(3),"-", 
					sample(c(8:9,letters[1:2]),1),rhex(3),"-", rhex(12)), collapse="")
}

#' Check strings for conformance to RFC4122
#' 
#' Check to see that strings conform to the UUID specification
#' @param x a character vector of strings to check for conformance
#' @author Tom Finnie (Thomas.Finnie@@phe.gov.uk)
#' @examples
#' is.UUID(generateUUID())
#' 
#' is.UUID(replicate(5, generateUUID()))
#' @export
is.UUID <- function(x){
	result <- rep(FALSE, length(x))
	result[grep("^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}", x)] <- TRUE
	return(result)
}