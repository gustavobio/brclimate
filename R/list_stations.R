#' List all available climate stations
#'
#' @param username INMET username. Only used if you are querying INMET.
#' @param password INMET password.
#' @param states A character vector with abbreviated Brazilian states names or "all" for all PCDs.
#' @return A data frame.
#' @export
#' @import rvest
inpe_stations <- function(states = "all") {
  calendar_page <- rvest::html_session("http://sinda.crn2.inpe.br/PCD/SITE/novo/site/historico/index.php")
  stations <- calendar_page %>%
    rvest::html_nodes(xpath = "//form//option") %>%
    rvest::html_text()
  stations <- strsplit(stations, "\\-")
  stations <- lapply(stations, function(x) c(x[1:2], paste(x[-c(1:2)], collapse = "-")))
  stations <- do.call(rbind.data.frame, stations)
  names(stations) <- c("ID", "state", "locality")
  stations$ID <- as.numeric(as.character(stations$ID))
  if ("all" %in% states) {
    return(stations)
  } else {
    return(stations[stations$state %in% toupper(states), ])
  }
}

#' @rdname inpe_stations
inmet_stations <- function(username, password, states = "all") {
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
  stations <- data.frame(stations, coordinates)
  if ("all" %in% states) {
    return(stations)
  } else {
    return(stations[stations$state %in% touppser(states), ])
  }
}
