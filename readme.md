# Flying Squares - SwiftUI/SpriteKit Game

A physics-based app built with SwiftUI and SpriteKit.

- **Physics-based** using SpriteKit physics engine
- **Gyroscope integration** for device tilt controls
- **Collision detection** between squares and screen edges
- **Automatic force pushes** every 7.5 seconds
//
- **Memory Management**: Proper cleanup in `deinit`
- **Constants**: Organized `Consts` struct
- **Architecture**: Protocol-based design with separation of concerns
- **Error Handling**: Graceful degradation for missing gyroscope

### FlyingSquareNode
- Encapsulates sprite and physics behavior
- Provides clean interface for game logic
- Easy to extend and modify

### SceneConstructor
- Proper lifecycle management
- Memory leak prevention
- Clean separation of setup methods
- Robust collision handling

## Getting Started

1. Open `FlyingSquares.xcodeproj` in Xcode
2. Build and run on a physical device (gyroscope required)
3. Tilt your device to control gravity
4. Watch the squares bounce and collide!

## Requirements

- iOS 15.2+
- Physical device with gyroscope
- Xcode 12.0+

https://user-images.githubusercontent.com/65627244/159684080-f30569d3-deb3-4284-bb6e-51016e175f48.gif

