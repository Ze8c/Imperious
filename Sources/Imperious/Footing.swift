import SwiftUI

struct Footing<Asm>: View where Asm: AssemblyResolver {
    
    @EnvironmentObject var routerEnv: Imperious<Asm>
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            
            routerEnv.rootView($routerEnv.tabSelected)
        }
    }
    
    init() {}
}
