# Eivind Arvesen, 2014
# Get current song from Spotify

osascript -e 'tell application "Spotify"
	set theTrack to current track
	set theArtist to artist of theTrack
	set theName to name of theTrack
	if player state is playing then
		set playStatus to "playing"
	else
		set playStatus to "notPlaying"
	end if
end tell

if playStatus is "playing" then
	if (theArtist as string) is not "Spotify" then
		return (theArtist as string) & " - " & (theName as string)
	end if
else
	return "PAUSED"
end if'
