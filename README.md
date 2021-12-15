# cscomps
Musical Progressions
This folder contains all of the musical progression JSON files that can be decoded and represented with audio and music notation
Elements
This folder contains all of the swift files for the application
	Components
This folder contains the reusable UI components that are found in multiple views and are only a portion of the page
		MusicNote.swift
This file defines the structure “MusicNote” which is the music notes used in the music notation. It provides the code for the spacing, sizing, and color of the Music Note
		Staff.swift
This file defines the structure “Staff” which takes multiple music notes and aligns them accordingly, and also passes on the variables to the MusicNote class that specify its spacing, sizing, color, etc.
	Subviews
This folder contains code that does not have its own page in the application, but are fundamental to one of those pages
		StaffView.swift
This file creates the music notation view. It has a staff with the music notes and the names of the notes as well. It also passes along variables to Staff.swift and binds them so that they update immediately.
		Progression.swift
This file defines the struct “Progression” which is a data structure that houses the information in each musical progression  JSON file after it has been decoded.
		Warmup.swift
This file has the functionality  for decoding a musical progression JSON file and storing the data in a Progression struct.
	Views
This folder contains the files that each create an individual page in the application
		ProgressionTransforms.swift
This file is for the Warmup feature of the app. It defines the class ProgressionTransform, which starts the AudioKit AudioEngine and performs the Short-term Fourier Transform calculations on the AudioEngine output to find the correct note. It also contains the UI for the Warmup feature, which uses the StaffView file.
		FourierTransforms.swift
This file is for the Tuner feature of the app. It defines the class Transform, which starts the AudioKit AudioEngine and performs the STFT algorithm on the AudioEngine output to find the correct note. It also contains the code for the UI of the Tuner feature.
		MainView.swift
This file contains the code for the “home” page of the app, from which you can navigate to the different features.
SeniorCompsApp.swift
This file is how the app runs, it calls MainView.swift
Appendix 2: Reproducing Results

The app is built using AudioKit for the use of taking in audio input, performing calculations on the input, and playing audio. There are some AudioKitUI elements that are used as well.

How to Use Code:

1) Clone repository by clicking on the "Code" selector at the top of this page
2) Open the project folder, and then open the “SeniorComps.xcodeproj” file in XCode
3) All necessary packages should already be added as dependencies for this project with the correct version number, however it will take 10-15 minutes for these dependencies to load. If you are getting an error that “XCode cannot resolve package dependencies,” this means that it is still loading. If the error persists for longer than 30 minutes, follow the instructions in “Add Packages” below.
4) On the upper bar of XCode, click on the dropdown that should say “SeniorComps > <some iPhone version>” and select “iPhone 11” for the best user experience. The image below representing where this dropdown is located.

5) Click on  the “SeniorCompsApp.swift” file, located on the left sidebar in XCode
6) Click the Run icon in the upper left corner of the project
7) XCode will automatically open a simulator that will load the application. This may take a few minutes

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
