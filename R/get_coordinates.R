#' Get the geographical coordinates of a climate station (PCD)
#'
#' @param station_id A numeric vector with the station id
#' @return A named numeric vector
#' @export
get_coordinates <- function(station_id = 31973) {
  calendar_page <- rvest::html_session(paste("http://sinda.crn2.inpe.br/PCD/SITE/novo/site/historico/passo2.php?id=", station_id, sep = ""))
  source_code <- httr::content(calendar_page$response, as = "text")
  matches <- regexec("Latitude\\:.*Longitude\\:.*\\, Altitude", source_code)
  if (matches == -1) {
    message("No available coordinates")
    return(NA)
  }
  coordinates <- regmatches(source_code, matches)
  coordinates <- gsub("[A-z]|\\s|\\:", "", coordinates)
  coordinates <- gsub("\\,$", "", coordinates)
  coordinates <- as.numeric(strsplit(coordinates, "\\,")[[1]])
  if (any(is.na(coordinates))) {
    message("No available coordinates.")
    return(NA)
  }
  names(coordinates) <- c("lat", "long")
  coordinates
}
