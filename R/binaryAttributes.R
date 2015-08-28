# Author: Thomas Finnie
###############################################################################

#' Convert a file to a base64 encoded attribute
#' 
#' Read a file in binary mode and convert the bytesteam into a base64 encoded 
#' ejAttribute
#' @param file The file to read and convert
#' @param name The name for the attribute
#' @author Thomas Finnie (thomas.finnie@@phe.gov.uk)
#' @return An ejAttribute containing the file
#' @export 
fileToAttribute <- function(file, name=as.character(file)){
	create_ejAttribute(
			name=name,
			type="base64",
			value= base64enc::base64encode(file)
	)
}

#' Convert a base64 attribute to a file
#' 
#' Convert a base64 encoded attribute to a file. 
#' @param attribute The ejAttribute to convert
#' @param file The filename to write to
#' @author Thomas Finnie (thomas.finnie@@phe.gov.uk) 
#' @return invisilbe NULL
#' @export 
attributeToFile <- function(attribute, file){
	if(class(attribute)!="ejAttribute")
		stop("Attribute must be an ejAttribute")
	
	if (attribute$type!="base64")
		stop("Attribute must be a base64 encode attribute")
	
	writeBin(base64enc::base64decode(attribute$value), file)
	invisible(NULL)
}