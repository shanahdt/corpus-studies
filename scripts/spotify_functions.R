library(spotifyr)

load_spotify_credentials <- function(){
  Sys.setenv(SPOTIFY_CLIENT_ID = '05af946589794553974d293435950a5d')
  Sys.setenv(SPOTIFY_CLIENT_SECRET = '2ad94ed8cd844667b98acd84ff65bd45')
  access_token <- get_spotify_access_token()
}
