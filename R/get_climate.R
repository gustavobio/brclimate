#' Scrape (harvest from the web) historical climate data.
#'
#' @param station_id A numeric vector with the station id
#' @param start_date Start date
#' @param end_date End date (Maximum of one year between start and end dates)
#' @return A list with a data frame containing the climate data and a vector indicating the name of the fields and their units.
get_climate <- function(station_id = 31973, start_date = "2005/01/01", end_date  = "2005/02/02") {
  start_date <- as.Date(start_date)
  end_date <- as.Date(end_date)
  if ((end_date - start_date) > 365) stop("The maximum interval is 365 days.")
  calendar_page <- html_session(paste("http://sinda.crn2.inpe.br/PCD/SITE/novo/site/historico/passo2.php?id=", station_id, sep = ""))
  form <- calendar_page %>% html_node("form") %>% html_form()
  form_completed <- set_values(form,
                               dia_inicial = format(start_date, "%d"),
                               mes_inicial = format(start_date, "%m"),
                               ano_inicial = format(start_date, "%Y"),
                               dia_final = format(end_date, "%d"),
                               mes_final = format(end_date, "%m"),
                               ano_final = format(end_date, "%Y")
  )
  r <- submit_form(calendar_page, form_completed)
  if (headers(r)$`content-type` != "application/x-msexcel") {
    message("No data for the selected period")
    return(NA)
  }
  temp_file <- tempfile()
  writeBin(content(r$response), temp_file)
  raw_page <- read_html(readChar(temp_file, nchars = 10000000L))
  fields <- raw_page %>%
    html_nodes(xpath = "//tr//td//b") %>%
    html_text()
  processed_page <- raw_page %>%
    html_nodes(xpath = "//tr//td") %>%
    html_text()
  n_fields <- length(fields)
  indexes <- mapply(seq, (n_fields + 1):(n_fields * 2), length(processed_page), by = n_fields)
  climate <- data.frame(matrix(processed_page[c(indexes)], ncol = n_fields))
  names(climate) <- gsub("\\s*\\(.*\\)", "", fields)
  climate <- separate(climate, DataHora, c("Data", "Hora"), sep = " ")
  return(list(climate = climate, fields = fields))
}
