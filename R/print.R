#This set of functions prints ej'Objects' to more friendly form
 
#' print an ejAttribute object
#' 
#' @param x An ejAttribute object
#' @param ... Other arguments to print (not used)
#' 
#' @export 
print.ejAttribute <- function(x, ...){
	print(jsonlite::prettify(attributeAsJSON(x)))
}

#' print an ejEvent object
#' 
#' @param x An ejEvent object
#' @param ... Other arguments to print (not used)
#' @export  
print.ejEvent <- function(x, ...){
	print(jsonlite::prettify(eventAsJSON(x)))
}

#' print an ejRecord object
#' 
#' @param x An ejRecord object
#' @param ... Other arguments to print (not used)
#' @export 
print.ejRecord <- function(x, ...){
	print(jsonlite::prettify(recordAsJSON(x)))
}

#' print an ejMetadata object
#' 
#' @param x An ejMetadata object
#' @param ... Other arguments to print (not used)
#' @export 
print.ejMetadata <- function(x,...){
	print(jsonlite::prettify(metadataAsJSON(x)))
}

#' print an ejObject object
#' 
#' @param x An ejObject object
#' @param ... Other arguments to print (not used)
#' @export 
print.ejObject <- function(x, ...){
	print(jsonlite::prettify(objectAsJSON(x)))
}
