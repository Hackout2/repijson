#' Create an attribute
#' This package outlines the aspects of the data for EpiJSON
#'
#' This function defines attributes
#' output \code{ejAttribute}
#'
#' @param name name of the attribute, usually a column name
#' @param type type of data 'string', 'float', 'integer', 'boolean' or 'date'
#' @param value value of this attribute
#'
#'
#' @return an ejAttribute object
#' @export
create_ejAttribute <- function (name, type, value, units=NA){
	#todo: validity checking of input values
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
