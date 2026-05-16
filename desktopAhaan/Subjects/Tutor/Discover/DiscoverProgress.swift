import Foundation

final class DiscoverProgress: Identifiable, Codable {
    var id: String
    var chapterId: String
    var sceneId: String
    var completedAt: Date
    var score: Int?
    var maxScore: Int?

    init(chapterId: String, sceneId: String, score: Int? = nil, maxScore: Int? = nil) {
        self.id = "\(chapterId)::\(sceneId)"
        self.chapterId = chapterId
        self.sceneId = sceneId
        self.completedAt = Date()
        self.score = score
        self.maxScore = maxScore
    }
}
