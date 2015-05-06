#' Convert an ejObject into JSON
#' @param object The object to be converted to JSON
#' @examples
#' library(sp)
#' library(rgdal)
#' 
#' #create an attribute
#' attribute <- createAttribute("A test attribute","number",5.2,"metres")
#' 
#' #generate a polygon
#' polyPoints <- matrix(c(526870,181390,526817,181447,526880,181467,526885,181447,526909,181425,526870,181390),ncol=2,byrow=TRUE)
#' demoPolygon <- SpatialPolygons(list(Polygons(list(Polygon(polyPoints)),"1")), proj4string=CRS("+init=epsg:27700"))
#' 
#' #create an event
#' event <- createEvent(id=1, name="A test Event", date=Sys.time(), location=demoPolygon, attributes=list(attribute, attribute))
#' 
#' #create a record
#' record <- createRecord(id=1, attributes=list(attribute,attribute), events=list(event,event))
#' 
#' #generate some metadata
#' metadata <- createMetadata(list(attribute, attribute))
#' 
#' #create an EpiJSON object
#' object <- createEJObject(metadata=metadata, records=list(record,record))
#' 
#' #print it as JSON
#' objectAsJSON(object)
#' @export 
objectAsJSON <- function(object){
	jsonlite::toJSON(asList_ejObject(object), auto_unbox=TRUE)
}

#Similar functions for the other objects but not exported
#' Convert an attribute into JSON
#' @param attribute The attribute object to be converted to JSON
attributeAsJSON <- function(attribute){
	jsonlite::toJSON(asList_ejAttribute(attribute), auto_unbox=TRUE)
}

eventAsJSON <- function(event){
	jsonlite::toJSON(asList_ejEvent(event), auto_unbox=TRUE)
}

recordAsJSON <- function(event){
	jsonlite::toJSON(asList_ejRecord(record), auto_unbox=TRUE)
}

#The following functions are not exported they create JSON compatable lists from ejobjects

asList_ejAttribute <- function(attribute){
	result <- list()
	result$name <- attribute$name 
	result$type <- attribute$type
	type <- pmatch(attribute$type, c("string", "number", "integer", "boolean", "date", "base64"))
	if (type %in% c(1:3,6)){
		result$value <- attribute$value
	} else 
	if (type == 4){
		result$value <- tolower(attribute$value)
	} else
	if (type == 5){
		result$value <- strftime(attribute$value, tz = "UTC", "%Y-%m-%dT%H:%M:%OSZ")
	}
	if (!is.na(attribute$units)){
		result$units <- attribute$units
	}
	return(result)
}

asList_ejEvent <- function(event){
	result <- list()
	result$name <- event$name
	result$date <- strftime(event$date, tz = "UTC", "%Y-%m-%dT%H:%M:%OSZ")
	result$location=structure(geojsonio::geojson_list(event$location), class="list")
	result$attributes=lapply(event$attributes, asList_ejAttribute)
	return(result)
}

asList_ejRecord <- function(record){
	result <- list()
	result$id <- record$id
	result$attributes <- lapply(record$attributes, asList_ejAttribute) 
	result$events <- lapply(record$events, asList_ejEvent)
	return(result)
}

asList_ejMetadata <- function(metadata){
	result <- lapply(metadata, asList_ejAttribute)
	return(result)
}

asList_ejObject <- function(object){
	result <- list()
	result$metadata <- asList_ejMetadata(object$metadata)
	result$records <- lapply(object$records, asList_ejRecord)
	return(result)
}