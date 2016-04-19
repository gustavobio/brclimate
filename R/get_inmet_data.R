#' Get climate data from INMET
#'
#' @param station_id The ID of the station.
#' @param start_date Start date.
#' @param end_date End date.
#' @param intervale daily or monthly (default) data?
#' @param username INMET username.
#' @param password INMET password.
#' @export
inmet_station_data <- function(station_id = 83726, start_date = "01/01/1901", end_date = "13/04/2016", interval = "monthly", username, password) {
  auth_page <- rvest::html_session(
    "http://www.inmet.gov.br/projetos/rede/pesquisa/inicio.php"
  )
  auth_form <- auth_page %>% rvest::html_node("form") %>% html_form()
  filled_auth_form <- rvest::set_values(auth_form,
                                 mCod = username,
                                 mSenha = password
                                 )
  session <- rvest::submit_form(auth_page, filled_auth_form)
  base_url <- "http://www.inmet.gov.br/projetos/rede/pesquisa/"
  interval <- match.arg(interval, c("monthly", "daily"))
  if (interval == "monthly") {
    method <- "gera_serie_txt_mensal.php?"
    query_string <- paste("mRelEstacao=",
                          station_id,
                          "&btnProcesso=serie&mRelDtInicio=",
                          start_date,
                          "&mRelDtFim=",
                          end_date,
                          "&mAtributos=,,,,,,,1,1,1,,1,1,1,1,1,", sep = "")
  } else {
    method <- "gera_serie_txt.php?"
    query_string <- paste("&mRelEstacao=",
                          station_id,
                          "&btnProcesso=serie&mRelDtInicio=",
                          start_date,
                          "&mRelDtFim=",
                          end_date,
                          "&mAtributos=,,1,1,,,,,,1,1,,1,1,1,1,", sep = "")
  }
  col_classes <- c(rep(NA, 11), "NULL")
  col_classes[3] <- "character"
  response <- session %>%
    jump_to(paste(base_url, method, query_string, sep = "")) %>%
    rvest::html_nodes(xpath = "//pre") %>%
    rvest::html_text()
  climate_data <- readLines(textConnection(response), warn = FALSE)
  lat <- gsub(".*\\:\\s", "", climate_data[5]) # This is kinda ugly, but I'm lazy.
  long <- gsub(".*\\:\\s", "", climate_data[6])
  station_name <- trimws(gsub("^\\w*\\s*\\:", "", climate_data[4]))
  structure(read.csv2(text = climate_data, skip = 16, dec = ".", sep = ";",
                      colClasses = col_classes),
            lat = lat, long = long, station_name = station_name)
}
