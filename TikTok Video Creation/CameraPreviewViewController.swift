//
//  CameraPreviewViewController.swift
//  takko
//
//  Created by Azzaro Mujic on 21.06.2021..
//  Copyright © 2021 Content Creators, Inc. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit
import Photos

class CameraPreviewViewController: UIViewController {
    
    private let videoURL: URL
    private var player: AVQueuePlayer
    private var playerLayer: AVPlayerLayer
    private var playerItem: AVPlayerItem
    private var playerLooper: AVPlayerLooper
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Preview"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .appWhite
        button.setImage(getSystemImage(name: "chevron.left.2", size: 22), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(getSystemImage(name: "square.and.arrow.down", size: 22), for: .normal)
        button.tintColor = .appWhite
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        
        player = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerItem = AVPlayerItem(url: videoURL)
        
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
                
        playerLayer.frame = view.layer.bounds
        view.layer.insertSublayer(playerLayer, at: 1)
        
        view.addSubview(backButton)
        view.addSubview(confirmButton)
        view.addSubview(titleLabel)
        
        setConstraints()
        
        player.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = view.layer.bounds
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapConfirmButton() {
        PHPhotoLibrary.shared().performChanges({ [weak self] in
            guard let self = self else { return }
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
        }) { saved, error in
            if saved {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func setConstraints() {
        backButton.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(6)
            $0.top.equalTo(view.snp.topMargin).offset(28)
            $0.width.height.equalTo(44)
        }
        
        confirmButton.snp.remakeConstraints {
            $0.trailing.equalToSuperview().inset(22)
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-44)
            $0.width.height.equalTo(44)
        }
        
        titleLabel.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
        }
    }
}
