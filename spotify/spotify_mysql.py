from spotipy.oauth2 import SpotifyClientCredentials
import spotipy
import pandas as pd
import matplotlib.pyplot as plt
import re
import mysql.connector

# Set up Client Credentials
sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(
    client_id="c88394a259eb49aab72a0c56f76c8a29", 
    client_secret="88ccf845e2b44804803363a6455395b6"))

# MySQL Database Connection
connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Santmysql@1229",
    database="spotify"
)

# Connect to the database
cursor = connection.cursor()

# Full track URL (example: Shape of you by Ed Sheeran)
track_url = "https://open.spotify.com/track/7qiZfU4dY1lWllzX7mPBI3"

# Extract track ID directly from URL using regex
track_id = re.search(r'track/([a-zA-Z0-9]+)', track_url).group(1)

# Fetch track details
track = sp.track(track_id)
# print(track)

# Extract metadata
track_data = {
    'Track Name': track['name'],
    'Artist': track['artists'][0]['name'],
    'Album': track['album']['name'],
    'Popularity': track['popularity'],
    'Duration (minutes)': track['duration_ms'] / 60000
}

# Insert data into MySQL
insert_query = """
INSERT INTO spotify_tracks (track_name, artist, album, popularity, duration_minutes)
VALUES (%s, %s, %s, %s, %s)
"""
cursor.execute(insert_query, (
    track_data['Track Name'],
    track_data['Artist'],
    track_data['Album'],
    track_data['Popularity'],
    track_data['Duration (minutes)']
))
connection.commit()

print(f"Track '{track_data['Track Name']}' by {track_data['Artist']} inserted into the database.")

# Close the connection
cursor.close()
connection.close()