//
//  Music .swift
//  rx
//
//  Created by DungHM on 24/12/24.
//

import Foundation

final class Music: Codable {
    var artistName: String
    var id: String
    var releaseDate: String
    var name: String
    var artworkUrl100: String
}

struct MusicResults: Codable {
  var results: [Music]
}

struct FeedResults: Codable {
    var feed: MusicResults
}
