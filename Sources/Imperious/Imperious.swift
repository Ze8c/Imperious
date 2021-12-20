import SwiftUI

public final class Imperious<Asm>: ObservableObject where Asm: AssemblyResolver {
    
    public enum Reaction {
        case modal
        case push
        case root
        case single
        case tab(Tab)
    }
    
    let assembly: Asm
    var rootView: (Binding<Tab>) -> AnyView = { _ in EmptyView().asAnyView }
    var rootEndPoint: Asm.EP!
    @Published var tabSelected: Tab = .zero
    var rootProcessor: BrickProcessor
    var screenProcessors: [BrickProcessor] = []
    var destinationProcessor: BrickProcessor!
    
    private init(viewResolver: Asm, rootProcessor: BrickProcessor) {
        assembly = viewResolver
        self.rootProcessor = rootProcessor
    }
    
    @MainActor
    public static func make(startPoint: Asm.EP, from viewResolver: Asm) -> Imperious<Asm> {
        let env = Imperious(viewResolver: viewResolver, rootProcessor: BrickProcessor())
        env.dispatch(startPoint)
        return env
    }
    
    public func startView() -> AnyView {
        Footing<Asm>().environmentObject(self).asAnyView
    }
    
    public func startVC() -> UIViewController {
        UIHostingController(rootView: startView())
    }
    
    @MainActor
    public func dispatch(_ ePoint: Asm.EP) {
        let dProcessor = BrickProcessor()
        let destination = Brick<Asm>(dProcessor).environmentObject(self).asAnyView
        
        switch assembly.reaction(endPoint: ePoint) {
        case .modal: modal(ePoint, destination: destination)
        case .push: push(ePoint, destination: destination)
        case .root: root(ePoint, destination: destination)
        case .single: single(ePoint, destination: destination)
        case let .tab(model): tabs(model, destination: destination)
        }
        
        destinationProcessor = dProcessor
    }
    
    func checkToRemove(processor: BrickProcessor) {
        if screenProcessors.contains(processor) && !(processor.isPush || processor.isModal) {
            screenProcessors.removeAll { item in item == processor }
            destinationProcessor = processor
        }
    }
    
    private func modal(_ ePoint: Asm.EP, destination: AnyView) {
        let content = assembly.resolve(endPoint: ePoint)
        let proc = screenProcessors.isEmpty ? rootProcessor : screenProcessors.last
        destinationProcessor.setContent(content, destination: destination)
        screenProcessors.append(destinationProcessor)
        proc?.modal()
    }
    
    private func push(_ ePoint: Asm.EP, destination: AnyView) {
        let content = assembly.resolve(endPoint: ePoint)
        let proc = screenProcessors.isEmpty ? rootProcessor : screenProcessors.last
        destinationProcessor.setContent(content, destination: destination)
        screenProcessors.append(destinationProcessor)
        proc?.push()
    }
    
    private func root(_ ePoint: Asm.EP, destination: AnyView) {
        tabSelected = .zero
        
        if !screenProcessors.isEmpty && screenProcessors.count > 1 {
            let preLastIdx = screenProcessors.count - 2
            screenProcessors[preLastIdx].isModal = false
            screenProcessors[preLastIdx].objectWillChange.send()
        }
        
        rootProcessor.isModal = false
        rootProcessor.isPush = false
        screenProcessors = []
        
        if ePoint == rootEndPoint {
            
        } else {
            let content = assembly.resolve(endPoint: ePoint)
            let rProcessor = BrickProcessor()
            
            rootView = { _ in
                NavigationView {
                    BrickFill<Asm>(rProcessor) { content }.environmentObject(self)
                }.asAnyView
            }
            
            objectWillChange.send()
            
            rootProcessor = rProcessor
        }
        
        rootProcessor.setDestination(destination)
    }
    
    private func single(_ ePoint: Asm.EP, destination: AnyView) {
        tabSelected = .zero
        
        if !screenProcessors.isEmpty && screenProcessors.count > 1 {
            let preLastIdx = screenProcessors.count - 2
            screenProcessors[preLastIdx].isModal = false
            screenProcessors[preLastIdx].objectWillChange.send()
        }
        
        rootProcessor.isModal = false
        rootProcessor.isPush = false
        screenProcessors = []
        
        if ePoint != rootEndPoint {
            let content = assembly.resolve(endPoint: ePoint)
            let rProcessor = BrickProcessor()
            
            rootView = { _ in
                BrickFill<Asm>(rProcessor) { content }.environmentObject(self).asAnyView
            }
            
            objectWillChange.send()
            
            rootProcessor = rProcessor
        }
        
        rootProcessor.setDestination(destination)
    }
    
    private func tabs(_ model: Tab, destination: AnyView) {
        tabSelected = model
        rootProcessor.isModal = false
        rootProcessor.isPush = false
        screenProcessors = []
        
        if !rootProcessor.isTabBar {
            let rProcessor = BrickProcessor()
            
            rootView = { [unowned self] selectTab in
                NavigationView {
                    TabView(selection: selectTab) {
                        assembly.tabBar(rProcessor, selectTab: selectTab).environmentObject(self)
                    }
                    .accentColor(assembly.tabTintColor)
                }.asAnyView
            }
            
            rootProcessor = rProcessor
            rootProcessor.isTabBar = true
        }
        
        rootProcessor.setDestination(destination)
        objectWillChange.send()
    }
}
