//
//  CameraViewController.swift
//  takko
//
//  Created by Azzaro Mujic on 30.05.2021..
//  Copyright © 2021 Content Creators, Inc. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class CameraViewController: UIViewController {
    
    struct SavedAsset {
        let asset: AVAsset
        let outputFileURLs: URL
    }
    
    var savedAssets: [SavedAsset] = []
    var assetsReadyToMerge: [AVAsset] = []
    
    var assets: [AVAsset] {
        savedAssets.map { $0.asset }
    }
    
    var outputFileURLs: [URL] {
        savedAssets.map { $0.outputFileURLs }
    }

    var totalDuration: CMTime {
        assets.reduce(CMTime.zero) { result, asset in
            return CMTimeAdd(result, asset.duration)
        }
    }
    
    enum CameraPosition {
        case front
        case rear
    }
    
    enum CameraControllerError: Swift.Error {
        case invalidOperation
    }
    
    var currentCameraPosition: CameraPosition = .front
    
    var isRecording = false {
        didSet {
            updateButtons()
        }
    }
    
    var shouldFlipAfterStopRecording = false
    
    lazy var captureSession: AVCaptureSession = AVCaptureSession()
    lazy var videoOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
    
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    var audioDevice: AVCaptureDevice?
    
    var videoDevice: AVCaptureDevice? {
        switch currentCameraPosition {
        case .front:
            return frontCamera
        case .rear:
            return rearCamera
        }
    }
    
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?
    var audioInput: AVCaptureDeviceInput?
    
    private var didCheckCamera = false
    private var touchDownDate = Date()
    private var canPan = false
    private var startedZoom: CGFloat?
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        return panGestureRecognizer
    }()
    
    private lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch))
        return pinchGestureRecognizer
    }()
    
    lazy var cameraProgressView: CameraProgressView = {
        let view = CameraProgressView()
        view.delegate = self
        return view
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(getSystemImage(name: "record.circle", size: 48), for: .normal)
        button.tintColor = .appWhite
        button.addTarget(self, action: #selector(didTouchDownRecordButton), for: .touchDown)
        button.addTarget(self, action: #selector(didTouchUpRecordButton), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchUpRecordButton), for: .touchUpOutside)
        button.addGestureRecognizer(panGestureRecognizer)
        
        return button
    }()
    
    lazy var flipButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .appWhite
        button.setImage(getSystemImage(name: "arrow.triangle.2.circlepath.camera", size: 22), for: .normal)
        button.addTarget(self, action: #selector(didTapFlipButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var flashButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .appWhite
        button.setImage(getSystemImage(name: "bolt", size: 22), for: .normal)
        button.addTarget(self, action: #selector(didTapFlashButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .appWhite
        button.setImage(getSystemImage(name: "delete.backward", size: 22), for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .appWhite
        button.setImage(getSystemImage(name: "chevron.right", size: 22), for: .normal)
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        button.alpha = 0
        return button
    }()

    init() { super.init(nibName: nil, bundle: nil) }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        view.backgroundColor = .black
        view.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didCheckCamera {
            didCheckCamera = true
            checkCamera()
        }
    }
    
    private func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized: checkAudio()
        case .denied: pressentSettings()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.checkCamera()
                }
            }
        default: pressentSettings()
        }
    }
    
    private func checkAudio() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        switch authStatus {
        case .authorized: setupCaptureSession()
        case .denied: pressentSettings()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.checkAudio()
                }
            }
        default: pressentSettings()
        }
    }
    
    private func pressentSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
    
    private func addSubviews() {
        view.addSubview(recordButton)
        view.addSubview(flipButton)
        view.addSubview(flashButton)
        view.addSubview(cameraProgressView)
        view.addSubview(deleteButton)
        view.addSubview(confirmButton)
        
        setConstraints()
    }
    
    private func setConstraints() {
        recordButton.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin).offset(-70)
            make.width.height.equalTo(100)
        }
        
        flipButton.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(flashButton.snp.top).offset(-50)
            make.width.height.greaterThanOrEqualTo(44)
        }
        
        flashButton.snp.remakeConstraints { make in
            make.centerX.equalTo(flipButton)
            make.bottom.equalTo(recordButton.snp.top).offset(-20)
            make.width.height.greaterThanOrEqualTo(44)
        }
        
        cameraProgressView.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmButton.snp.remakeConstraints { make in
            make.width.height.equalTo(40)
            make.trailing.equalToSuperview().inset(23)
            make.centerY.equalTo(recordButton)
        }
        
        deleteButton.snp.remakeConstraints { make in
            make.trailing.equalTo(confirmButton.snp.leading).offset(-12)
            make.width.height.equalTo(40)
            make.centerY.equalTo(recordButton)
        }
    }

    lazy var previewView: PreviewView = { .init(frame: .zero) }()

    func startCaptureSession() {
        guard !captureSession.isRunning else { return }
        captureSession.startRunning()
    }
    
    func stopCaptureSession() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
    
    func setupPreview() {
        view.addSubview(previewView)
        view.sendSubviewToBack(previewView)
        previewView.frame = view.bounds
    }
    
    func setupCaptureSession() {
        // set front and rear camera
        let session = AVCaptureDevice.DiscoverySession.init(deviceTypes:[.builtInWideAngleCamera, .builtInMicrophone], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let asession = AVCaptureDevice.DiscoverySession.init(deviceTypes:[.builtInMicrophone],
                                                             mediaType: AVMediaType.audio, position: AVCaptureDevice.Position.unspecified)
        
        let cameras = ((session.devices + asession.devices).compactMap{$0})
        
        for camera in cameras {
            if camera.position == .front {
                self.frontCamera = camera
            }
            if camera.position == .back {
                self.rearCamera = camera
                
                try? camera.lockForConfiguration()
                camera.focusMode = .continuousAutoFocus
                camera.unlockForConfiguration()
            }

            if camera.hasMediaType(.audio) {
                audioDevice = camera
            }
        }
        
        if let rearCamera = self.rearCamera {
            self.rearCameraInput = try? AVCaptureDeviceInput(device: rearCamera)
            
            if let rearCameraInput = self.rearCameraInput,
                captureSession.canAddInput(rearCameraInput) {
                captureSession.addInput(rearCameraInput)
                self.currentCameraPosition = .rear
            }
        } else if let frontCamera = self.frontCamera {
            self.frontCameraInput = try? AVCaptureDeviceInput(device: frontCamera)
            if let frontCameraInput = self.frontCameraInput,
                captureSession.canAddInput(frontCameraInput) {
                captureSession.addInput(frontCameraInput)
                self.currentCameraPosition = .front
            }
        }
        
        if let audioDevice = self.audioDevice {
            self.audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = self.audioInput,
                captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }
        }
        
        // output
        if captureSession.canAddOutput(self.videoOutput) {
            captureSession.addOutput(self.videoOutput)
        }
        
        setupPreview()
        previewView.videoPreviewLayer.session = captureSession
        
        startCaptureSession()
    }
}
//NESTANE I DODE?
// MARK: - AVCaptureFileOutputRecordingDelegate
extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            presentError(message: error.localizedDescription)
            return
        }
        let asset = AVAsset(url: outputFileURL)
        assetsReadyToMerge.append(asset)
            
        if shouldFlipAfterStopRecording {
            shouldFlipAfterStopRecording = false
            flip()
            return
        }
            
        if let last = savedAssets.last?.asset {
            assetsReadyToMerge.insert(last, at: 0)
        }
         
        confirmButton.alpha = 0
        VideoHelper.mergeAndExport(assets: assetsReadyToMerge) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .error(let error):
                self.presentError(message: error)
            case .sucess(let session):
                guard session.status == AVAssetExportSession.Status.completed,
                      let outputURL = session.outputURL else {
                            self.presentNativeMessage("Please try again", title: "Something went wrong!", completion: nil)
                            return
                      }
                let newMergedAsset = AVAsset(url: outputURL)
                guard newMergedAsset.containsVideoAudioTracks else {
                    self.presentNativeMessage("Could not capture last clip! Please try again!")
                    return
                }
                self.savedAssets.append(SavedAsset(asset: newMergedAsset, outputFileURLs: outputURL))
                self.assetsReadyToMerge = []
                self.updateButtons()
                self.confirmButton.alpha = self.totalDuration.seconds > 4 ? 1 : 0
            }
        }
    }
    
    func finish() {
        guard let lastMegredURL = outputFileURLs.last else { return }
        let cameraPreviewViewController = CameraPreviewViewController(videoURL: lastMegredURL)
        self.navigationController?.pushViewController(cameraPreviewViewController, animated: true)
    }
}

