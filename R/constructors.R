# a list of all the known attribute types. Used here and in JSONGenerator
ejAttributeTypes <- c("string", "number", "integer", "boolean", "date", "base64")

#' Create an attribute
#' This package outlines the aspects of the data for EpiJSON
#'
#' This function defines attributes
#' output \code{ejAttribute}
#'
#' @param name name of the attribute
#' @param type type of data 'string', 'number', 'integer', 'boolean', 'date' or 
#'  'base64'
#' @param value value of this attribute
#' @param units The units for value. May be omitted.
#'
#'
#' @return an ejAttribute object
#' @examples
#' characterAttribute <- create_ejAttribute(name="Format name", type="string", 
#' 											value="EpiJSON!") 
#' numericAttribute <- create_ejAttribute(name="Width of building", type="number", 
#' 											value=5.2,"metres")
#' integerAttribute <- create_ejAttribute(name="Days since last accident", type="integer", 
#' 											value=integer(2)) 
#' logicalAttribute <- create_ejAttribute(name="Customer satisfied", type="boolean", 
#' 											value=TRUE) 
#' dateAttributeOne <- create_ejAttribute(name="Birthdate", type="date", 
#' 											value=as.Date("1998-08-21")) 
#' dateAttributeTwo <- create_ejAttribute(name="Lunch", type="date", 
#' 											value=as.POSIXct("2015-05-06 12:30")) 
#' if (require(base64enc, quietly=TRUE)){
#' 	binaryAttribute <- create_ejAttribute(name="Lunch", type="base64", 
#'  											value=base64encode(as.raw(0:255)))
#' }
#' @export
create_ejAttribute <- function (name, type, value, units=NA){
	if((length(name) != 1) || (typeof(name) != "character"))
		stop("name must be a character vector of length 1.")
	if((length(type) != 1)  || (!(type %in% ejAttributeTypes)))
		stop("type must be length one and one of: ", paste(ejAttributeTypes, 
			collapse=", "), "\nLength was:",length(type), " type given was:", type)
	#TODO: check value matches the type
	attributeType <- pmatch(type, ejAttributeTypes)
	if ((attributeType %in% c(1,6)) && (!is.character(value))){
		stop("When type is string or base64, value must be character.")
	} else  
	if ((attributeType == 2) && (!is.numeric(value))){
		stop("When type is number, value must be numeric.")
	} else 
	if (attributeType == 3){
		if(!is.numeric(value))
			stop("When type is integer, value must be numeric.")
		if (!is.integer(value)){
			warning("'integer' type specified to create_ejAttribute but value is not integer typed. Will be truncated.")
			value <- integer(value)
		}
	} else
	if ((attributeType == 4) && (!is.logical(value))){
		stop("When type is boolean, value must be logical.")
	} else
	if ((attributeType == 5) && (!("POSIXt" %in% class(value)))){
		stop("When type is date, value must be a POSIX date/time object.")
	} 
	structure(list(
					name=name,
					type=type,
					value=value,
					units=units
			), class="ejAttribute")
}

#' Create an event
#'
#' This function defines events
#' output \code{ejEvent}
#'
#' @param id identifier for the event
#' @param name name of the event, usually a column name
#' @param date date (or timestamp) for event
#' @param location location for event
#' @param attributes list of attributes associated with this event
#'
#'
#' @return an ejEvent object
#' @export
create_ejEvent <- function(id=NA, name, date, location, attributes){
	#todo: validity checking of input values
	structure(list(
					id=id,
					name=name,
					date=date,
					location=location,
					attributes=attributes
			), class="ejEvent")
}

#' Create a record
#'
#' This function defines records
#' output \code{ejRecord}
#'
#' @param id This is the unique identifier of the record, usually a column name and the essential information for any data
#' @param attributes list of attributes associated with this record
#' @param events list of events associated with this record
#'
#'
#' @return an ejEvent object
#' @export
#'
create_ejRecord <- function(id, attributes, events){
	#todo: Should check the valididty of input parameters
	structure(list(
					id=id,
					attributes=attributes,
					events=events
					), class="ejRecord")
}


#' Create an object
#'
#' This function defines epiJSON objects
#' output \code{ejObject}
#'
#' @param metadata metadata for the whole ejObject
#' @param records list of records
#'
#'
#' @return an ejObject object
#' @export
create_ejObject <- function(metadata, records){
	structure(list(
					metadata=metadata,
					records=records
	), class="ejObject")
}

#' Create metadata
#'
#' This function defines epiJSON Metadata
#' output \code{ejMetadata}
#'
#' @param attributes list of attributes of the metadata
#'
#'
#' @return an ejMetadata object
#' @export
create_ejMetadata <- function(attributes){
	structure(attributes, class="ejMetadata")
}
