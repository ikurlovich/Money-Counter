import SwiftUI

struct JointView: View {
    @StateObject private var vm = LogicaVM()
    var body: some View {
        // Агрегатор всех видов
        TabView {
            HomeView()
                .tabItem {
                    Label("Главнвая", systemImage: "house.fill")
                }
        }
        .environmentObject(LogicaVM())
    }
}

struct JointView_Previews: PreviewProvider {
    static var previews: some View {
        JointView()
            .environmentObject(LogicaVM())
    }
}
