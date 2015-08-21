# Functions that make using EpiJSON easier
# 
###############################################################################

#' Generate standard metadata for EpiJSON
#' 
#' Provide an ejMetadata object with standard metadata. In large part these 
#' follow the reccomendations of the NetCDF CF convention with a few additional 
#' parameters to help with dataset and model validation.
#' @param title A succinct description of what is in the file
#' @param generatorName The short name of the program. This should be URL friendly.
#'  This will appear in the 'generatorName' attribute and may be used
#'  in other systems to provide web access to results.
#' @param generatorLongName Ideally this is descriptive of what the generator is 
#'  and does. This will appear in the 'history' attribute. 
#' @param generatorVersion The version of the generator.
#' @param dataSource Free text for the source parameter. Where did this data come from? 
#' @param institution Where this data was produced?
#' @param history This attribute within the EpiJSON file provides an audit trail
#'  for the file. Provide previous history here, a timestamp followed by the generator name,
#'  generator version, username and machine name will be added at the bottom.
#' @param runUUID a Universally Unique IDentifier for this generator run. Must follow
#'  the Open Software Foundation UUID standard. Will be used for the runUUID
#'  attribute.
#' @param parameters The parameters that the generator was run with. A named list
#'  is expected and this will be used to fill in the parameters attributes.
#' @param references Published or web based references that describe the data or
#'  the methods used to produce it.
#' @param comment Free text for additional comments.
#' @note This function will generate the following attributes:
#' \itemize{
#'  \item{title} {A brief title for the dataset.}
#'  \item{institution} {Where the dataset was produced.}
#'  \item{source} {The source of the data the generator used.}
#'  \item{history} {The history of the dataset.}
#'  \item{references} {Published references for data or methods.}
#'  \item{comment} {Free text commentary on the data.}
#'  \item{runUUID} {A unique identifier for a run.}
#'  \item{parameters} {Attributes containing parameters used for 
#'  this generator run (they take their name from the names in the list with
#'  paramer_ prepended).}
#'  \item{runtime} {A record of the R session (version and attached libraries)
#'   at the point of invoking this command.}
#' }
#' @author Tom Finnie (Thomas.Finnie@@phe.gov.uk)
#' @export
createStandardMetadata <- function(title, generatorName, generatorLongName=generatorName,
		generatorVersion="", dataSource, institution="",
		history="", runUUID=generateUUID(), parameters=list(), references="",
		comment=""){
	
	#a modified version of print.sessionInfo
	captureSessionInfo<-function (x, locale = TRUE){
		mkLabel <- function(L, n) {
			vers <- sapply(L[[n]], function(x) x[["Version"]])
			pkg <- sapply(L[[n]], function(x) x[["Package"]])
			paste(pkg, vers, sep = "_")
		}
		lg <- function(..., sep=""){
			input <- c(...)
			paste(res, paste(paste(sapply(suppressWarnings(split(input,rep(1:ceiling(length(input)/4),each=4))), paste, collapse=" "),collapse="\n"), collapse=" "), sep=sep)
		}
		res <- c()
		res <- lg(x$R.version$version.string, "\n", sep = "")
		res <- lg("Platform: ", x$platform, "\n\n", sep = "")
		if (locale) {
			res<-lg("locale:\n")
			res<-lg(strsplit(x$locale, ";", fixed = TRUE)[[1]], "\n")
		}
		res<-lg("attached base packages:\n")
		res <- lg(x$basePkgs, sep=" ")
		if (!is.null(x$otherPkgs)) {
			res <- lg("\nother attached packages:\n")
			res <- lg(mkLabel(x, "otherPkgs"), sep=" ")
		}
		if (!is.null(x$loadedOnly)) {
			res <- lg("\nloaded via a namespace (and not attached):\n")
			res <- lg(mkLabel(x, "loadedOnly"), sep=" ")
		}
		res <- lg("\n")
		return(res)
	}
	#grab some information about the system
	sysinfo <- Sys.info()
	sesinfo <- sessionInfo()
	
	
	repijson::create_ejMetadata(list(
					#title
					create_ejAttribute(name="title", type="string", value=title),
					#institution
					create_ejAttribute(name="institution", type="string", value=institution),					
					#source
					create_ejAttribute(name="source", type="string", value=dataSource),					
					#history
					create_ejAttribute(name="history", type="string", value=paste(history, 
									paste(strftime(Sys.time(), "%Y-%m-%dT%H:%M:%S%z")," ",
											generatorLongName, " v", generatorVersion, " ",
											sysinfo["user"], "@", sysinfo["nodename"],
											sep=""), collapse="\n", sep="")),
					#references
					create_ejAttribute(name="references", type="string", value=references),					
					#comment
					create_ejAttribute(name="comment", type="string", value=comment),					
					#runUUID
					create_ejAttribute(name="runUUID", type="string", value=runUUID),					
					#parameters
					listToAttributes(parameters),					
					#runtime
					create_ejAttribute(name="runtime", type="string", captureSessionInfo(sesinfo))
			))
}

#' Generate a UUID
#'
#' Use R's random number generator to create a version 4 UUID
#' @author Tom Finnie (Thomas.Finnie@@phe.gov.uk)
#' @examples
#' generateUUID()
#' @export
generateUUID <- function(){
	rhex <- function(n=1){
		sample(c(0:9,letters[1:6]), n, replace=TRUE)
	}
	paste(c(rhex(8), "-", rhex(4), "-", "4", rhex(3),"-", 
					sample(c(8:9,letters[1:2]),1),rhex(3),"-", rhex(12)), collapse="")
}
