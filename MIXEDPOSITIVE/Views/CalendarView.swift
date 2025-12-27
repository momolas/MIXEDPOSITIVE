import SwiftUI
import SwiftAA

struct CalendarView: View {
    let days: [Date]

    init() {
        // Generate next 30 days
        var dates: [Date] = []
        let calendar = Calendar.current
        let today = Date()
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
        self.days = dates
    }

    var body: some View {
        List(days, id: \.self) { date in
            DayRow(date: date)
        }
        .navigationTitle("Calendrier")
    }
}

struct DayRow: View {
    let date: Date
    // Minimal logic replication for the list
    var phase: String {
        let moon = Moon(julianDay: JulianDay(date))
        // Rough phase name mapping or just usage of same logic as VM if extracted.
        // For simplicity, reusing a simplified check or if we made the logic static/shared.
        // We will just show the phase angle or fraction for now as "Logic is in VM" usually.
        // But let's instantiate the models to be correct.
        let angle = moon.phaseAngle().value
        return MoonPhase.fromDegree(angle).rawValue
    }

    var body: some View {
        HStack {
            Text(date.formatted(date: .abbreviated, time: .omitted))
            Spacer()
            Text(phase)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
