---
title: "EpiJSON_Vignette"
author: "Thomas Finnie; Andy South; Ellie Sherrard-Smith; Ana Bento, Thibaut Jombart"
date: "2015-05-06"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  \usepackage[utf8]{inputenc}
---

This is a demonstration of the package EpiJSON and how you can use the functions provided to change the format of data for use in different analyses.

# Validation

Demonstrating how we can go from a JSON character string or object to data frame to an obkData object

Load the required packages as necessary

```r
library(OutbreakTools)
```

```
## Loading required package: ggplot2
## Loading required package: network
## network: Classes for Relational Data
## Version 1.12.0 created on 2015-03-04.
## copyright (c) 2005, Carter T. Butts, University of California-Irvine
##                     Mark S. Handcock, University of California -- Los Angeles
##                     David R. Hunter, Penn State University
##                     Martina Morris, University of Washington
##                     Skye Bender-deMoll, University of Washington
##  For citation information, type citation("network").
##  Type help("network-package") to get started.
## 
##  OutbreakTools 0.1-13 has been loaded
```

```r
library(sp)
library(HistData)
```

```
## Error in library(HistData): there is no package called 'HistData'
```

```r
library(EpiJSON)
```

```
## Error in library(EpiJSON): there is no package called 'EpiJSON'
```


These are example data in data.frame format

#Example: data frame 1

```r
data(Snow.deaths)
```

```
## Warning in data(Snow.deaths): data set 'Snow.deaths' not found
```
Adding some dates, pumps, some genders 

```r
simulated <- Snow.deaths
```

```
## Error in eval(expr, envir, enclos): object 'Snow.deaths' not found
```

```r
simulated$gender <- c("male","female")[(runif(nrow(simulated))>0.5) +1]
```

```
## Error in nrow(simulated): object 'simulated' not found
```

```r
simulated$date <- as.POSIXct("1854-04-05") + rnorm(nrow(simulated), 10) * 86400
```

```
## Error in nrow(simulated): object 'simulated' not found
```

```r
simulated$pump <- ceiling(runif(nrow(simulated)) * 5)
```

```
## Error in nrow(simulated): object 'simulated' not found
```

```r
exampledata1<-head(simulated)
```

```
## Error in head(simulated): error in evaluating the argument 'x' in selecting a method for function 'head': Error: object 'simulated' not found
```

```r
exampledata1
```

```
## Error in eval(expr, envir, enclos): object 'exampledata1' not found
```

#Example: data.frame 2

```r
exampledata2<- data.frame(id=c("A","B","3D","4d"),
                 name=c("tom","andy","ellie","Ana"),
                 dob=c("1984-03-14","1985-11-13","1987-06-16","1987-06-16"),
                 gender=c("male","male","female","female"),
                 rec1contact=c(2,1,5,1),
                 rec1dateStart=c("2014-12-28","2014-12-29","2015-01-03","2015-01-08"),
                 rec1dateEnd=c("2014-12-30","2015-01-04","2015-01-07","2015-01-14"),
                 rec1risk=c("high","high","low","high"),  
                 rec1temp=c(39,41,41,39),
                 rec2contact=c(4,1,1,1),
                 rec2dateStart=c("2015-01-02","2015-01-12","2015-01-09","2015-01-09"),
                 rec2risk=c("high","low","high","low"),stringsAsFactors=FALSE)
exampledata2
```

```
##   id  name        dob gender rec1contact rec1dateStart rec1dateEnd
## 1  A   tom 1984-03-14   male           2    2014-12-28  2014-12-30
## 2  B  andy 1985-11-13   male           1    2014-12-29  2015-01-04
## 3 3D ellie 1987-06-16 female           5    2015-01-03  2015-01-07
## 4 4d   Ana 1987-06-16 female           1    2015-01-08  2015-01-14
##   rec1risk rec1temp rec2contact rec2dateStart rec2risk
## 1     high       39           4    2015-01-02     high
## 2     high       41           1    2015-01-12      low
## 3      low       41           1    2015-01-09     high
## 4     high       39           1    2015-01-09      low
```

################################################
## Transition 1: data.frame to EpiJSON format ##
################################################

Use the EpiJSON package to convert a data.frame object into a EpiJSON object within R:


```r
eg1 <- as.ejObject(exampledata1, recordAttributes = c("gender"), eventDefinitions = list(defineEjEvent(dateStart="date", dateEnd="date", name=NA, location=list(x="x", y="y", proj4string=""), attributes="pump")),
 		metadata=list())
```

```
## Error in eval(expr, envir, enclos): could not find function "as.ejObject"
```

```r
eg1
```

```
## Error in eval(expr, envir, enclos): object 'eg1' not found
```

Convert this into a JSON character string
using: eg1a<-r2epiJSON(eg1)


Convert this to a EpiJSON object in R
using: epiJSON2r(eg1a)



```r
eg2 <- as.ejObject(exampledata2, recordAttributes = c("name","dob","gender"),
     eventDefinitions = list(defineEjEvent(name="rec1contact",dateStart="rec1dateStart", dateEnd="rec1dateEnd", attributes=list("rec1risk","rec1temp")),
                             defineEjEvent(name="rec2contact",dateStart="rec2dateStart", dateEnd="rec2dateStart", attributes="rec2risk")),
 		metadata=list())
```

```
## Error in eval(expr, envir, enclos): could not find function "as.ejObject"
```

```r
eg2
```

```
## Error in eval(expr, envir, enclos): object 'eg2' not found
```

Convert this into a JSON character string
using: eg2a<-r2epiJSON(eg2)


Convert this to a EpiJSON object in R
using: epiJSON2r(eg2a)

#######################################################
## Transition 2: EpiJSON object to data.frame format ##
#######################################################

Use the EpiJSON package to convert a JSON object into a data.frame object:

```r
as.data.frame(eg1)
```

```
## Error in as.data.frame(eg1): error in evaluating the argument 'x' in selecting a method for function 'as.data.frame': Error: object 'eg1' not found
```

#######################################################
## Transition 3: From obkData to an EpiJSON object   ##
#######################################################

These are example data in obkData format

```r
data(ToyOutbreak) 
```

Use the EpiJSON package to convert an obkData object to JSON object into :

```r
eg3 <- as.ejObject(ToyOutbreak)
```

```
## Error in eval(expr, envir, enclos): could not find function "as.ejObject"
```

#######################################################
## Transition 4: From an EpiJSON object to obkData   ##
#######################################################

*Next function to produce*


#######################################################
## Transition 5: From an EpiJSON object to spatial   ##
#######################################################

Use the EpiJSON package to convert from an EpiJSON object to spatial (sp)

```r
example1 <- as.ejObject(simulated, recordAttributes = c("gender"),
     eventDefinitions = list(defineEjEvent(dateStart="date", dateEnd="date", name=NA, location=list(x="x", y="y", proj4string=""), attributes="pump")),
 		metadata=list())
```

```
## Error in eval(expr, envir, enclos): could not find function "as.ejObject"
```

```r
#this is causing failure with
#Error in as.data.frame.default(X[[1L]], ...) : 
#  cannot coerce class ""ejAttribute"" to a data.frame
#sp_eg1 <- as.SpatialPointsDataFrame.ejObject(example1)

#plot(sp_eg1,pch=20,col="green")
#text(10,17,"Example from Snow Deaths data")
```

*The story continues...!!!*
