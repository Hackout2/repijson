% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/constructors.R
\name{create_ejEvent}
\alias{create_ejEvent}
\title{Create an event}
\usage{
create_ejEvent(id = generateUUID(), name, date = NULL, location = NULL,
  attributes = list())
}
\arguments{
\item{id}{identifier for the event (a valid UUID)}

\item{name}{name of the event, usually a column name}

\item{date}{date (or timestamp) for event}

\item{location}{location for event}

\item{attributes}{list of attributes associated with this event}
}
\value{
an ejEvent object
}
\description{
This function defines events
output \code{ejEvent}
}
\examples{
#' #generate a polygon
library(sp)
polyPoints <- matrix(c(526870,181390,526817,181447,526880,181467,
		526885,181447,526909,181425,526870,181390),ncol=2,byrow=TRUE)
demoPolygon <- sp::SpatialPolygons(list(sp::Polygons(list(sp::Polygon(polyPoints)),"1")),
		proj4string=sp::CRS("+init=epsg:27700"))


#Create an attribute
integerAttribute <- create_ejAttribute(name="Days since last accident", type="integer", 
  value=integer(2)) 
logicalAttribute <- create_ejAttribute(name="Customer satisfied", type="boolean", 
  value=TRUE)
 
#create an event
event <- create_ejEvent(id=generateUUID(), name="A test Event", date=Sys.time(),
		location=demoPolygon, attributes=list(integerAttribute, logicalAttribute))
}

