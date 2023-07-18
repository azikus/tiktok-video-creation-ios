//
//  AVAsset+.swift
//  Boomerang-blog
//
//  Created by Antonio Griparić on 10.03.2023..
//

import AVFoundation

extension AVAsset {
    var containsVideoAudioTracks: Bool {
        !tracks(withMediaType: .video).isEmpty && !tracks(withMediaType: .audio).isEmpty
    }
}
