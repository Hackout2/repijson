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
#' @examples
#' dF<- data.frame(id=c("A","B","3D"),
#'                 name=c("tom","andy","ellie"),
#'                 dob=c("1984-03-14","1985-11-13","1987-06-16"),
#'                 gender=c("male","male","female"),
#'                 rec1contact=c(2,1,5),
#'                 rec1dateStart=c("2014-12-28","2014-12-29","2015-01-03"),
#'                 rec1dateEnd=c("2014-12-30","2015-01-04","2015-01-07"),
#'                 rec1risk=c("high","high","low"),  
#'                 rec1temp=c(39,41,41),
#'                 rec2contact=c(4,1,1),
#'                 rec2date=c("2015-01-02","2015-01-12","2015-01-09"),
#'                 rec2risk=c("high","low","high"),stringsAsFactors=FALSE)
#' 
#' create_ejAttribute(name="name",type="int",value=dF$name[1])
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
#' @examples
#' dF<- data.frame(id=c("A","B","3D"),
#'                 name=c("tom","andy","ellie"),
#'                 dob=c("1984-03-14","1985-11-13","1987-06-16"),
#'                 gender=c("male","male","female"),
#'                 rec1contact=c(2,1,5),
#'                 rec1dateStart=c(as.POSIXct(tz="GMT","2014-12-28"),as.POSIXct(tz="GMT","2014-12-29"),as.POSIXct(tz="GMT","2015-01-03")),
#'                 rec1dateEnd=c(as.POSIXct(tz="GMT","2014-12-30"),as.POSIXct(tz="GMT","2015-01-04"),as.POSIXct(tz="GMT","2015-01-09")),
#'                 rec1risk=c("high","high","low"),  
#'                 rec1temp=c(39,41,41),
#'                 rec2contact=c(4,1,1),
#'                 rec2date=c("2015-01-02","2015-01-12","2015-01-09"),
#'                 rec2risk=c("high","low","high"),stringsAsFactors=FALSE)
#'                 
#' event1<-create_ejEvent(id=NA, 
#'                       name="rec1contact",
#'                       dateStart=dF$rec1dateStart[1],
#'                       dateEnd=dF$rec1dateEnd[1],
#'                       location="",
#'                       attributes=list(create_ejAttribute(name="rec1risk",type="str",value=dF$rec1risk[1]),
#'                              create_ejAttribute(name="rec1temp",type="int",value=dF$rec1temp[1])))
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
#' @examples
#' dF<- data.frame(id=c("A","B","3D"),
#'                 name=c("tom","andy","ellie"),
#'                 dob=c("1984-03-14","1985-11-13","1987-06-16"),
#'                 gender=c("male","male","female"),
#'                 rec1contact=c(2,1,5),
#'                 rec1dateStart=c("2014-12-28","2014-12-29","2015-01-03"),
#'                 rec1dateEnd=c("2014-12-30","2015-01-04","2015-01-07"),
#'                 rec1risk=c("high","high","low"),  
#'                 rec1temp=c(39,41,41),
#'                 rec2contact=c(4,1,1),
#'                 rec2dateStart=c("2015-01-02","2015-01-12","2015-01-09"),
#'                 rec2risk=c("high","low","high"),stringsAsFactors=FALSE)
#' 
#' record1<-create_ejRecord(id=dF$id[1], 
#'              attributes=list(create_ejAttribute(name="name",type="str",value=dF$name[1]),
#'                              create_ejAttribute(name="dob",type="date",value=dF$dob[1]),
#'                              create_ejAttribute(name="gender",type="str",value=dF$gender[1])),
#'              events=list(create_ejEvent(id=NA, 
#'                                        name="rec1contact",
#'                                        dateStart=as.POSIXct(dF$rec1dateStart[1]),
#'                                        dateEnd=as.POSIXct(dF$rec1dateEnd[1]),
#'                                        location="",
#'                                        attributes=list(create_ejAttribute(name="rec1risk",type="str",value=dF$rec1risk[1]),
#'                                                        create_ejAttribute(name="rec1temp",type="int",value=dF$rec1temp[1])
#'                                                                  )),
#'                          create_ejEvent(id=NA, 
#'                                       name="rec2contact",
#'                                       dateStart=dF$rec2dateStart[1],
#'                                       dateEnd=dF$rec2dateStart[1],
#'                                       location="",
#'                                              attributes=list(create_ejAttribute(name="rec2risk",type="str",value=dF$rec2risk[1]))
#'                                        )
#'                              )  
#'                      )     
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
#' @examples
#' dF<- data.frame(id=c("A","B","3D"),
#'                 name=c("tom","andy","ellie"),
#'                 dob=c("1984-03-14","1985-11-13","1987-06-16"),
#'                 gender=c("male","male","female"),
#'                 rec1contact=c(2,1,5),
#'                 rec1dateStart=c("2014-12-28","2014-12-29","2015-01-03"),
#'                 rec1dateEnd=c("2014-12-30","2015-01-04","2015-01-07"),
#'                 rec1risk=c("high","high","low"),  
#'                 rec1temp=c(39,41,41),
#'                 rec2contact=c(4,1,1),
#'                 rec2dateStart=c("2015-01-02","2015-01-12","2015-01-09"),
#'                 rec2risk=c("high","low","high"),stringsAsFactors=FALSE)
#' 
#' obj1<-create_ejObject (metadata=list(list(name="ID",type="str",value=dF$id[1]),
#'                                     list(name="name",type="str",value=dF$name[1]),
#'                                     list(name="rec1contact",type="str",value=dF$rec1contact[1]),
#'                                     list(name="rec1date",type="date",value=dF$rec1date[1])),
#'                                                  records=list(create_ejRecord(id=dF$id[1], 
#'                                                                            attributes=list(create_ejAttribute(name="name",type="str",value=dF$name[1]),
#'                                                                                            create_ejAttribute(name="dob",type="date",value=dF$dob[1]),
#'                                                                                            create_ejAttribute(name="gender",type="str",value=dF$gender[1])),
#'                                                                            events=list(create_ejEvent(id=NA, 
#'                                                                                                    name="rec1contact",
#'                                                                                                    dateStart=as.POSIXct(dF$rec1dateStart[1]),
#'                                                                                                    dateEnd=as.POSIXct(dF$rec1dateEnd[1]),
#'                                                                                                    location="",
#'                                                                                                    attributes=list(create_ejAttribute(name="rec1risk",type="str",value=dF$rec1risk[1]),
#'                                                                                                                    create_ejAttribute(name="rec1temp",type="int",value=dF$rec1temp[1])
#'                                                                                                                 )),
#'                                                                                        create_ejEvent(id=NA, 
#'                                                                                                    name="rec2contact",
#'                                                                                                    dateStart=dF$rec2dateStart[1],
#'                                                                                                    dateEnd=dF$rec2dateStart[1],
#'                                                                                                    location="",
#'                                                                                                    attributes=list(create_ejAttribute(name="rec2risk",type="str",value=dF$rec2risk[1]))
#'                                                                                                      )
#'                                                                                                )  
#'                                                                                          )
#'                                                                                    )
#'                                                                              ) 
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
#' @examples
#' dF<- data.frame(id=c("A","B","3D"),
#'                 name=c("tom","andy","ellie"),
#'                 dob=c("1984-03-14","1985-11-13","1987-06-16"),
#'                 gender=c("male","male","female"),
#'                 rec1contact=c(2,1,5),
#'                 rec1dateStart=c("2014-12-28","2014-12-29","2015-01-03"),
#'                 rec1dateEnd=c("2014-12-30","2015-01-04","2015-01-07"),
#'                 rec1risk=c("high","high","low"),  
#'                 rec1temp=c(39,41,41),
#'                 rec2contact=c(4,1,1),
#'                 rec2dateStart=c("2015-01-02","2015-01-12","2015-01-09"),
#'                 rec2risk=c("high","low","high"),stringsAsFactors=FALSE)
#' 
#' metadata1<-create_ejMetadata (attributes=list(create_ejAttribute(name="name",type="str",value=dF$name),
#'                                            create_ejAttribute(name="dob",type="date",value=dF$dob),
#'                                            create_ejAttribute(name="gender",type="str",value=dF$gender),
#'                                            create_ejAttribute(name="rec1risk",type="str",value=dF$rec1risk),
#'                                            create_ejAttribute(name="rec1temp",type="int",value=dF$rec1temp),
#'                                            create_ejAttribute(name="rec2risk",type="str",value=dF$rec2risk)))
#'                                            
#'                              
#'               
#' @return an ejMetadata object
#' @export
create_ejMetadata <- function(attributes){
	structure(attributes, class="ejMetadata")
}
