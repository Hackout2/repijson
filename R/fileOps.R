# Read wnd write EpiJSON to and from connections (files)
###############################################################################

#' Write out an ejObject
#' 
#' Write an ejObject out to a file or connection in JSON form
#' @param x an ejObject to be written
#' @param pretty Should the JSON be prittified (made more human readble with
#'   whitespace)?
#' @param file either a character string naming a file or a connection open
#'   for writing.  ‘""’ indicates output to the console.
#' @param fileEncoding character string: if non-empty declares the encoding to
#'   be used on a file (not a connection) so the character data
#'   can be re-encoded as they are written.  See ‘file’.
#' @param append Should the output be appended?
#' @author Thomas Finnie (Thomas.Finnie@@phe.gov.uk)
#' @export 
write.epijson <- function(x, pretty=FALSE, file="", fileEncoding = "", 
		append =FALSE){
	if(class(x) != "ejObject")
		stop("x must be an oject of type ejObject.")
	#open or check the connection
	if (file == "")
		file <- stdout()
	else if (is.character(file)) {
		file <- if (nzchar(fileEncoding))
					file(file, ifelse(append, "a", "w"), encoding = fileEncoding)
				else file(file, ifelse(append, "a", "w"))
		on.exit(close(file))
	}
	else if (!isOpen(file, "w")) {
		open(file, "w")
		on.exit(close(file))
	}
	if (!inherits(file, "connection"))
		stop("'file' must be a character string or connection")
	
	#write out the object as JSON
	if (pretty){
		writeLines(geojsonio::pretty(objectAsJSON(x)), con=file, sep="\n")
	} else {
		writeLines(objectAsJSON(x), con=file, sep="\n")
	}
	invisible(NULL)
}