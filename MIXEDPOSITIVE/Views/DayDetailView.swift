import SwiftUI
import SwiftAA

struct DayDetailView: View {
    let date: Date
    @State private var vm: DayDetailViewModel
    
    init(date: Date) {
        self.date = date
        self._vm = State(initialValue: DayDetailViewModel(date: date))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text(date.formatted(date: .complete, time: .omitted))
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 16) {
                        DetailRow(icon: vm.moonPhaseIcon, title: "Phase", value: vm.moonPhase, color: .yellow)
                        DetailRow(icon: vm.elementIcon, title: "Jardinage", value: vm.element, color: .green)
                        
                        if !vm.plantsToPlant.isEmpty {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("À planter:")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(vm.plantsToPlant.joined(separator: ", "))
                                    .font(.body)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.regularMaterial)
                            .clipShape(.rect(cornerRadius: 10))
                        }
                        
                        DetailRow(icon: "star.fill", title: "Signe", value: vm.moonSign, color: .orange)
                    }
                    .padding()
                }
            }
            .navigationTitle("Détails")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body)
                    .bold()
            }
            Spacer()
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 10))
    }
}

@Observable
@MainActor
class DayDetailViewModel {
    var moonPhase: String = ""
    var moonPhaseIcon: String = ""
    var element: String = ""
    var elementIcon: String = ""
    var moonSign: String = ""
    var plantsToPlant: [String] = []
    
    init(date: Date) {
        let jd = JulianDay(date)
        let moon = Moon(julianDay: jd)
        let sun = Sun(julianDay: jd)
        let moonLong = moon.eclipticCoordinates.celestialLongitude.value
        let sunLong = sun.eclipticCoordinates.celestialLongitude.value
        let rawElongation = moonLong - sunLong
        let elongation = rawElongation < 0 ? rawElongation + 360 : rawElongation
        
        let phase = MoonPhase.fromDegree(elongation)
        self.moonPhase = phase.rawValue
        
        // Icon logic reused (should be shared ideally)
        switch phase {
        case .newMoon: self.moonPhaseIcon = "moonphase.new.moon"
        case .waxingCrescent: self.moonPhaseIcon = "moonphase.waxing.crescent"
        case .firstQuarter: self.moonPhaseIcon = "moonphase.first.quarter"
        case .waxingGibbous: self.moonPhaseIcon = "moonphase.waxing.gibbous"
        case .fullMoon: self.moonPhaseIcon = "moonphase.full.moon"
        case .waningGibbous: self.moonPhaseIcon = "moonphase.waning.gibbous"
        case .lastQuarter: self.moonPhaseIcon = "moonphase.last.quarter"
        case .waningCrescent: self.moonPhaseIcon = "moonphase.waning.crescent"
        case .error: self.moonPhaseIcon = "exclamationmark.triangle"
        }
        
        let longitude = moon.apparentEclipticCoordinates.celestialLongitude.value
        let sign = ZodiacSign.fromDegree(longitude)
        self.moonSign = sign.rawValue
        
        self.element = GardeningLogic.getGardeningDay(phase: phase, sign: sign)
        self.plantsToPlant = GardeningGuide.getPlants(for: self.element)
        
        switch self.element {
        case "Jour racine": self.elementIcon = "carrot"
        case "Jour feuille": self.elementIcon = "leaf"
        case "Jour fruit": self.elementIcon = "fork.knife"
        case "Jour fleur": self.elementIcon = "camera.macro"
        default: self.elementIcon = "leaf"
        }
    }
}
