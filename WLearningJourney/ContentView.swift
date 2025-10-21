//
//  ContentView.swift
//  WLearningJourney
//
//  Created by wessal hashim alharbi on 19/10/2025.
//

import SwiftUI


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

struct ContentView: View {
    @State private var username: String = ""
    @State private var selected = "Week"
    let options = ["Week", "Month", "Year"]

    // حاسبة لعرض الحاوية حسب الجهاز
    private var contentWidth: CGFloat {
        #if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad ? 480 : 360
        #else
        return 360
        #endif
    }

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()

            VStack(spacing: 0) {
                // المحتوى القابل للتمرير
                ScrollView(showsIndicators: false) {
                    // حاوية توسيط العرض العام مع بادنق 16 لكل المحتوى
                    VStack {
                        // الدائرة: تبقى في المنتصف
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

                        // باقي المحتوى: محاذاة يسار + padding 16
                        VStack(alignment: .leading, spacing: 0) {

                            // العنوان والوصف
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Hello Learner")
                                    .font(.system(size: 34, weight: .bold)).padding(.bottom,4)
                                Text("This app will help you learn everyday!")
                                    .font(.system(size: 17))
                                    .foregroundColor(.gray)
                            }
                            .frame(width: contentWidth, alignment: .leading)
                            .padding(.bottom, 31)

                            // TextField
                            VStack(alignment: .leading, spacing: 8) {
                                Text("I want to learn")
                                    .font(.system(size: 22)).padding(.bottom,4)

                                TextField("Swift", text: $username)
                                    .padding(.bottom, 8)
                                    .overlay(
                                        Rectangle()
                                            .frame(width: contentWidth , height: 1)
                                            .foregroundColor(.gray),
                                        alignment: .bottom
                                    )
                            }
                            .frame(width: contentWidth, alignment: .leading)
                            .padding(.bottom, 24)

                            // خيارات المدة
                            VStack(alignment: .leading, spacing: 12) {
                                Text("I want to learn it in a ")
                                    .font(.system(size: 18)).padding(.bottom,12)

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
                            .frame(width: contentWidth, alignment: .leading)
                            .padding(.bottom, 333)
                        }
                        .padding(.horizontal, 16) // البادنق 16 لكل المحتوى تحت الدائرة
                        .frame(maxWidth: .infinity, alignment: .leading)

                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 16) // مسافة بسيطة أسفل المحتوى
                }
                .scrollDismissesKeyboard(.interactively)

                // شريط سفلي ثابت، الزر في المنتصف
                VStack(spacing: 10) {
                    HStack {
                        Spacer(minLength: 0)
                        Text("Start learning")
                            .font(.system(size: 19))
                            .frame(width: 182, height: 48)
                            .overlay(
                                RoundedRectangle(cornerRadius: 80)
                                    .strokeBorder(
                                        Color.white.opacity(0.9),
                                        lineWidth: 0.2
                                    )
                            )
                            .glassEffect(
                                .regular
                                    .tint(Color(hex: "B34600").opacity(1))
                            )
                        Spacer(minLength: 0)
                    }
                    // نجعل عرض الحاوية يطابق عرض المحتوى + البادنق الجانبي، لكن المحاذاة وسط
                    .frame(maxWidth: contentWidth + 32, alignment: .center)
                    .padding(.horizontal, 16)

                    Color.clear.frame(height: 8)
                }
                .padding(.top, 8)
                .background(
                    Color.black.opacity(0.4).blur(radius: 8)
                )
                .frame(maxWidth: .infinity, alignment: .center)
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}




struct ContentView2: View {
    
    @State private var selectedDate = Date()
    @State private var currentWeekStart = Calendar.current.startOfWeek(for: Date())
    @State private var showMonthPicker = false
    
