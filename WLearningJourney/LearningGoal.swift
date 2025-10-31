import Foundation

struct LearningGoal: Codable {
    var title: String
    var duration: String
    var startDate: Date
    var learnedDates: [Date]
    var freezedDates: [Date]
    var currentStreak: Int
    var lastActiveDate: Date
    
    init(
        title: String = "",
        duration: String = "Week",
        startDate: Date = Date(),
        learnedDates: [Date] = [],
        freezedDates: [Date] = [],
        currentStreak: Int = 0,
        lastActiveDate: Date = Date()
    ) {
        self.title = title
        self.duration = duration
        self.startDate = startDate
        self.learnedDates = learnedDates
        self.freezedDates = freezedDates
        self.currentStreak = currentStreak
        self.lastActiveDate = lastActiveDate
    }
}
