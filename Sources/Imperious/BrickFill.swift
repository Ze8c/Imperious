import SwiftUI

struct BrickFill<Asm>: View where Asm: AssemblyResolver {
    
    @EnvironmentObject var routerEnv: Imperious<Asm>
    @ObservedObject var processor: BrickProcessor
    
    private let content: () -> AnyView
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            
            content()
                .sheet(isPresented: $processor.isModal) { processor.destination }
                .onDisappear { routerEnv.checkToRemove(processor: processor) }
            
            NavigationLink(
                isActive: $processor.isPush,
                destination: { processor.destination },
                label: EmptyView.init
            )
        }
    }
    
    init(_ processor: BrickProcessor, content: @escaping () -> AnyView) {
        self.processor = processor
        self.content = content
    }
}
