# cscomps
This repository is for my senior comprehensive project for my Computer Science major at Occidental College. The project is a mobile app built using Swift that helps the user train their musical abilities using pitch detection.

The app is built using AudioKit for the use of taking in audio input, performing calculations on the input, and playing audio. There are some AudioKitUI elements that are used as well.

How to Use Code:

1) Clone repository by clicking on the "Code" selector at the top of this page
2) Open the project in XCode
3) All necessary packages should already be added as dependencies for this project, but if not, scroll down to "Add Packages"
4) Click the Run icon in the upper left corner of the project

Add Packages:

1) Get the link to add dependency for the following necessary packages
a. AudioKit - https://github.com/AudioKit/AudioKit
b. AudioKitUI - https://github.com/AudioKit/AudioKitUI
c. KissFFT - https://github.com/AudioKit/KissFFT.git
d. For Soundpipe AudioKit, follow these specific instructions - https://audiokit.io/Packages/SoundpipeAudioKit/
2) Select File -> Swift Packages -> Add Package Depedency
3) For version numbers/commit, choose the corresponding one
a. AudioKit - specific version 5.2.2
b. AudioKitUI - commit dc5ebde
c. KissFFT - up to next major 1.0.0
d. Soundpipe AudioKit - specific version 5.2.2
