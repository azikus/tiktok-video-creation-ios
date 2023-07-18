//
//  VideoHelper.swift
//  takko
//
//  Created by Azzaro Mujic on 31.05.2021..
//  Copyright © 2021 Content Creators, Inc. All rights reserved.
//

import Foundation
import AVFoundation
import MobileCoreServices
import UIKit

enum MergeAndExportResult {
    case error(String)
    case sucess(AVAssetExportSession)
}

enum VideoHelper {

    static func orientationFromTransform(
        _ transform: CGAffineTransform
    ) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        let tfA = transform.a
        let tfB = transform.b
        let tfC = transform.c
        let tfD = transform.d
        
        if tfA == 0 && tfB == 1.0 && tfC == -1.0 && tfD == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if tfA == 0 && tfB == -1.0 && tfC == 1.0 && tfD == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if tfA == 1.0 && tfB == 0 && tfC == 0 && tfD == 1.0 {
            assetOrientation = .up
        } else if tfA == -1.0 && tfB == 0 && tfC == 0 && tfD == -1.0 {
            assetOrientation = .down
        }
        return (assetOrientation, isPortrait)
    }
    
    static func mergeAndExport(assets: [AVAsset], completion: @escaping ((MergeAndExportResult) -> Void)) {
    
        let mixComposition = AVMutableComposition()
        var start = CMTime.zero
        
        // Merge video tracks
        let tracks: [AVMutableCompositionTrack] = assets.compactMap { asset in
            let track = mixComposition.addMutableTrack(
                withMediaType: .video,
                preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            
            do {
                try track?.insertTimeRange(
                    CMTimeRangeMake(start: .zero, duration: asset.duration),
                    of: asset.tracks(withMediaType: .video)[0],
                    at: start)
                start = CMTimeAdd(start, asset.duration)
            } catch {
                completion(MergeAndExportResult.error("Insert TimeRange into Track failed"))
                return track
            }
            return track
        }
        
        let totalDuration = assets.reduce(CMTime.zero) { result, asset in
            return CMTimeAdd(result, asset.duration)
        }
        
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(
            start: .zero,
            duration: totalDuration)
        
        start = .zero
        let instructions: [AVMutableVideoCompositionLayerInstruction] = assets
            .enumerated()
            .map {
                let instruction = VideoHelper.videoCompositionInstruction(tracks[$0.offset], asset: $0.element)
                if $0.offset != assets.count - 1 {
                    start = CMTimeAdd(start, $0.element.duration)
                    instruction.setOpacity(0.0, at: start)
                }
                return instruction
            }
        
        mainInstruction.layerInstructions = instructions
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)


        let naturalSize = tracks[0].naturalSize
        let ratio = max(naturalSize.width/naturalSize.height, naturalSize.height/naturalSize.width)
        mainComposition.renderSize = CGSize(
            width: UIScreen.main.bounds.width + 1,
            height: UIScreen.main.bounds.width * ratio)
                
        // Merge audio
        start = CMTime.zero
        assets.forEach { asset in
            let audioTrack = mixComposition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: 0)
            
            guard !asset.tracks(withMediaType: .audio).isEmpty else {
                start = CMTimeAdd(start, asset.duration)
                return
            }
            do {
                try audioTrack?.insertTimeRange(
                    CMTimeRangeMake(
                        start: CMTime.zero,
                        duration: asset.duration),
                    of: asset.tracks(withMediaType: .audio)[0],
                    at: start)
                start = CMTimeAdd(start, asset.duration)
            } catch {
                completion(MergeAndExportResult.error("Failed to load Audio track"))
                return
            }
        }
        
        // Get path
        guard
            let documentDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first
        else {
            completion(MergeAndExportResult.error("Document Directory failed"))
            return
        }
        
        let url = documentDirectory.appendingPathComponent("mergeVideo-\(Date().timeIntervalSince1970).mov")
        try? FileManager.default.removeItem(at: url)
        
        // Create Exporter
        guard let exporter = AVAssetExportSession(
                asset: mixComposition,
                presetName: AVAssetExportPreset1280x720)
        else {
            completion(MergeAndExportResult.error("Create Exporter Failed"))
            return
        }
        
        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainComposition
        
        // Perform the Export
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                completion(MergeAndExportResult.sucess(exporter))
            }
        }
    }
    
    static func videoCompositionInstruction(
        _ track: AVCompositionTrack,
        asset: AVAsset
    ) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        
        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFromTransform(transform)
        
        var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
        if assetInfo.isPortrait {
            scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
            let scaleFactor = CGAffineTransform(
                scaleX: scaleToFitRatio,
                y: scaleToFitRatio)
            instruction.setTransform(
                assetTrack.preferredTransform.concatenating(scaleFactor),
                at: .zero)
        } else {
            let scaleFactor = CGAffineTransform(
                scaleX: scaleToFitRatio,
                y: scaleToFitRatio)
            var concat = assetTrack.preferredTransform.concatenating(scaleFactor)
            if assetInfo.orientation == .down {
                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                let windowBounds = UIScreen.main.bounds
                let yFix = assetTrack.naturalSize.height + windowBounds.height
                let centerFix = CGAffineTransform(
                    translationX: assetTrack.naturalSize.width,
                    y: yFix)
                concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
            }
            instruction.setTransform(concat, at: .zero)
        }
        
        return instruction
    }
}
