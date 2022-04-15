/*
 * Copyright 2022 XXIV
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
module audiodb

import net.http
import net.urllib
import model { Album, Artist, Discography, MusicVideo, Track }
import json

struct ArtistResponse {
	artists []Artist
}

struct DiscographyResponse {
	album []Discography
}

struct AlbumResponse {
	album []Album
}

struct TrackResponse {
	track []Track
}

struct MusicVideoResponse {
	mvids []MusicVideo
}

fn get_request(endpoint string) ?string {
	response := http.get('https://theaudiodb.com/api/v1/json/2/$endpoint') or { return err }
	return response.text
}

// Return Artist details from artist name
pub fn search_artist(s string) ?Artist {
	response := get_request('search.php?s=${urllib.query_escape(s)}') or { return error(err.str()) }
	if response.len == 0 {
		return error('no results found')
	}
	json := json.decode(ArtistResponse, response) or {
		return error('Something went wrong while reading json: $err')
	}

	if json.artists.len == 0 {
		return error('no results found')
	}

	return json.artists[0]
}

// Return Discography for an Artist with Album names and year only
pub fn discography(s string) ?[]Discography {
	response := get_request('discography.php?s=${urllib.query_escape(s)}') or {
		return error(err.str())
	}
	if response.len == 0 {
		return error('no results found')
	}
	json := json.decode(DiscographyResponse, response) or {
		return error('Something went wrong while reading json: $err')
	}

	if json.album.len == 0 {
		return error('no results found')
	}

	return json.album
}

// Return individual Artist details using known Artist ID
pub fn search_artist_by_id(i int) ?Artist {
	response := get_request('artist.php?i=$i') or { return error(err.str()) }
	if response.len == 0 {
		return error('no results found')
	}
	json := json.decode(ArtistResponse, response) or {
		return error('Something went wrong while reading json: $err')
	}

	if json.artists.len == 0 {
		return error('no results found')
	}

	return json.artists[0]
}

// Return individual Album info using known Album ID
pub fn search_album_by_id(i int) ?Album {
	response := get_request('album.php?m=$i') or { return error(err.str()) }
	if response.len == 0 {
		return error('no results found')
	}
	json := json.decode(AlbumResponse, response) or {
		return error('Something went wrong while reading json: $err')
	}

	if json.album.len == 0 {
		return error('no results found')
	}

	return json.album[0]
}

// Return All Albums for an Artist using known Artist ID
pub fn search_albums_by_artist_id(i int) ?[]Album {
	response := get_request('album.php?i=$i') or { return error(err.str()) }
	if response.len == 0 {
		return error('no results found')
	}
	json := json.decode(AlbumResponse, response) or {
		return error('Something went wrong while reading json: $err')
	}

	if json.album.len == 0 {
		return error('no results found')
	}

	return json.album
}

// Return All Tracks for Album from known Album ID
pub fn search_tracks_by_album_id(i int) ?[]Track {
	response := get_request('track.php?m=$i') or { return error(err.str()) }
	if response.len == 0 {
		return error('no results found')
	}
	json := json.decode(TrackResponse, response) or {
		return error('Something went wrong while reading json: $err')
	}

	if json.track.len == 0 {
		return error('no results found')
	}

	return json.track
}

// Return individual track info using a known Track ID
pub fn search_track_by_id(i int) ?Track {
	response := get_request('track.php?h=$i') or { return error(err.str()) }
	if response.len == 0 {
		return error('no results found')
	}
	json := json.decode(TrackResponse, response) or {
		return error('Something went wrong while reading json: $err')
	}

	if json.track.len == 0 {
		return error('no results found')
	}

	return json.track[0]
}

// Return all the Music videos for a known Artist ID
pub fn search_music_videos_by_artist_id(i int) ?[]MusicVideo {
	response := get_request('mvid.php?i=$i') or { return error(err.str()) }
	if response.len == 0 {
		return error('no results found')
	}
	json := json.decode(MusicVideoResponse, response) or {
		return error('Something went wrong while reading json: $err')
	}

	if json.mvids.len == 0 {
		return error('no results found')
	}

	return json.mvids
}
