from spotipy.oauth2 import SpotifyClientCredentials
import spotipy
import pandas as pd
import matplotlib.pyplot as plt
import re

# Set up Client Credentials
sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(
    client_id="c88394a259eb49aab72a0c56f76c8a29", 
    client_secret="88ccf845e2b44804803363a6455395b6"))

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
# Display metadata
print(f"\nTrack Name: {track_data['Track Name']}")
print(f"Artist: {track_data['Artist']}")
print(f"Album: {track_data['Album']}")
print(f"Popularity: {track_data['Popularity']}")
print(f"Duration: {track_data['Duration (minutes)']:.2f} minutes")

#Convert metadata to DataFrame
df = pd.DataFrame([track_data])
print("\n Track Data as a DataFrame:")
print(df)

# Save DataFrame to CSV
df.to_csv("spotify_track_data.csv", index=False)

# Visualize track data
features = ['Popularity', 'Duration (minutes)']
values = [track_data['Popularity'], track_data['Duration (minutes)']]

plt.figure(figsize=(10, 5))
plt.bar(features, values, color=['blue', 'orange'])
plt.title('Spotify Track Features')
plt.xlabel('Features')
plt.ylabel('Values')
plt.grid(axis='y')
plt.savefig("spotify_track_data_visualization.png")
plt.show()

