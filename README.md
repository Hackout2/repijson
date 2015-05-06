[![Travis-CI Build Status](https://travis-ci.org/Hackout2/repijson.png?branch=master)](https://travis-ci.org/Hackout2/repijson)






*EpiJSON* is a generic JSON format for storing epidemiological data.   

*repijson* is an R package that allows conversion between EpiJSON files and R data formats.

This vignette is a demonstration of the package *repijson*.


# Installing *repijson*
-------------
To install the development version from github:

```r
library(devtools)
install_github("hackout2/repijson")
```


Then, to load the package, use:

```r
library("repijson")
```

# The *EpiJSON* format

This is a simplified representation of the *EpiJSON* format.   

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png) 




# Validation

Demonstrating how we can go from a JSON character string or object to data frame to an obkData object

Load the required packages as necessary

```r
library(OutbreakTools)
library(sp)
library(HistData)
library(repijson)
```


These are example data in data.frame format

#Example: data frame 1

```r
data(Snow.deaths)
```
Adding some dates, pumps, some genders 

```r
simulated <- Snow.deaths
simulated$gender <- c("male","female")[(runif(nrow(simulated))>0.5) +1]
simulated$date <- as.POSIXct("1854-04-05") + rnorm(nrow(simulated), 10) * 86400
simulated$pump <- ceiling(runif(nrow(simulated)) * 5)

exampledata1<-head(simulated)
exampledata1
```

```
##   case         x         y gender                date pump
## 1    1 13.588010 11.095600 female 1854-04-13 10:55:26    5
## 2    2  9.878124 12.559180   male 1854-04-14 17:05:54    5
## 3    3 14.653980 10.180440 female 1854-04-13 23:50:10    3
## 4    4 15.220570  9.993003   male 1854-04-12 18:01:20    1
## 5    5 13.162650 12.963190 female 1854-04-13 19:10:31    1
## 6    6 13.806170  8.889046 female 1854-04-15 00:04:18    3
```

#Example: data.frame 2

```r
exampledata2<- data.frame(id=c("A","B","3D","4d"),
                 name=c("tom","andy","ellie","Ana"),
                 dob=c("1984-03-14","1985-11-13","1987-06-16","1987-06-16"),
                 gender=c("male","male","female","female"),
                 rec1contact=c(2,1,5,1),
                 rec1date=c("2014-12-28","2014-12-29","2015-01-03","2015-01-08"),
                 rec1risk=c("high","high","low","high"),  
                 rec1temp=c(39,41,41,39),
                 rec2contact=c(4,1,1,1),
                 rec2date=c("2015-01-02","2015-01-12","2015-01-09","2015-01-09"),
                 rec2risk=c("high","low","high","low"),stringsAsFactors=FALSE)
exampledata2
```

```
##   id  name        dob gender rec1contact   rec1date rec1risk rec1temp
## 1  A   tom 1984-03-14   male           2 2014-12-28     high       39
## 2  B  andy 1985-11-13   male           1 2014-12-29     high       41
## 3 3D ellie 1987-06-16 female           5 2015-01-03      low       41
## 4 4d   Ana 1987-06-16 female           1 2015-01-08     high       39
##   rec2contact   rec2date rec2risk
## 1           4 2015-01-02     high
## 2           1 2015-01-12      low
## 3           1 2015-01-09     high
## 4           1 2015-01-09      low
```

################################################
## Transition 1: data.frame to EpiJSON format ##
################################################

Use the *repijson* package to convert a data.frame object into a EpiJSON object within R:

```r
eg1 <- as.ejObject(exampledata1,	
    recordAttributes = "gender",	
    eventDefinitions = list(defineEjEvent(date="date",	name=NA, location=list(x="x", y="y", proj4string=""), attributes="pump")),
 		metadata=list())		       
eg1
```

```
## EpiJSON object
## MetaData:
## record:
## id: 1 
## (name:  gender  type: character  value: female )
## event:
## id:  1 
## name: NA 
## date:  -3651743074 
## (name:  pump  type: double  value: 5 )
## record:
## id: 2 
## (name:  gender  type: character  value: male )
## event:
## id:  1 
## name: NA 
## date:  -3651634446 
## (name:  pump  type: double  value: 5 )
## record:
## id: 3 
## (name:  gender  type: character  value: female )
## event:
## id:  1 
## name: NA 
## date:  -3651696590 
## (name:  pump  type: double  value: 3 )
## record:
## id: 4 
## (name:  gender  type: character  value: male )
## event:
## id:  1 
## name: NA 
## date:  -3651803920 
## (name:  pump  type: double  value: 1 )
## record:
## id: 5 
## (name:  gender  type: character  value: female )
## event:
## id:  1 
## name: NA 
## date:  -3651713369 
## (name:  pump  type: double  value: 1 )
## record:
## id: 6 
## (name:  gender  type: character  value: female )
## event:
## id:  1 
## name: NA 
## date:  -3651609343 
## (name:  pump  type: double  value: 3 )
```

Convert this into a JSON character string
using: eg1a<-r2epiJSON(eg1)


Convert this to a EpiJSON object in R
using: epiJSON2r(eg1a)

```r
eg2 <- as.ejObject(exampledata2, recordAttributes = c("name","dob","gender"),
     eventDefinitions = list(defineEjEvent(name="rec1contact",date="rec1date", attributes=list("rec1risk","rec1temp")),
                             defineEjEvent(name="rec2contact",date="rec2date", attributes="rec2risk")),
 		metadata=list())
eg2
```

```
## EpiJSON object
## MetaData:
## record:
## id: 1 
## (name:  name  type: character  value: tom )
## (name:  dob  type: character  value: 1984-03-14 )
## (name:  gender  type: character  value: male )
## event:
## id:  1 
## name: 2 
## date:  2014-12-28 
## (name:  rec1risk  type: character  value: high )
## (name:  rec1temp  type: double  value: 39 )
## event:
## id:  2 
## name: 4 
## date:  2015-01-02 
## (name:  rec2risk  type: character  value: high )
## record:
## id: 2 
## (name:  name  type: character  value: andy )
## (name:  dob  type: character  value: 1985-11-13 )
## (name:  gender  type: character  value: male )
## event:
## id:  1 
## name: 1 
## date:  2014-12-29 
## (name:  rec1risk  type: character  value: high )
## (name:  rec1temp  type: double  value: 41 )
## event:
## id:  2 
## name: 1 
## date:  2015-01-12 
## (name:  rec2risk  type: character  value: low )
## record:
## id: 3 
## (name:  name  type: character  value: ellie )
## (name:  dob  type: character  value: 1987-06-16 )
## (name:  gender  type: character  value: female )
## event:
## id:  1 
## name: 5 
## date:  2015-01-03 
## (name:  rec1risk  type: character  value: low )
## (name:  rec1temp  type: double  value: 41 )
## event:
## id:  2 
## name: 1 
## date:  2015-01-09 
## (name:  rec2risk  type: character  value: high )
## record:
## id: 4 
## (name:  name  type: character  value: Ana )
## (name:  dob  type: character  value: 1987-06-16 )
## (name:  gender  type: character  value: female )
## event:
## id:  1 
## name: 1 
## date:  2015-01-08 
## (name:  rec1risk  type: character  value: high )
## (name:  rec1temp  type: double  value: 39 )
## event:
## id:  2 
## name: 1 
## date:  2015-01-09 
## (name:  rec2risk  type: character  value: low )
```

Convert this into a JSON character string
using: eg2a<-r2epiJSON(eg2)


Convert this to a EpiJSON object in R
using: epiJSON2r(eg2a)

#######################################################
## Transition 2: EpiJSON object to data.frame format ##
#######################################################

Use the *repijson* package to convert a JSON object into a data.frame object:

```r
as.data.frame(eg1)
```

```
##   id gender               date         x         y  CRS  pump
## 1  1 female 1854-04-13 10:55:26 13.588010 11.095600 <NA>    3
## 2  2 female 1854-04-14 17:05:54  9.878124 12.559180 <NA>    5
## 3  3 female 1854-04-13 23:50:10 14.653980 10.180440 <NA>    5
## 4  4 female 1854-04-12 18:01:20 15.220570  9.993003 <NA>    5
## 5  5 female 1854-04-13 19:10:31 13.162650 12.963190 <NA>    5
## 6  6 female 1854-04-15 00:04:18 13.806170  8.889046 <NA>    5
```

#######################################################
## Transition 3: From obkData to an EpiJSON object   ##
#######################################################

These are example data in obkData format

```r
data(ToyOutbreak) 
```

Use the *repijson* package to convert an obkData object to JSON object into :

```r
eg3 <- as.ejObject(ToyOutbreak)
```

#######################################################
## Transition 4: From an EpiJSON object to obkData   ##
#######################################################

*Next function to produce*


#######################################################
## Transition 5: From an EpiJSON object to spatial   ##
#######################################################

Use the *repijson* package to convert from an EpiJSON object to spatial (sp)

```r
example1 <- as.ejObject(simulated, recordAttributes = c("gender"),
     eventDefinitions = list(defineEjEvent(date="date", name=NA, location=list(x="x", y="y", proj4string=""), attributes="pump")),
 		metadata=list())

#this is causing failure with
#Error in as.data.frame.default(X[[1L]], ...) : 
#  cannot coerce class ""ejAttribute"" to a data.frame
#sp_eg1 <- as.SpatialPointsDataFrame.ejObject(example1)

#plot(sp_eg1,pch=20,col="green")
#text(10,17,"Example from Snow Deaths data")
```

*The story continues...!!!*