// MARK: - Helpers
private extension CameraViewController {
    func flip() {
        switch currentCameraPosition {
        case .front:
            self.currentCameraPosition = .rear
            try? switchToRearCamera()
        case .rear:
            self.currentCameraPosition = .front
            try? switchToFrontCamera()
            turnOffTorch()
        }
        if isRecording {
            recordVideo()
        }
    }
    
    func switchToFrontCamera() throws {
        guard let rearCameraInput = self.rearCameraInput,
              captureSession.inputs.contains(rearCameraInput),
              let frontCamera = self.frontCamera
        else {
            throw CameraControllerError.invalidOperation
        }
        
        self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
        guard let frontCameraInput = self.frontCameraInput else { return }
        
        captureSession.removeInput(rearCameraInput)
        
        if captureSession.canAddInput(frontCameraInput) {
            captureSession.addInput(frontCameraInput)
            
            self.currentCameraPosition = .front
        } else {
            throw CameraControllerError.invalidOperation
        }
    }
    
    func switchToRearCamera() throws {
        guard let frontCameraInput = self.frontCameraInput,
              captureSession.inputs.contains(frontCameraInput),
              let rearCamera = self.rearCamera
        else { throw CameraControllerError.invalidOperation }
        
        self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
        guard let rearCameraInput = self.rearCameraInput else { return }
        
        captureSession.removeInput(frontCameraInput)
        
        if captureSession.canAddInput(rearCameraInput) {
            captureSession.addInput(rearCameraInput)
            
            self.currentCameraPosition = .rear
        } else {
            throw CameraControllerError.invalidOperation
        }
    }
    
