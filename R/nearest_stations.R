#' Order climate stations by their distances in kilometers from a given point.
#'
#' @param lat Latitude in decimals.
#' @param long Longitude in decimals.
#' @param source "inpe", "inmet", or "both" (default).
#' @return A data frame ordered by the distances to the stations.
#' @export
nearest_stations <- function(lat = -22.410259, long = -47.560156, source = "both") {
  distances <- apply(stations[, c("lat", "long")], 1, function(x) get_distances(lat, long, x[1], x[2]))
  source <- match.arg(source, choices = c("both", "inpe", "inmet"))
  ordered_stations <- data.frame(stations, distance = distances)
  ordered_stations <- ordered_stations[order(ordered_stations$distance), ]
  if (source != "both") ordered_stations <- ordered_stations[ordered_stations$source %in% source, ]
  ordered_stations
}
