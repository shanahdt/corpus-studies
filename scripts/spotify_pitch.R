library(spotifyr)
library(tidyverse)
#remotes::install_github('jaburgoyne/compmus')
library(compmus)
source("/Users/danielshanahan/gitcloud/Teaching/corpus_studies/scripts/spotify_functions.R")
library(corrplot)


### loading spotify credentials
load_spotify_credentials <- function(){
  Sys.setenv(SPOTIFY_CLIENT_ID = '05af946589794553974d293435950a5d')
  Sys.setenv(SPOTIFY_CLIENT_SECRET = '2ad94ed8cd844667b98acd84ff65bd45')
  access_token <- get_spotify_access_token()
}

load_spotify_credentials()

### going back to "shake it off" pitches.
shake_it_off <-
  get_tidy_audio_analysis("0cqRj7pUJDkTCEsJkx8snD") |>
  select(segments) |>
  unnest(segments) |>
  select(start, duration, pitches)

### chroma vectors: 
# Pitch content is given by a “chroma” vector, 
# corresponding to the 12 pitch classes C, C#, D to B, 
# with values ranging from 0 to 1 that describe the relative 
# dominance of every pitch in the chromatic scale. For example 
# a C Major chord would likely be represented by large 
# values of C, E and G (i.e. classes 0, 4, and 7).

# Vectors are normalized to 1 by their strongest dimension, 
# therefore noisy sounds are likely represented by values 
# that are all close to 1, while pure tones are described 
# by one value at 1 (the pitch) and others near 0. 
# As can be seen below, the 12 vector indices are a 
# combination of low-power spectrum values at their 
# respective pitch frequencies.

### how can we grab a pitch distribution from this?
pitches <- shake_it_off$pitches

### write a loop that grabs all of the pitches
x <- list()
for(i in 1:length(pitches)){
  for(j in 1:12){
    if(pitches[[i]][j] == 1){
      x[i] <- names(pitches[[i]][j])
      }
    }
  }
x <- unlist(x)
table(x) %>% barplot()

tune <- as.data.frame(x, header=F)

tune$from <- as.data.frame(x, header = F)
tune$x <- NULL
tune$to <- lead(tune$from, 1)
unite(tune, c(from, to))

shake_it_off <-
  get_tidy_audio_analysis("0cqRj7pUJDkTCEsJkx8snD") |>
  select(segments) |>
  unnest(segments) |>
  select(start, duration, pitches)

shake_it_off$pitches

chroma_names <- c("C", "C#|Db","D", "D#|Eb", "E", "F", "F#|Gb","G", "G#|Ab","A", "A#|Bb","B" )
long_shake_it <- unnest(shake_it_off, cols = pitches)
long_shake_it$chroma <- rep(chroma_names, nrow(long_shake_it)/12)

long_shake_it <- long_shake_it |>
  filter(pitches == 1) |>
  mutate(chroma2 = lag(chroma))

x <- as.matrix(table(long_shake_it |> select(chroma, chroma2)))
corrplot(x, is.corr = FALSE, method = "pie")



##### EXCERISE: 
#### Grab features from a song
#### Look at chroma vectors.
#### Get pitch counts and get transitions
#### Explain it to me musically.

