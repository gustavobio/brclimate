#' Scrape (harvest from the web) climate data from stations in Brazil.
#'
#' @param station_id A numeric vector with the station id
#' @param start_date Start date
#' @param end_date End date (Maximum of one year between start and end dates)
#' @return A data frame containing the climate data and attributes.
#' @export
get_climate <- function(station_id = 31973, start_date = "2005/01/01", end_date  = "2005/02/02") {
  start_date <- as.Date(start_date)
  end_date <- as.Date(end_date)
  if ((end_date - start_date) > 365) stop("The maximum interval is 365 days.")
  calendar_page <- rvest::html_session(
    paste("http://sinda.crn2.inpe.br/PCD/SITE/novo/site/historico/passo2.php?id=", station_id, sep = "")
    )
  form <- calendar_page %>% rvest::html_node("form") %>% html_form()
  form_completed <- rvest::set_values(form,
                               dia_inicial = format(start_date, "%d"),
                               mes_inicial = format(start_date, "%m"),
                               ano_inicial = format(start_date, "%Y"),
                               dia_final = format(end_date, "%d"),
                               mes_final = format(end_date, "%m"),
                               ano_final = format(end_date, "%Y")
  )
  r <- rvest::submit_form(calendar_page, form_completed)
  if (httr::headers(r)$`content-type` != "application/x-msexcel") {
    message("No data for the selected period")
    return(NA)
  }
  temp_file <- tempfile()
  writeBin(httr::content(r$response), temp_file)
  raw_page <- xml2::read_html(readChar(temp_file, nchars = 10000000L))
  fields <- raw_page %>%
    rvest::html_nodes(xpath = "//tr//td//b") %>%
    rvest::html_text()
  processed_page <- raw_page %>%
    rvest::html_nodes(xpath = "//tr//td") %>%
    rvest::html_text()
  n_fields <- length(fields)
  indexes <- mapply(seq, (n_fields + 1):(n_fields * 2), length(processed_page), by = n_fields)
  climate <- data.frame(matrix(processed_page[c(indexes)], ncol = n_fields))
  names(climate) <- gsub("\\s*\\(.*\\)", "", fields)
  climate <- tidyr::separate(climate, DataHora, c("Data", "Hora"), sep = " ")
  structure(climate, fields = fields)
}