    func recordVideo() {
        guard captureSession.isRunning else {
            return
        }
        cameraProgressView.resume()
        let filename = "output-\(assets.count + assetsReadyToMerge.count).mov"
        let temporaryFilepathDirectory = FileManager.default.temporaryDirectory
        let videoOutputURL = temporaryFilepathDirectory.appendingPathComponent(filename)
        do {
            try? FileManager.default.removeItem(at: videoOutputURL)
        }

        videoOutput.startRecording(to: videoOutputURL, recordingDelegate: self)
    }
    
    func stopRecording() {
        guard captureSession.isRunning else {
            return
        }
        setZoom(value: 1)
        cameraProgressView.pause(shouldAddIndicator: !isRecording)
        self.videoOutput.stopRecording()
    }
    
    func setZoom(value: CGFloat) {
        try? videoDevice?.lockForConfiguration()
        videoDevice?.videoZoomFactor = value
        videoDevice?.unlockForConfiguration()
    }
    
    func updateButtons() {
        if isRecording {
            deleteButton.alpha = 0
            confirmButton.alpha = 0
            return
        }
        deleteButton.alpha = assets.isEmpty ? 0 : 1
    }
    
    func turnOffTorch() {
        guard
            let device = AVCaptureDevice.default(for: AVMediaType.video),
            device.hasTorch
        else { return }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = .off
            device.unlockForConfiguration()
            flashButton.setImage(getSystemImage(name: "bolt", size: 22), for: .normal)
        } catch {
            print("Torch could not be used")
        }
    }
    
    func toggleTorch() {
        guard
            let device = AVCaptureDevice.default(for: AVMediaType.video),
            device.hasTorch
        else { return }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = device.torchMode == .on ? .off : .on
            device.unlockForConfiguration()
            switch device.torchMode {
            case .on:
                flashButton.setImage(getSystemImage(name: "bolt.fill", size: 22), for: .normal)
            default:
                flashButton.setImage(getSystemImage(name: "bolt", size: 22), for: .normal)
            }
        } catch {
            print("Torch could not be used")
        }
    }
    
    func toggleRecording() {
        if isRecording {
            isRecording = false
            stopRecording()
            recordButton.setImage(getSystemImage(name: "record.circle", size: 48), for: .normal)
            recordButton.layer.borderWidth = 0
        } else {
            isRecording = true
            recordVideo()
            recordButton.layer.borderWidth = 5
            
            // animation for record button
            let view = UIView()
            view.layer.borderWidth = 5
            view.isUserInteractionEnabled = false
            view.layer.borderColor = UIColor.appWhite.withAlphaComponent(0.5).cgColor
            self.view.addSubview(view)
            view.frame = recordButton.frame
            view.layer.cornerRadius = recordButton.bounds.width / 2
            view.center = recordButton.center
            view.transform = CGAffineTransform(scaleX: 0.74, y: 0.74)
            recordButton.setImage(nil, for: .normal)
            recordButton.alpha = 0.001
            recordButton.layer.borderColor = UIColor.appWhite.withAlphaComponent(0.5).cgColor
            recordButton.layer.cornerRadius = self.recordButton.bounds.width / 2
            
            UIView.animate(withDuration: 0.15) {
                view.transform = .identity
            } completion: {[weak view, weak self] _ in
                guard let self = self else { return }
                guard let view = view else { return }

                self.recordButton.alpha = 1
                view.removeFromSuperview()
            }
        }
    }
}

