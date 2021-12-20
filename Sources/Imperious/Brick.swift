import SwiftUI

struct Brick<Asm>: View where Asm: AssemblyResolver {
    
    @EnvironmentObject var routerEnv: Imperious<Asm>
    @ObservedObject var processor: BrickProcessor
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            
            processor.content
                .sheet(isPresented: $processor.isModal) { processor.destination }
                .onDisappear { routerEnv.checkToRemove(processor: processor) }
            
            NavigationLink(
                isActive: $processor.isPush,
                destination: { processor.destination },
                label: EmptyView.init
            )
        }
    }
    
    init(_ processor: BrickProcessor) {
        self.processor = processor
    }
}
