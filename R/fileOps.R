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

#' convert a list representing an attribute into an ejAttribute
#' 
#' @param x A list with name, type and value components may optionally include
#'  a unit component
#' @return an ejAttribute
attributeParser <- function(x){
	if (is.null(x$units)){
		return(create_ejAttribute(name=x$name, type=x$type, value=x$value))
	} else {
		return(create_ejAttribute(name=x$name, type=x$type, value=x$value, units=x$units))
	}
}

#' convert a list representing an event into an ejEvent
#' 
#' @param x A list with id, name, attributes and one or both of date/location 
#'  components.
#' @return an ejRecord
eventParser <- function(x){
	#if there is a date convert it to POSIXct
	newDate <- if(is.null(x$date)){
		NULL
	} else{
		as.POSIXct(x$date)
	}

	#covert the GeoJSON list to a spatial object
	#TODO: there must be a be a better way do do this than the round trip via 
	# gdal!
	newLocation <- if (is.null(x$location)){
		NULL
	} else {
		tmpfl <- tempfile()
		#write out the location data (note the class conversion)
		geojsonio::geojson_write(structure(x$location, class="geo_list"), file=tmpfl)
		on.exit(unlink(tmpfl))
		spob <- rgdal::readOGR(tmpfl, "OGRGeoJSON")
		#remove the dataframe
		do.call(gsub("DataFrame", "", class(spob)[1]), list(spob))
	}

	return(create_ejEvent(
			id=x$id,
			name=x$name,
			date=newDate,
			location=newLocation,
			attributes=lapply(x$attributes, attributeParser)
			))
}

#' convert a list representing a record into an ejRecord
#' 
#' @param x A list with id, attributes and events components
#' @return an ejRecord
recordParser <- function(x){
	create_ejRecord(
		id=x$id,
		attributes=lapply(x$attributes, attributeParser),
		events=lapply(x$events, eventParser))
}

#' convert a textfile in epiJSON form into an ejObject
#' 
#' Takes an epiJSON string in a connection (file) and converts to an ejObject.  
#' @param file an epiJSON filename or string to convert to R
#' 
#' @return An ejObject
#' @examples
#' listJSON <- read.epijson( system.file("extdata//example.JSON", package="repijson"))
#'  
#' @export
read.epijson <- function(file){
	jsonList <- rjson::fromJSON(file=file)
	#TODO: Need some schema checks here
	create_ejObject(
		metadata=create_ejMetadata(lapply(jsonList$metadata, attributeParser)),
		records=lapply(jsonList$records, recordParser))
}