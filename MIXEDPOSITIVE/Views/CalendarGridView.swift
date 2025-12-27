import SwiftUI
import SwiftAA

struct CalendarGridView: View {
    @State private var selectedDate: Date?
    let days: [Date?]
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    init() {
        // Generate days for the current month
        let calendar = Calendar.current
        let today = Date()
        guard let range = calendar.range(of: .day, in: .month, for: today),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) else {
            self.days = []
            return
        }
        
        var dates: [Date?] = []
        // Add padding days for the first week
        let weekday = calendar.component(.weekday, from: startOfMonth)
        let padding = (weekday - 2 + 7) % 7
        
        for _ in 0..<padding {
            dates.append(nil)
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                dates.append(date)
            }
        }
        self.days = dates
    }
    
    var body: some View {
        ScrollView {
            VStack {
                // Header (Days of week)
                LazyVGrid(columns: columns) {
                    ForEach(["L", "M", "M", "J", "V", "S", "D"], id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .bold()
                            .foregroundStyle(.secondary)
                    }
                }
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(Array(days.enumerated()), id: \.offset) { index, date in
                        if let date = date {
                            Button(action: {
                                selectedDate = date
                            }) {
                                VStack(spacing: 4) {
                                    Text(date.formatted(.dateTime.day()))
                                        .font(.body)
                                        .foregroundStyle(.primary)
                                    
                                    MoonIcon(date: date)
                                        .font(.caption)
                                        .foregroundStyle(.yellow)
                                }
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(.regularMaterial)
                                .clipShape(.rect(cornerRadius: 8))
                            }
                        } else {
                            Color.clear
                                .frame(height: 50)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Calendrier")
        .sheet(item: $selectedDate) { date in
            DayDetailView(date: date)
                .presentationDetents([.medium, .large])
        }
    }
}

// Extension to make Date Identifiable for sheet item
extension Date: @retroactive Identifiable {
    public var id: Date { self }
}

struct MoonIcon: View {
    let date: Date
    
    var iconName: String {
        let moon = Moon(julianDay: JulianDay(date))
        let phase = MoonPhase.fromDegree(moon.elongation().value)
        switch phase {
        case .newMoon: return "moonphase.new.moon"
        case .waxingCrescent: return "moonphase.waxing.crescent"
        case .firstQuarter: return "moonphase.first.quarter"
        case .waxingGibbous: return "moonphase.waxing.gibbous"
        case .fullMoon: return "moonphase.full.moon"
        case .waningGibbous: return "moonphase.waning.gibbous"
        case .lastQuarter: return "moonphase.last.quarter"
        case .waningCrescent: return "moonphase.waning.crescent"
        case .error: return "exclamationmark.triangle"
        }
    }
    
    var body: some View {
        Image(systemName: iconName)
    }
}
