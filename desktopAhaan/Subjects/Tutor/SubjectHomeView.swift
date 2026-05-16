import SwiftUI

struct SubjectHomeView: View {
    let pack: SubjectPack

    var body: some View {
        TutorNavigationContainer {
            ChapterListView(pack: pack)
        }
    }
}
