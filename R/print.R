#This set of functions prints ej'Objects' to more friendly form
 
#' print an ejAttribute object
#' 
#' @param x An ejAttribute object
#' @param ... Other arguments to print (not used)
#' 
#' @export 
print.ejAttribute <- function(x, ...){
	cat("(name: ", x$name, " type:", x$type, " value:", x$value, ")\n")
}

#' print an ejEvent object
#' 
#' @param x An ejEvent object
#' @param ... Other arguments to print (not used)
#' @export  
print.ejEvent <- function(x, ...){
	cat("event:\n")
	cat("id: ", x$id, "\n")
	cat("name:", x$name, "\n")
	cat("dateStart: ", x$dateStart, "\n")
	cat("dateEnd: ", x$dateEnd, "\n")
	#cat("location: ", coordinates(x$location)[1], ", ", coordinates(x$location)[2], "\n")
	for(attribute in x$attributes){print.ejAttribute(attribute)}
}

#' print an ejRecord object
#' 
#' @param x An ejRecord object
#' @param ... Other arguments to print (not used)
#' @export 
print.ejRecord <- function(x, ...){
	cat("record:\n")
	cat("id:", x$id,"\n")
	for(attribute in x$attributes){print.ejAttribute(attribute)}
	for(event in x$events){print.ejEvent(event)}
}

#' print an ejMetadata object
#' 
#' @param x An ejMetadata object
#' @param ... Other arguments to print (not used)
#' @export 
print.ejMetadata <- function(x,...){
	cat("MetaData:\n")
	for(attribute in x){print.ejAttribute(attribute)}
}

#' print an ejObject object
#' 
#' @param x An ejObject object
#' @param ... Other arguments to print (not used)
#' @export 
print.ejObject <- function(x, ...){
	cat("EpiJSON object\n")
	print.ejMetadata(x$metadata)
	for(record in x$records){print.ejRecord(record)}
}
