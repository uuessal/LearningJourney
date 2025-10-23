//
//  ContentView.swift
//  WLearningJourney
//
//  Created by wessal hashim alharbi on 19/10/2025.
//

import SwiftUI
import Combine

// MARK: - COLOR EXTENSION
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - MAIN VIEW (PAGE 1)
struct ContentView: View {
    @State private var userlearning: String = ""
    @State private var selected = "Week"
    let options = ["Week", "Month", "Year"]

    // نحفظ اختيارات المستخدم في AppStorage
    @AppStorage("selectedDuration") private var selectedDuration: String = "Week"
    @AppStorage("selectedLearning") private var selectedLearning: String = ""

    private var contentWidth: CGFloat {
        #if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad ? 480 : 360
        #else
        return 360
        #endif
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear.ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            // الدائرة
                            Circle()
                                .frame(width: 120, height: 120)
                                .foregroundStyle(Color(hex: "#1A0800").opacity(0.9))
                                .glassEffect()
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.9),
                                                    Color.orange.opacity(0.1),
                                                    Color.white.opacity(0.4)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 0.5
                                        )
                                        .blur(radius: 0.8)
                                )
                                .overlay(
                                    Image(systemName: "flame.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.orange)
                                        .frame(width: 40, height: 40)
                                )
                                .padding(.top, 24)
                                .padding(.bottom, 47)
                                .frame(maxWidth: .infinity, alignment: .center)

                            // النصوص
                            VStack(alignment: .leading, spacing: 0) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Hello Learner")
                                        .font(.system(size: 34, weight: .bold))
                                    Text("This app will help you learn everyday!")
                                        .font(.system(size: 17))
                                        .foregroundColor(.gray)
                                }
                                Spacer().frame(height: 31)

                                // TextField
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("I want to learn")
                                        .font(.system(size: 22))

                                    TextField("Swift", text: $userlearning)
                                        .padding(.bottom, 8)
                                        .overlay(
                                            Rectangle()
                                                .frame(width: contentWidth , height: 1)
                                                .foregroundColor(.gray),
                                            alignment: .bottom
                                        )
                                }

                                Spacer().frame(height: 24)

                                // المدة
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("I want to learn it in a ")
                                        .font(.system(size: 18))
                                        .padding(.bottom, 12)

                                    HStack(spacing: 16) {
                                        ForEach(options, id: \.self) { option in
                                            Text(option)
                                                .font(.system(size: 19, weight: .semibold))
                                                .frame(width: 97, height: 48)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 80)
                                                        .fill(Color.clear)
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 80)
                                                        .strokeBorder(
                                                            selected == option
                                                            ? Color.white.opacity(0.9)
                                                            : Color.white.opacity(0.1),
                                                            lineWidth: 0.2
                                                        )
                                                )
                                                .glassEffect(
                                                    selected == option
                                                    ? .regular.tint(Color(hex: "#B34600").opacity(1))
                                                    : .regular
                                                )
                                                .onTapGesture {
                                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                        selected = option
                                                    }
                                                }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 333)
                            }
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 16)
                    }
                    .scrollDismissesKeyboard(.interactively)

                    // الزر السفلي
                    VStack(spacing: 10) {
                        HStack {
                            Spacer(minLength: 0)

                            NavigationLink(destination: ContentView2()) {
                                Text("Start learning")
                                    .font(.system(size: 19))
                                    .frame(width: 182, height: 48)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 80)
                                            .strokeBorder(Color.white.opacity(0.9), lineWidth: 0.2)
                                    )
                                    .glassEffect(.regular.tint(Color(hex: "B34600").opacity(1)))
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                selectedDuration = selected
                                selectedLearning = userlearning
                            })

                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: contentWidth + 32, alignment: .center)
                        .padding(.horizontal, 16)

                        Color.clear.frame(height: 8)
                    }
                    .padding(.top, 8)
                    .background(Color.black.opacity(0.4).blur(radius: 8))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
    }
}






