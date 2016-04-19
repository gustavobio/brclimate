#' Get the span of the data of an INPE climate station.
#'
#' @param station_id A numeric vector with the station id.
#' @return A character vector.
#' @export
inpe_station_period <- function(station_id = 31973) {
  dates <- rvest::html_session(paste("http://sinda.crn2.inpe.br/PCD/SITE/novo/site/historico/passo2.php?id=", station_id, sep = "")) %>%
    rvest::html_nodes(xpath = "//form//b") %>%
    rvest::html_text()
  if (length(dates) == 0L) {
    message("Station not found")
    return(NA)
  }
  setNames(as.Date(dates), c("start", "end"))
}
