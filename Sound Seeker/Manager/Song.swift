//
//  Song.swift
//  Sound Seeker
//
//  Created by Hung Vu on 22/08/2023.
//

import Foundation
struct SongInfo : Decodable {
    let album: String
    let artist: String
    let label: String

    let song_link:URL
    
    init(album: String, artist: String, label: String, song_link: URL) {
        self.album = album
        self.artist = artist
        self.label = label
        self.song_link = song_link
    }
}