// MARK: - VIEWMODEL
@MainActor
class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published var currentWeekStart: Date

    @AppStorage("learnedDatesData") private var learnedDatesData: Data = Data()
    @AppStorage("freezedDatesData") private var freezedDatesData: Data = Data()
    @AppStorage("selectedDuration") private var selectedDuration: String = "Week"

    

    @Published private(set) var learnedDates: Set<Date> = []
    @Published private(set) var freezedDates: Set<Date> = []

    @Published var showMonthPicker = false
    @Published var isTodayLogged: Bool = false
    @Published var isTodayFreezed: Bool = false

    private var midnightTimer: Timer?

    init() {
        let today = Date()
        self.selectedDate = today
        self.currentWeekStart = Calendar.current.startOfWeek(for: today)
        loadData()
        checkIfTodayLogged()
        scheduleMidnightReset()
    }
    
    
    /// عدد الفريزز المسموح بها حسب المدة
    var totalFreezesAllowed: Int {
        switch selectedDuration {
        case "Week": return 2
        case "Month": return 4
        case "Year": return 12
        default: return 2
        }
    }

    /// عدد الفريزز المستخدمة فعلاً
    var usedFreezes: Int {
        freezedDates.count
    }

    
    /// عدد الفريزز المستخدمة فعلاً
    var usedLearned: Int {
        learnedDates.count
    }
    /// هل المستخدم استهلك كل الفريزز؟
    var hasReachedFreezeLimit: Bool {
        usedFreezes >= totalFreezesAllowed
    }
    
    

    func markTodayAsLearned() {
        let today = normalized(Date())
        guard !isTodayLogged else { return }
        learnedDates.insert(today)
        saveData()
        checkIfTodayLogged()
        objectWillChange.send()
    }

    func markTodayAsFreezed() {
        let today = normalized(Date())
        guard !isTodayFreezed else { return }
        freezedDates.insert(today)
        saveData()
        checkIfTodayLogged()
        objectWillChange.send()
    }

    func isLearned(_ date: Date) -> Bool {
        learnedDates.contains(normalized(date))
    }

    func isFreezed(_ date: Date) -> Bool {
        freezedDates.contains(normalized(date))
    }

    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }

    func changeWeek(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: value, to: currentWeekStart) {
            currentWeekStart = newDate
        }
    }

    private func normalized(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    func checkIfTodayLogged() {
        let today = normalized(Date())
        isTodayLogged = learnedDates.contains(today)
        isTodayFreezed = freezedDates.contains(today)
    }

    private func scheduleMidnightReset() {
        midnightTimer?.invalidate()
        let now = Date()
        if let midnight = Calendar.current.nextDate(after: now, matching: DateComponents(hour: 0), matchingPolicy: .nextTime) {
            let interval = midnight.timeIntervalSince(now)
            midnightTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
                self?.checkIfTodayLogged()
                self?.scheduleMidnightReset()
            }
        }
    }

    private func saveData() {
        let encoder = JSONEncoder()
        if let learnedData = try? encoder.encode(Array(learnedDates)) {
            learnedDatesData = learnedData
        }
        if let freezedData = try? encoder.encode(Array(freezedDates)) {
            freezedDatesData = freezedData
        }
    }

    private func loadData() {
        let decoder = JSONDecoder()
        if let decodedLearned = try? decoder.decode([Date].self, from: learnedDatesData) {
            learnedDates = Set(decodedLearned)
        }
        if let decodedFreezed = try? decoder.decode([Date].self, from: freezedDatesData) {
            freezedDates = Set(decodedFreezed)
        }
    }
}

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let comps = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: comps) ?? date
    }
}



// MARK: - MAIN VIEW (PAGE 2)
struct ContentView2: View {
    @StateObject private var viewModel = CalendarViewModel()
    @AppStorage("selectedDuration") private var selectedDuration: String = "Week"
    @AppStorage("selectedLearning") private var selectedLearning: String = ""
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Activity")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 10) {
                        NavigationLink(destination: FullCalendarView(viewModel: viewModel)) {
                            CircleButton(icon: "calendar")
                        }
                        .buttonStyle(.plain) // يمنع الشكل الافتراضي ويحافظ على التصميم
                        
