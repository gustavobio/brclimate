#' List all available climate stations (PCDs)
#'
#' @param states A character vector with abbreviated Brazilian states names or "all" for all PCDs.
#' @return A data frame.
get_pcds <- function(states = "all") {
  calendar_page <- html_session("http://sinda.crn2.inpe.br/PCD/SITE/novo/site/historico/index.php")
  stations <- calendar_page %>%
    html_nodes(xpath = "//form//option") %>%
    html_text()
  stations <- strsplit(stations, "\\-")
  stations <- lapply(stations, function(x) c(x[1:2], paste(x[-c(1:2)], collapse = "-")))
  stations <- do.call(rbind.data.frame, stations)
  names(stations) <- c("ID", "state", "locality")
  stations$ID <- as.numeric(as.character(stations$ID))
  if ("all" %in% states) {
    return(stations)
  } else {
    return(stations[stations$state %in% states, ])
  }
}