    var body: some View {
        NavigationStack {
            VStack{
                ZStack {
                    // الخلفية الأساسية (المربع)
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.black.opacity(9.0)) // أسود شبه صافي
                        .background(
                            // الزجاج (blur + تأثير شفاف خلفي)
                            //Color.black.opacity(0.1)
                            //  .background(.ultraThinMaterial)
                        )
                        .overlay(
                            // حدود زجاجية شفافة خفيفة
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(1.15), lineWidth: 1.9)
                        )
                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 5)
                        .frame(width: 365, height: 254)
                    
                    // محتوى التقويم داخل المربع
                    CalendarContainer(
                        selectedDate: $selectedDate,
                        currentWeekStart: $currentWeekStart,
                        showMonthPicker: $showMonthPicker
                    )
                    .padding()
                }
                
                
                Circle().frame(width: 274 , height: 274)
                    .foregroundStyle(Color(hex: "#B34600").opacity(1))
                    .glassEffect()     .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.9),
                                        Color.white.opacity(0.1),
                                        Color.white.opacity(0.4)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2.5
                            )
                            .blur(radius: 0.8)
                    )
                
                    .overlay(
                        Text("Log as\nLearned")
                            .font(.system(size: 34, weight: .bold )).multilineTextAlignment(.center)
                    )
                
                
                
                
                Text("Start learning")
                    .font(.system(size: 19))
                    .frame(width: 274, height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 80)
                            .strokeBorder(
                                Color.white.opacity(0.9),
                                lineWidth: 0.2
                            )
                    )
                    .glassEffect(
                        .regular
                            .tint(Color(hex: "008694").opacity(1))
                    )
                Text("1 out of 2 Freezes used ").font(.system(size: 14))
                
                
                
                
                
                
            }
            .navigationTitle("Swift Learning")
            .navigationBarTitleDisplayMode(.inline) // أو .large
            .toolbar {
                // زر يسار (مثل رجوع أو إعدادات)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("⚙️ Settings tapped")
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    
                }
                
            }}}}

    struct CalendarContainer: View {
        @Binding var selectedDate: Date
        @Binding var currentWeekStart: Date
        @Binding var showMonthPicker: Bool

        var body: some View {
            VStack(spacing: 16) {
                CalendarHeader(
                    currentWeekStart: $currentWeekStart,
                    showMonthPicker: $showMonthPicker,
                    selectedDate: $selectedDate
                )

                CalendarDaysRow(
                    selectedDate: $selectedDate,
                    currentWeekStart: $currentWeekStart
                )

                Divider().background(Color.white.opacity(0.2)).padding(.vertical, 6)

                // القسم القلاسي تحت الكلندر
                LearningStatsSection()
            }
            .padding(20)
            .background(
                // جعل الحاوية الرمادية كلها قلاسي
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 0.6)
                    )
            )
            .padding()
            .sheet(isPresented: $showMonthPicker) {
                MonthYearPicker(selectedDate: $selectedDate)
                    .presentationDetents([.medium])
                    .onDisappear {
                        currentWeekStart = Calendar.current.startOfWeek(for: selectedDate)
                    }
            }
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - Header
    struct CalendarHeader: View {
        @Binding var currentWeekStart: Date
        @Binding var showMonthPicker: Bool
        @Binding var selectedDate: Date

        var body: some View {
            HStack {
                Button(action: { showMonthPicker.toggle() }) {
                    HStack(spacing: 4) {
                        Text(currentWeekStart.formatted(.dateTime.month(.wide).year()))
                            .font(.system(size: 18, weight: .semibold))
                        Image(systemName: "chevron.down").foregroundColor(.orange)
                            .font(.system(size: 12, weight: .semibold))
                    }
                }

                Spacer()

                HStack(spacing: 16) {
                    Button(action: { changeWeek(by: -1) }) {
                        Image(systemName: "chevron.left").foregroundColor(.orange)
                            .font(.system(size: 16, weight: .semibold))
                        
                    }
                    Button(action: { changeWeek(by: 1) }) {
                        Image(systemName: "chevron.right").foregroundColor(.orange)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
            .foregroundStyle(.white)
        }

        private func changeWeek(by offset: Int) {
            if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: offset, to: currentWeekStart) {
                withAnimation(.easeInOut) {
                    currentWeekStart = newDate
                }
            }
        }
    }

    // MARK: - Week Row
    struct CalendarDaysRow: View {
        @Binding var selectedDate: Date
        @Binding var currentWeekStart: Date

        var body: some View {
            VStack {
                HStack{
                    ForEach(["SUN","MON","TUE","WED","THU","FRI","SAT"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity)
                    }
                }

                HStack {
                    ForEach(0..<7, id: \.self) { index in
                        let date = Calendar.current.date(byAdding: .day, value: index, to: currentWeekStart)!
                        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)

                        VStack {
                            Text(date.formatted(.dateTime.day()))
                                .font(.system(size: 25, weight: .semibold))
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(isSelected ? Color(hex: "#F67A2A") : Color.clear)
                                )
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selectedDate = date
                                    }
                                }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    // MARK: - Stats Section
    struct LearningStatsSection: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Learning Swift")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)

                HStack(spacing: 13) {
                    StatCard(icon: "flame.fill" , value: 3, label: "Days Learned", color: Color(hex: "#5C3A1C"),iconColor: Color(hex: "#FF9230")  ).cornerRadius(34)
                    StatCard(icon: "cube.fill", value: 1, label: "Day Freezed", color: Color(hex: "#1C3C4D")  ,iconColor: Color(hex: "#3CD3FE")).cornerRadius(34)
                }
            }
        }
    }

    // MARK: - StatCard
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
                        .font(.system(size: 20, weight: .bold))
                    Text(label)
                        .font(.system(size: 13))
                }
                .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    // MARK: - MonthYearPicker
    struct MonthYearPicker: View {
        @Binding var selectedDate: Date
        @Environment(\.dismiss) private var dismiss

        var body: some View {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()

                Button("Done") {
                    dismiss()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .presentationBackground(.ultraThinMaterial)
        }
    }

    // MARK: - Helpers
    extension Calendar {
        func startOfWeek(for date: Date) -> Date {
            let comps = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
            return self.date(from: comps) ?? date
        }
    }






#Preview {
    ContentView2()
        .preferredColorScheme(.dark)
}
