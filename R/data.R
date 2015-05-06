#'
#' Toy line list dataset
#'
#' This dataset replicates the structure of disease outbreak line lists, where the unit of observation is a case. It contains a mixture of patient meta-data (e.g. gender, name) and time-stamped records (e.g. hospital admission).
#'
#' @format A data.frame with 5 rows and 16 columns containing the following variables:
#' \itemize{
#'  \item id ID of the patient
#'  \item name name of the patient
#'  \item dob date of birth of the patient (format: yyyy-mm-dd)
#'  \item gender gender of the patient
#'  \item date.of.onset date of symptom onsets
#'  \item date.of.admission date of hospital admission
#'  \item date.of.discharge date of hospital discharge
#'  \item hospital hospital of admission
#'  \item fever has fever been observed? (yes/no)
#'  \item sleepy has the patient been sleepy? (yes/no)
#'  \item contact1.id ID of contact 1
#'  \item contact1.date date of contact 1
#'  \item contact2.id ID of contact 2
#'  \item contact2.date date of contact 2
#'  \item contact3.id ID of contact 3
#'  \item contact3.date date of contact 3
#' }
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @examples
#' data(toyll)
#' toyll
"toyll"
