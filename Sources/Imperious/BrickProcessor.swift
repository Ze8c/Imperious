import SwiftUI

final class BrickProcessor: ObservableObject {
    private let id = UUID()
    var isPush = false
    var isModal = false
    var isTabBar = false
    var content: AnyView = EmptyView().asAnyView
    var destination: AnyView = EmptyView().asAnyView
    
    init() {
        #if DEBUG
        print("LOG > INIT BrickProcessor: \(id)")
        #endif
    }
    
    deinit {
        #if DEBUG
        print("LOG > DEINIT BrickProcessor: \(id)")
        #endif
    }
    
    func setContent(_ content: AnyView, destination: AnyView) {
        self.content = content
        setDestination(destination)
    }
    
    func setDestination(_ destination: AnyView) {
        self.destination = destination
        objectWillChange.send()
    }
    
    func push() {
        isPush = true
        objectWillChange.send()
    }
    
    func modal() {
        isModal = true
        objectWillChange.send()
    }
}

extension BrickProcessor: Hashable {
    static func == (lhs: BrickProcessor, rhs: BrickProcessor) -> Bool { lhs.id == rhs.id }
    
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
