#' The general functions that are used in multiple sections of the epiJSON package
#' 
#' @param x A dataframe  
#' 
#' @examples
#' dF<- data.frame(id=c("A","B","3D"),name=c("tom","andy","ellie"),
#'                 dob=c("1984-03-14","1985-11-13","1987-06-16"),
#'                 gender=as.factor(c("male","male","female")),
#'                 rec1contact=c(2,1,5),
#'                 rec1date=as.POSIXct(c("2014-12-28","2014-12-29","2015-01-03")),
#'                 rec1risk=c("high","high","low"),
#'                 rec1temp=c(39.5,41.3,41.8),
#'                 rec2contact=as.integer(c(4,1,1)),
#'                 rec2date=as.POSIXct(c("2015-01-02","2015-01-12","2015-01-09")),
#'                 rec2risk=c("high","low","high"),
#'                 logical=c(FALSE,TRUE,TRUE),
#' 				   stringsAsFactors=FALSE)  
#'                 
#' repijson:::dataFrameToAttributes(dF)
#'   
#' @return result A list of attributes that comprise the dataframe
#' Convert a dataframe to attributes
#' 
dataFrameToAttributes <- function(x){
	#check for invalid dataframes
	if ((nrow(x) == 0) || (ncol(x) == 0))
		return(list())
	#get the attribute name and type from the columns
	attributeNames <- names(x)
	attributeTypes <- lapply(x, class)
	
	#R type to EpiJSON type conversion (where 1:1 interpretation is valid)
	attributeTypes <- gsub("character", "string", attributeTypes)
	attributeTypes <- gsub("numeric", "number", attributeTypes)
	attributeTypes <- gsub("logical", "boolean", attributeTypes)
	attributeTypes[grep("POSIXt", attributeTypes)] <- "date"
	
	#iterate over the expanded grid and create an attribute for each data position
	result <- apply(expand.grid(i=1:nrow(x), j=1:ncol(x)), 1, function(attpos){
				type <- attributeTypes[[attpos[2]]]
				value <- x[attpos[1],attpos[2]]
				#R type to EpiJSON type conversion (where 1:1 interpretation is not valid)
				if (type == "factor"){
					type <- "string"
					value <- as.character(value)
				}
				if (type == "Date"){
					type <- "date"
					value <- as.POSIXlt(value)
				}
				create_ejAttribute(name=attributeNames[attpos[2]], type=type, value=value)
			})
	return(result)
}

#' Convert a list with named elements into attributes
#' 
#' Take a list and generate ejAttributes from it 
#' @param x A list with named elements
#' @author Thomas.Finnie (Thomas.Finnie@@phe.gov.uk
#' @return result A list of attributes that comprise the list
#' @examples 
#'  test <- list(testNumber=1, 5, aword="meow")
#'  listToAttributes(test)
#' @export
listToAttributes <- function(x){
	#check for invalid lists
	if (class(x) !="list")
		return(list())
	if (is.null(names(x))){
		return(list())
	}
	#remove all unnamed elements
	x <- x[names(x)[names(x)!=""]]
	
	#get the attribute name and type from the columns
	attributeNames <- names(x)
	attributeTypes <- lapply(x, class)
	
	#R type to EpiJSON type conversion (where 1:1 interpretation is valid)
	attributeTypes <- gsub("character", "string", attributeTypes)
	attributeTypes <- gsub("numeric", "number", attributeTypes)
	attributeTypes <- gsub("logical", "boolean", attributeTypes)
	attributeTypes[grep("POSIXt", attributeTypes)] <- "date"
	
	#iterate over the expanded grid and create an attribute for each data position
	result <- lapply(1:length(x), function(attpos){
				type <- attributeTypes[attpos]
				value <- x[[attpos]]
				#R type to EpiJSON type conversion (where 1:1 interpretation is not valid)
				if (type == "factor"){
					type <- "string"
					value <- as.character(value)
				}
				if (type == "Date"){
					type <- "date"
					value <- as.POSIXlt(format(value))
				}
				create_ejAttribute(name=attributeNames[attpos], type=type, value=value)
			})
	return(result)
}

#' Return a value only if another is not NA
#' 
#' @param x The value to test for NA
#' @param trueValue The value to return if x is not NA
#' @param defaultValue The value to return if x is NA
#' @return defaultValue if x is NA or trueValue if x is not NA
#' @note Not terribly different from an ifelse but is more graceful with NULL 
#'  values
notNA <- function(x, trueValue, defaultValue=NA){
	if (!is.null(x[1])){
		if(!is.na(x[1]))
			return(trueValue)
	}
	return(defaultValue)
}

#' Convert a json type list into a spatial object
#' 
#' @param x a list representing a geojson object
geojsonListToSp <- function(x){
	#TODO: there must be a be a better way do do this than the round trip via 
	# gdal!
	tmpfl <- tempfile()
	#write out the location data (note the class conversion)
	writeLines(jsonlite::toJSON(x, auto_unbox=TRUE), tmpfl)
	on.exit(unlink(tmpfl))
	spob <- rgdal::readOGR(tmpfl, "OGRGeoJSON", verbose=FALSE)
	#remove the dataframe
	do.call(gsub("DataFrame", "", class(spob)[1]), list(spob))
}

#' Convert a spatial object to a json type list
#' 
#' @param x a spatial object
spToGeojsonList <- function(x){
	#convert to dataframe if required (as gdal can only write dataframes)
	xClass <- class(x)[1]
	if (length(grep("DataFrame", xClass)) == 0){
		x <- do.call(paste(xClass,"DataFrame",sep=""), list(x, data=data.frame(null=rep(NA, length(x)))))
	}
	tmpfl <- tempfile()
	#write out the object
	rgdal::writeOGR(x,tmpfl, "OGRGeoJSON", driver="GeoJSON", verbose=FALSE)
	on.exit(unlink(tmpfl))
	json <- jsonlite::fromJSON(readLines(tmpfl), simplifyVector=FALSE)
	return(json)	
}