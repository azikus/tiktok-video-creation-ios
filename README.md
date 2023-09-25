# TikTok-like Video Capture Sample App for iOS
## Table of Contents
1. [Description](#description)
2. [Features](#features)
3. [Requirements](#requirements)
4. [Installation](#installation)
5. [Usage](#usage)
6. [How it Works](#how-it-works)
7. [License](#license)

## Description

[Blog Link](https://medium.com/@antonio.griparic/e5f2b27c4355)

This repository contains a sample iOS app that demonstrates how to create a video capture feature similar to TikTok.

In branch `background-merge` You can find the implementation that merges videos in the background.

In branch `merge-before-preview` You can find the implementation that merges all videos when you tap preview button.

## Features

- Record short videos with the front or rear camera.
- Pause and resume video recording during capture.
- Flip cameras while recording.
- Preview the captured video before saving.
- Saving to device's gallery.

## Requirements

- Xcode [14.2]
- Swift [5.7.2]
- iOS [15.0]

## Installation

1. Clone this repository to your local machine using `git clone`.
2. Install the dependencies using CocoaPods `pod install`.
3. Open the project in Xcode by double-clicking the `.xcworkspace` file.
4. Choose a target device or simulator to run the app.
5. Build and run the app.

## Usage

1. Launch the app on your iOS device or simulator.
2. Grant permission to access the device's camera and microphone if prompted.
3. Tap on the camera switch button to toggle between the front and rear cameras.
4. To start recording you can press and hold the record button or just tap it.
5. Tap the pause button to pause the recording if needed. Press it again to resume.
7. Preview the recorded video by tapping the "right arrows" button.
8. Save the video to your device's gallery by tapping the appropriate button.

## How it Works

The app is built using Swift and utilizes various iOS frameworks to enable video capture functionality. Here's an overview of the app's architecture:

- **AVFoundation:** The core of video capturing and processing is handled through the AVFoundation framework. It provides access to the device's camera and microphone, as well as controls for video recording, pausing, and resuming.

- **SnapKit:** For handling Auto Layout constraints, we use SnapKit, a popular Swift library. SnapKit simplifies the process of creating and managing constraints, making the user interface design flexible and adaptive to different screen sizes.

- **UIKit:** The user interface is built using UIKit components, including buttons, labels, and views. Auto Layout constraints are used to ensure the app adapts to different screen sizes.

## License

This project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute the code as per the terms of the license.

---

We hope you find this sample app useful in understanding how to create a TikTok-like video capture feature for iOS. Happy coding! If you have any questions or need further assistance, please feel free to reach out.
