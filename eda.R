#### Packages #####

library(tidyverse)
library(spotifyr)
install.packages("httpuv")

#### Connect to API ####

Sys.setenv(SPOTIFY_CLIENT_ID = '723c150391c04a3899fecf5a2c8d711d')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '99075ce9f22e45eea3215ff4d15d8027')

my_token <- spotifyr::get_spotify_access_token()

#### Requests ####

recently_played <- spotifyr::get_my_recently_played(limit = 50)
top_artists <- spotifyr::get_my_top_artists_or_tracks(type = 'artists', limit = 50)
top_tracks <- spotifyr::get_my_top_artists_or_tracks(type = 'tracks', limit = 50)

#### Get data for top tracks ####

top_tracks_features <- tibble()

for (i in length(top_tracks)) {

features <- spotifyr::get_track_audio_features(top_tracks$id)
top_tracks_features <- rbind(features, top_tracks_features)

}

top_tracks <- top_tracks %>% 
  left_join(top_tracks_features, by = 'id')