# MapKitDragAndDrop 3

iOS/iPhone OS MapKit sample for draggable AnnotationView with CoreAnimation pin lift/drop/bounce effects.

## Features

* Support both **iPhone OS 3.1.x, 3.2 and iOS 4** at the same time, in the same source code.
* Use iOS 4 MapKit built-in draggable support (Yes, you got **retina display** high resolution support for free!)
* Use legacy MapKit techniques to create draggable annotations on iPhone OS 3.1.x and 3.2.
* Use **Core Animation** to create pin effects you saw in built-in Maps.app on iPhone OS 3.1.x and 3.2.
* Use **modern runtime**, **Objective-C 2.0 ABI**, and **LLVM 1.5 compiler** (Move on, babe! Don't look back!).

## Requirements

* Xcode 3.2.3 with iOS 4 SDK or Xcode 4 Preview.
* Project file (.xcodeproj) needs to:

  1. C/C++ Compiler Version (GCC_VERSION) set to "LLVM compiler 1.5"
  2. Other C Flags (OTHER_CFLAGS) should add "-Xclang -fobjc-nonfragile-abi2" flags. 
  3. Base SDK (SDKROOT) should be "iPhone Device 4.0"
  4. Deployment Target (IPHONEOS_DEPLOYMENT_TARGET) can be "iPhone OS 3.1" if you want.

## Note

<code>-Xclang</code> here means "pass <arg> to the static analyzer," and the <arg> is <code>-fobjc-nonfragile-abi2</code>. So you should add '**"-Xclang -fobjc-nonfragile-abi2"**' into $OTHER_CFLAGS as single argument that contains one space in between, and not add them as two arguments like '**-Xclang -fobjc-nonfragile-abi2**'.

## Screenshot

![](http://github.com/digdog/MapKitDragAndDrop/raw/master/Screenshots/DDAnnotationViewiPodTouch312.png)

## License 

This sample code is licensed under MIT license.
