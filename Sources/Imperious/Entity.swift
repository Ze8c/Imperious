import SwiftUI

public protocol AbsEndPoint: Hashable {
    static var tabs: [Self] { get }
}

public protocol AssemblyResolver {
    associatedtype EP: AbsEndPoint
    var tabTintColor: Color? { get }
    func resolve<In>(endPoint: In) -> AnyView where In == EP
    func reaction<In>(endPoint: In) -> Imperious<Self>.Reaction where In == EP
}

extension AssemblyResolver {
    @ViewBuilder
    func tabBar(_ processor: BrickProcessor, selectTab: Binding<Tab>) -> some View {
        ForEach(EP.tabs, id: \.self) { item in
            if case let .tab(model) = reaction(endPoint: item) {
                BrickFill<Self>(processor) {
                    resolve(endPoint: item)
                }
                .tabItem {
                    model.makeTabItem(selectTab.wrappedValue == model)
                }
                .tag(model)
            }
        }
    }
}

public struct Tab: Hashable {
    static var zero: Tab { Tab(icon: Image(systemName: ""), selectIcon: Image(systemName: ""), name: "-1") }
    
    public let icon: Image
    public let selectIcon: Image?
    public let name: String
    
    public init(icon: Image, selectIcon: Image? = nil, name: String) {
        self.icon = icon
        self.selectIcon = selectIcon
        self.name = name
    }
    
    public func hash(into hasher: inout Hasher) { hasher.combine(name) }
    
    @ViewBuilder
    func makeTabItem(_ isSelect: Bool) -> some View {
        if isSelect {
            (selectIcon ?? icon).renderingMode(.template)
        } else {
            icon.renderingMode(.template)
        }
        
        Text(name)
    }
}
