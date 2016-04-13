#' Get climate data from INMET
#'
#' @param station_id The ID of the station
#' @param start_date Start date
#' @param end_date End date
#' @param monthly Daily or Monthy data?
#' @param username INMET username
#' @param password INMET password
#' @export
get_inmet_data <- function(station_id = 83726, start_date = "01/01/1901", end_date = "13/04/2016", monthly = TRUE, username, password) {
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
  if (monthly) {
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
  print(paste(base_url, method, query_string, sep = ""))
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

get_inmet_stations <- function(username, password) {
  auth_page <- rvest::html_session(
    "http://www.inmet.gov.br/projetos/rede/pesquisa/inicio.php"
  )
  auth_form <- auth_page %>% rvest::html_node("form") %>% html_form()
  filled_auth_form <- rvest::set_values(auth_form,
                                        mCod = username,
                                        mSenha = password
  )
  session <- rvest::submit_form(auth_page, filled_auth_form)
  response <- session %>%
    jump_to("http://www.inmet.gov.br/projetos/rede/pesquisa/mapas_mensal_sem.php?&mOpcaoAtrib11=1") %>%
    rvest::html_nodes(xpath = "//script") %>%
    rvest::html_text()
  raw_page <- readLines(textConnection(response), warn = FALSE)
  raw_names <- raw_page[grep("font", raw_page)]
  stations <- regmatches(raw_names, regexec("<b>.+b>", raw_names))
  stations <- gsub("[<b>|<///b>]", "", stations)
  stations <- gsub("Estação: ", "", stations)
  coordinates <- regmatches(raw_names, regexec("Latitude:.*altitude", raw_names))
  coordinates <- gsub("<br \\/>", "", coordinates)
  coordinates <- gsub(" altitude", "", coordinates)
  coordinates <- gsub("Latitude: ", "", coordinates)
  coordinates <- gsub("Longitude: ", "", coordinates)
  coordinates <- trimws(coordinates)
  coordinates <- gsub("\\s+", " ", coordinates)
  coordinates <- gsub(" ", "|", coordinates)
  coordinates <- separate(data.frame(coordinates = coordinates), coordinates, c("lat", "long"), sep = "\\|", convert = TRUE)
  stations <- separate(data.frame(station = stations), station, c("ID", "locality", "state"), sep = "-", convert = TRUE)
  stations$locality <- trimws(stations$locality)
  stations$state <- trimws(stations$state)
  data.frame(stations, coordinates)
}
