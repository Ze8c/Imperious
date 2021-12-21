# Imperious

[![SwiftUI](https://img.shields.io/badge/SwiftUI-blue.svg?style=for-the-badge&logo=swift&logoColor=black)](https://developer.apple.com/xcode/swiftui)
[![Platform](https://img.shields.io/badge/iOS-13.0-black.svg?style=for-the-badge&logo=apple)](https://developer.apple.com/ios)
[![Swift](https://img.shields.io/badge/Swift-5.3-orange.svg?style=for-the-badge&logo=swift)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-13-blue.svg?style=for-the-badge&logo=Xcode&logoColor=white)](https://developer.apple.com/xcode)
[![MIT](https://img.shields.io/badge/license-MIT-black.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

# Simple navigation based on SwiftUI for iOS

## Index
* [Installation](#installation)
* [Screen Presentation Types](#screen-presentation-types)
* [How to use](#how-to-use)
* [License](#license)
<br>

## Installation
In Xcode add the dependency to your project via *File > Add Packages > Search or Enter Package URL* and use the following url:
```
https://github.com/Ze8c/Imperious.git
```

Once added, import the package in your code:
```swift
import Imperious
```
<br>

## Screen Presentation Types:

#### 1 `single` - just current screen without stack (call this screen remove stack that was before)
#### 2 `root` - make new stack with `NavigationView` (call this screen remove stack that was before)
#### 3 `tab` - make new stack with `NavigationView` and `TabView` (call this screen remove stack that was before. `TabView` inside `NavigationView`)
#### 4 `push` - push screen into current screen stack
#### 5 `modal` - show modal screen

<img src="https://github.com/Ze8c/Imperious/blob/main/images/stack.png">
<br>

## How to use

### 1 Start with creating a `enum EndPoint` that implementing protocol `AbsEndPoint`

```swift
enum EndPoint {
    static var tabs: [EndPoint] { [.one, .two] }
    
    case one
    case two
}
```


### 2 Describe your screens into `Assemblies` that implementing protocol `AssemblyResolver`

```swift
struct ScrAssembly: AssemblyResolver {
    typealias EP = EndPoint
    
    init() {
    
    }
    
    var tabTintColor: Color? { .black }
    
    func resolve(endPoint: EndPoint) -> AnyView {
        switch endPoint {
        case .one: return oneView()
        case .two: return twoView()
        }
    }
    
    func reaction(endPoint: EndPoint) -> Imperious<ScrAssembly>.Reaction {
        switch endPoint {
        case .one: return .tab(Tab(
            icon: Image(systemName: "1.circle"),
            selectIcon: Image(systemName: "1.square"),
            name: "One"
        ))
        case .two: return .tab(Tab(
            icon: Image(systemName: "2.circle"),
            selectIcon: Image(systemName: "2.square"),
            name: "Two"
        ))
        }
    }
    
    private func oneView() -> AnyView {
        AnyView(OneV())
    }
    
    private func twoView() -> AnyView {
        AnyView(TwoV())
    }
}
```

### 3 Make enter point in project start file

```swift
@main
struct CommonProjectApp: App {
    
    private let assembler: ScrAssembly
    private let router: Imperious<ScrAssembly>
    
    var body: some Scene {
        WindowGroup {
            router.startView()
        }
    }
    
    init() {
        assembler = ScrAssembly()
        router = Imperious.make(startPoint: .one, from: assembler)
    }
}
```

### 4 And after this simple steps your application ready to use routing
Where needed can call screen, something like this:

```swift
router.dispatch(.two)
```
<br>

## License
[MIT License](LICENSE)