                        CircleButton(icon: "pencil.and.outline")
                    }
                    
                }
                .padding(.horizontal, 20)
                
                CalendarContainer(viewModel: viewModel)
                
                Button(action: {
                    viewModel.markTodayAsLearned()
                }) {
                    Circle()
                        .frame(width: 274, height: 274)
                        .foregroundStyle(
                            viewModel.isTodayLogged
                            ? Color(hex: "#140000")
                            : viewModel.isTodayFreezed
                            ? Color(hex: "#00060C")
                            : Color(hex: "#B34600")
                        )
                        .glassEffect()
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.9),
                                            Color.gray.opacity(0.01),
                                            Color.white.opacity(0.4)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.6
                                )
                        )
                        .overlay(
                            viewModel.isTodayLogged
                            ? Text("Learned\nToday")
                                .font(.system(size: 34, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(hex: "#FF9230"))
                            : viewModel.isTodayFreezed
                            ? Text("Day\nFreezed")
                                .font(.system(size: 34, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(hex: "#00D2E0"))
                            : Text("Log as\nLearned")
                                .font(.system(size: 34, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        )
                }
                .disabled(viewModel.isTodayLogged || viewModel.isTodayFreezed)
                
                Button(action: {
                    viewModel.markTodayAsFreezed()
                }) {
                    RoundedRectangle(cornerRadius: 80)
                        .fill(
                            viewModel.isTodayFreezed || viewModel.hasReachedFreezeLimit
                            
                            ? Color(hex: "#091C1D")
                            : Color(hex: "#008694")
                        )
                        .frame(width: 274, height: 48)    .overlay(
                            RoundedRectangle(cornerRadius: 80)
                                .strokeBorder(Color.white.opacity(0.9), lineWidth: 0.5)
                        )
                        .overlay(
                            
                            
                            Text("Log as Freezed")
                                .font(.system(size: 19, weight: .semibold))
                                .foregroundColor(.white)
                        )
                        .glassEffect(.regular.tint(.clear))
                }
                .disabled(viewModel.isTodayLogged || viewModel.isTodayFreezed || viewModel.hasReachedFreezeLimit)
                
                Text("\(viewModel.usedFreezes) out of \(viewModel.totalFreezesAllowed) Freezes used (\(selectedDuration))")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray.opacity(0.5))
                
            }
            .padding(.vertical, 20)
            .preferredColorScheme(.dark)
        }
    }}




// MARK: - REUSABLE COMPONENTS
struct CircleButton: View {
    var icon: String
    var body: some View {
        Image(systemName: icon)
            .foregroundColor(.white)
            .frame(width: 44, height: 44)
            .background(
                Circle()
                    .fill(Color.gray.opacity(0.01))
                    .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
            )
            .glassEffect()
    }
}


// MARK: - FULL CALENDAR VIEW
struct FullCalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                ForEach(generateMonths(), id: \.self) { monthStart in
                    let monthName = monthStart.formatted(.dateTime.month(.wide).year())

                    VStack(alignment: .leading, spacing: 10) {
                        Text(monthName)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal)

                        CalendarMonthView(
                            monthStart: monthStart,
                            viewModel: viewModel
                        )
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .background(Color.black.ignoresSafeArea())
        .toolbar {

            ToolbarItem(placement: .principal) {
                Text("All activities")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }

    // توليد أول يوم في كل شهر من آخر 12 شهر
    private func generateMonths() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        var months: [Date] = []

        for i in 0..<12 {
            if let month = calendar.date(byAdding: .month, value: -i, to: today),
               let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) {
                months.append(startOfMonth)
            }
        }

        return months.sorted(by: >) // الأحدث أولاً
    }
}

// MARK: - MONTH GRID
struct CalendarMonthView: View {
    var monthStart: Date
    @ObservedObject var viewModel: CalendarViewModel

    var body: some View {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: monthStart)!
        let days = Array(range)
        let firstWeekday = calendar.component(.weekday, from: monthStart)