// MARK: - Action
private extension CameraViewController {
    @objc func didPinch() {
        if pinchGestureRecognizer.state == .began {
            startedZoom = videoDevice?.videoZoomFactor
        }
        
        guard let videoDevice = self.videoDevice else { return }
        var zoom = (startedZoom ?? videoDevice.minAvailableVideoZoomFactor) * pinchGestureRecognizer.scale
        zoom = max(min(zoom, videoDevice.maxAvailableVideoZoomFactor), videoDevice.minAvailableVideoZoomFactor)
        setZoom(value: zoom)
    }
    
    @objc func didTouchDownRecordButton() {
        touchDownDate = Date()
        toggleRecording()
        canPan = isRecording
    }
    
    @objc func didTouchUpRecordButton() {
        guard isRecording else { return }
        
        if Date().timeIntervalSince(touchDownDate) > 0.5 {
            toggleRecording()
        } else {
            recordButton.setImage(getSystemImage(name: "stop.circle", size: 48), for: .normal)
            recordButton.layer.borderWidth = 0
            canPan = false
        }
    }
    
    @objc func didPan() {
        guard canPan, isRecording else {
            panGestureRecognizer.setTranslation(.zero, in: self.view)
            return
        }
        
        if panGestureRecognizer.state == .began {
            startedZoom = videoDevice?.videoZoomFactor
        }
        
        switch panGestureRecognizer.state {
        case .ended, .cancelled:
            toggleRecording()
            UIView.animate(withDuration: 0.2) {
                self.recordButton.transform = .identity
            }
        default:
            let translation = panGestureRecognizer.translation(in: self.view)
            recordButton.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            
            guard let videoDevice = self.videoDevice else { return }
            let percentage = max(0, -translation.y)/self.view.frame.height
            
            let zoom = (startedZoom ?? videoDevice.minAvailableVideoZoomFactor) + (videoDevice.maxAvailableVideoZoomFactor - videoDevice.minAvailableVideoZoomFactor) * percentage
            setZoom(value: min(zoom, videoDevice.maxAvailableVideoZoomFactor))
        }
    }
    
    @objc func didTapFlipButton() {
        if isRecording {
            shouldFlipAfterStopRecording = true
            stopRecording()
        } else {
            flip()
        }
    }
    
    @objc func didTapDeleteButton() {
        let alert = UIAlertController(title: "Discard Changes?",
                                   message: "Are you sure you want to delete the last clip?",
                                   preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "Keep", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        
        let confirmButton = UIAlertAction(title: "Discard", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.savedAssets = self.savedAssets.dropLast()
            self.confirmButton.alpha = self.assets.isEmpty ? 0 : 1
            self.updateButtons()
            if self.assets.isEmpty {
                self.cameraProgressView.reset()
            } else {
                self.cameraProgressView.removeLast()
            }
            self.recordButton.alpha = 1
            self.recordButton.isUserInteractionEnabled = true
        }
        
        alert.addAction(confirmButton)
        alert.preferredAction = confirmButton
        present(alert, animated: true, completion: nil)
    }
    
    @objc func didTapConfirmButton() {
        finish()
    }
    
    @objc func didTapFlashButton() {
        toggleTorch()
    }
}

// MARK: - CameraProgressViewDelegate
extension CameraViewController: CameraProgressViewDelegate {
    func didFinish(in view: CameraProgressView) {
        stopRecording()
        isRecording = false
        recordButton.setImage(getSystemImage(name: "record.circle", size: 48), for: .normal)
        recordButton.alpha = 0.5
        recordButton.isUserInteractionEnabled = false
    }
}
