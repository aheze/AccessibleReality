![Accessible Reality](GitHub/Header.png)

### My WWDC21 Swift Student Challenge submission
I made a playground book that teaches you the basics of ARKit through interactive lessons. It covers positioning, hit-testing, and how to calculate relationships between objects. In the end, it combines all these concepts into an app: A navigation aid for those who are visually impaired.

### Screenshots

Intro | Positioning | Distance | Angles | Completed App
--- | --- | --- | --- | ---
[![](GitHub/Screenshots/Thumb-Gallery.PNG)](GitHub/Screenshots/Thumb-Gallery.PNG) | [![](GitHub/Screenshots/Thumb-Positioning.PNG)](GitHub/Screenshots/Positioning.PNG) | [![](GitHub/Screenshots/Thumb-Distance.PNG)](GitHub/Screenshots/Distance.PNG) | [![](GitHub/Screenshots/Thumb-Angle.PNG)](GitHub/Screenshots/Angle.PNG) | [![](GitHub/Screenshots/Thumb-Completed.PNG)](GitHub/Screenshots/Completed.PNG)
[![](GitHub/Screenshots/Thumb-Intro.PNG)](GitHub/Screenshots/Intro.PNG) | [![](GitHub/Screenshots/Thumb-Positioning-run.PNG)](GitHub/Screenshots/Positioning-run.PNG) | [![](GitHub/Screenshots/Thumb-Distance-run.PNG)](GitHub/Screenshots/Distance-run.PNG) | [![](GitHub/Screenshots/Thumb-Angle-run.PNG)](GitHub/Screenshots/Angle-run.PNG) | [![](GitHub/Screenshots/Thumb-Completed-run.PNG)](GitHub/Screenshots/Completed-run.PNG)

### Want to make your own playground book?
For me, making a playground book was much harder than a regular Xcode project. Here's some tips that I picked up along the way.

#### Development
- Instead of dragging files into the project, create them locally (<kbd>Command</kbd> + <kbd>N</kbd>), them copy over the contents. Whenever I dragged in a file, I got a "There was a problem running this page" error.
- Use ARKit instead of RealityKit. The camera preview works, but I was never able to see my objects in the scene.
- Pre-compile ML models if possible. See [this article](https://heartbeat.fritz.ai/how-to-run-and-test-core-ml-models-in-swift-playgrounds-8e4b4f9cf676) for details.
- Every time you make changes in the storyboard, clean the project (<kbd>Shift</kbd> + <kbd>Command</kbd> + <kbd>K</kbd>), otherwise your changes won't show
- To change the name of the playground, edit the `BuildSettings.xcconfig` file




