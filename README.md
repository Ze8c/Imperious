# Imperious

![iOS-version](https://img.shields.io/badge/iOS-13.0-black)
![SwiftUI-version](https://img.shields.io/badge/SwiftUI-1-purple)

## Router based on SwiftUI for iOS

### Screen Presentation Types:

#### 1 `single` - just current screen without stack (call this screen remove stack that was before)
#### 2 `root` - make new stack with `NavigationView` (call this screen remove stack that was before)
#### 3 `tab` - make new stack with `NavigationView` and `TabView` (call this screen remove stack that was before. `TabView` inside `NavigationView`)
#### 4 `push` - push screen into current screen stack
#### 5 `modal` - show modal screen

<img src="https://github.com/Ze8c/Imperious/blob/main/images/stack.png">

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
