# RealityKitContent

A description of this package.

visionOS / RealityKit Feedback: FB16448142: reported on 2025.02.04

Reality Composer Pro Behaviors - OnTap behavior never fires timeline.


In Reality Composer Pro we can create timelines to perform actions in our scene. We can fire these timelines with the Behaviors component, which has 4 behavior types. Three of them work flawlessly, but one does not seem to work at all.

The OnTap Behavior never fires when I tap on an entity in a compiled app. I’ve tried the following
- With and without input and collision shapes
- In the simulator
- On device

To be VERY CLEAR: I am NOT talking about the tap gesture in SwiftUI, I am talking about the OnTap Behavior in Reality Composer Pro. When I include this component on an entity and set up an OnTab behavior to run a timeline, it never works. I build and compile my app and enter the immersive scene and tap on the entity. Nothing happens. 

Interesting, the only time this works is when I export the RCP scene as a USDZ. When I look at the USDZ in QuickLook on macOS, the behavior DOES file when I click on the entity. I’m not sure where the issue lies, but it is somewhere
- In Reality Composer Pro
- In the package that RCP includes in the Xcode project
- or possible a bug in visionOS / SwiftUI / RealityKit
