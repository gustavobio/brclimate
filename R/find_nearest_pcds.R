#' Order INPE climate stations by their distances in kilometers from a given coordinate.
#'
#' @param lat Latitude in decimals
#' @param long Longitude in decimals
#' @return A data frame ordered by the distances to the PCDs.
#' @export
nearest_inpe_station <- function(lat = -22.410259, long = -47.560156) {
  distances <- apply(pcds[, c("lat", "long")], 1, function(x) get_distances(lat, long, x[1], x[2]))
  ordered_pcds <- data.frame(pcds, distance = distances)
  ordered_pcds[order(distances, decreasing = F), ]
}
