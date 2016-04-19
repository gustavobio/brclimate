#' Get the distance in kilometers between two points.
#'
#' @param lat1 Latitude in decimals
#' @param long1 Longitude in decimals
#' @param lat2 Latitude in decimals
#' @param long2 Longitude in decimals
#' @return A numeric vector with the distance in kilometers.
get_distances <- function(lat1, long1, lat2, long2) {
  deg2rad <- function(deg) {
    return(deg * (pi/180))
  }
  R <- 6371; # Radius of the earth in km
  d_lat <- deg2rad(lat2 - lat1)
  d_long <- deg2rad(long2 - long1)
  a <-
    sin(d_lat/2) * sin(d_lat/2) +
    cos(deg2rad(lat1)) * cos(deg2rad(lat2)) *
    sin(d_long/2) * sin(d_long/2)
  c1 <- 2 * atan2(sqrt(a), sqrt(1-a))
  d <- R * c1; # Distance in km
  return(d)
}
