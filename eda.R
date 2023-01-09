#### Packages #####

library(tidyverse)
library(spotifyr)
install.packages("httpuv")

#### Connect to API ####

Sys.setenv(SPOTIFY_CLIENT_ID = '***')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '***')

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

# Join
top_tracks <- top_tracks %>% 
  left_join(top_tracks_features, by = 'id')

# Unnest artist name
top_tracks$artist_name <- purrr::map_chr(top_tracks$album.artists, function(x) x$name[1])

#### Descriptives ####

top_tracks_summary <- top_tracks %>% 
  summarise(distinct_artists = n_distinct(artist_name),
            earliest_release = min(album.release_date, na.rm = TRUE),
            latest_release = max(album.release_date, na.rm = TRUE),
            avg_length = mean(duration_ms.x/60000, na.rm = TRUE),
            avg_valence = mean(valence, na.rm = TRUE),
            avg_danceability = mean(danceability, na.rm = TRUE),
            avg_energy = mean(energy, na.rm = TRUE),
            avg_loudness = mean(loudness, na.rm = TRUE),
            avg_speechiness = mean(speechiness, na.rm = TRUE),
            avg_instrumentalness = mean(instrumentalness, na.rm = TRUE),
            avg_liveness = mean(liveness, na.rm = TRUE),
            avg_tempo = mean(tempo, na.rm = TRUE),
            avg_acousticness = mean(acousticness, na.rm = TRUE),
            avg_popularity = mean(popularity, na.rm = TRUE))