        VStack(spacing: 8) {
            // الأيام بالأحرف
            HStack(spacing: 0) {
                ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }

            // الشبكة
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                // فراغات قبل أول يوم
                ForEach(0..<firstWeekday - 1, id: \.self) { _ in
                    Color.clear.frame(height: 40)
                }

                // الأيام
                ForEach(days, id: \.self) { day in
                    let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart)!
                    let isLearned = viewModel.isLearned(date)
                    let isFreezed = viewModel.isFreezed(date)

                    Text("\(day)")
                        .frame(width: 40, height: 40)
                        .background(
                            Circle().fill(
                                isLearned ? Color(hex: "#B34600") :
                                (isFreezed ? Color(hex: "#007C91") : Color(hex: "#1A0800"))
                            )
                        )
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            Divider().background(Color.white.opacity(0.2)).padding(.horizontal)
        }
    }
}



struct CalendarContainer: View {
    @ObservedObject var viewModel: CalendarViewModel
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(viewModel.currentWeekStart.formatted(.dateTime.month(.wide).year()))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)

                Spacer()

                Button {
                    viewModel.changeWeek(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.orange)
                        .font(.system(size: 16, weight: .semibold))
                }

                Button {
                    viewModel.changeWeek(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.orange)
                        .font(.system(size: 16, weight: .semibold))
                }
            }

            Weekdays()
            DatesRow(viewModel: viewModel)

            Divider().background(Color.white.opacity(0.2)).padding(.vertical, 6)

            LearningStatsSection()
        }
        .padding(20)
        .frame(width: 400, height: 280)
        .background(
            RoundedRectangle(cornerRadius: 13)
                .fill(Color.black.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 13)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .padding()
        .preferredColorScheme(.dark)
    }

    private struct Weekdays: View {
        private let labels = ["SUN","MON","TUE","WED","THU","FRI","SAT"]
        var body: some View {
            HStack(spacing: 18) {
                ForEach(labels, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private struct DatesRow: View {
        @ObservedObject var viewModel: CalendarViewModel
        var body: some View {
            HStack {
                ForEach(0..<7, id: \.self) { index in
                    let date = Calendar.current.date(byAdding: .day, value: index, to: viewModel.currentWeekStart)!
                    let isToday = viewModel.isToday(date)
                    let isLearned = viewModel.isLearned(date)
                    let isFreezed = viewModel.isFreezed(date)

                    VStack {
                        Text(date.formatted(.dateTime.day()))
                            .font(.system(size: 25, weight: .semibold))
                            .frame(width: 44, height: 44)
                            .background(
                                Circle().fill(
                                    isLearned ? Color(hex: "#5C3A1C") :
                                    (isFreezed ? Color(hex: "#1C3C4D") :
                                     (isToday ? Color(hex: "#F67A2A").opacity(0.3) : .clear))
                                )
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct LearningStatsSection: View {
    @StateObject private var viewModel = CalendarViewModel()

    @AppStorage("selectedLearning") private var selectedLearning: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Learning \(selectedLearning)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)

            HStack(spacing: 13) {
                StatCard(icon: "flame.fill", value: viewModel.usedLearned , label:
                            
                            viewModel.usedLearned == 1 || viewModel.usedLearned == 0
                         ?"Day Learned"
                         :"Days Learned",
                         color: Color(hex: "#5C3A1C"),
                         iconColor: Color(hex: "#FF9230"))
                    .frame(width: 160, height: 69)
                    .cornerRadius(34)

                StatCard(icon: "cube.fill", value: viewModel.usedFreezes , label:
                            
                            
                            viewModel.usedFreezes == 1 || viewModel.usedFreezes == 0
                           ? "Day Freezed"
                           : "Days Freezed",
                         
                         color: Color(hex: "#1C3C4D"),
                         iconColor: Color(hex: "#3CD3FE"))
                    .frame(width: 160, height: 69)
                    .cornerRadius(34)
            }
        }
    }
}

struct StatCard: View {
    var icon: String
    var value: Int
    var label: String
    var color: Color
    var iconColor: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(value)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                Text(label)
                    .font(.system(size: 13))
                      .foregroundStyle(.white)

            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 34)
                .fill(color.opacity(0.7))
        )
    }
}


#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
