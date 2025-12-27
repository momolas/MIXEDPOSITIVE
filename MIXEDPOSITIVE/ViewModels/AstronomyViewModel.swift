import Observation
import SwiftAA
import Foundation

@Observable
@MainActor
class AstronomyViewModel {
    var moonPhase: String = ""
    var element: String = ""
    var plantsToPlant: [String] = []
    var moonIlluminatedFraction: Double = 0.0
    var moonTrend: String = ""
    var moonDirection: String = ""
    var ascendingNodeDate: String = ""
    var descendingNodeDate: String = ""
    var moonSign: String = ""
    
    // Icons
    var moonPhaseIcon: String = "moon.stars"
    var moonTrendIcon: String = "arrow.up"
    var moonDirectionIcon: String = "arrow.up.right"
    var elementIcon: String = "leaf"
    var ascendingNodeIcon: String = "arrow.up.forward.circle"
    var descendingNodeIcon: String = "arrow.down.forward.circle"
    
    // Sun
    var sunriseTime: String = "--:--"
    var sunsetTime: String = "--:--"
    
    // Properties to hold state for calculation
    private let calendar = Calendar.current
    private let jd = JulianDay(Date())
    private let moon = Moon(julianDay: JulianDay(Date()))
    private let locationManager = LocationManager()
    
    init() {
        locationManager.requestPermission()
        
        locationManager.onLocationUpdate = { [weak self] in
            guard let self = self else { return }
            Task { @MainActor in
                self.calculateData()
            }
        }
        
        calculateData()
    }
    
    func scheduleNotifications() {
        var dateToCheck = Date()
        var daysChecked = 0
        let maxDays = 40
        
        while daysChecked < maxDays {
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: dateToCheck) else { break }
            dateToCheck = nextDate
            daysChecked += 1
            
            let jd = JulianDay(dateToCheck)
            let moon = Moon(julianDay: jd)
            let phaseAngle = moon.phaseAngle().value
            let phase = MoonPhase.fromDegree(phaseAngle)
            
            if phase == .fullMoon {
                NotificationManager.shared.scheduleFullMoonNotification(date: dateToCheck)
                break
            }
        }
    }
    
    func calculateData() {
        let phase = getMoonPhase(julianDay: jd)
        let sign = getMoonSign(julianDay: jd)
        
        self.moonPhase = phase.rawValue
        self.element = getGardeningDay(phase: phase, sign: sign)
        self.plantsToPlant = GardeningGuide.getPlants(for: self.element)
        self.moonIlluminatedFraction = moon.illuminatedFraction()
        self.moonTrend = getMoonTrend(julianDay: jd)
        self.moonDirection = getMoonDirection(julianDay: jd)
        self.ascendingNodeDate = getDateString(moon.passageThroughAscendingNode())
        self.descendingNodeDate = getDateString(moon.passageThroughDescendingNode())
        self.moonSign = sign.rawValue
        
        calculateSunTimes()
        
        self.moonPhaseIcon = getMoonPhaseIcon(phase: phase)
        self.moonTrendIcon = self.moonTrend == "Croissante" ? "arrow.up.right" : "arrow.down.right"
        self.moonDirectionIcon = self.moonDirection == "Montante" ? "arrow.up" : "arrow.down"
        self.elementIcon = getElementIcon(element: self.element)
    }
    
    private func getMoonPhaseIcon(phase: MoonPhase) -> String {
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
    
    private func getElementIcon(element: String) -> String {
        switch element {
        case "Jour racine": return "carrot"
        case "Jour feuille": return "leaf"
        case "Jour fruit": return "fork.knife" // Represents eating fruit/vegetables
        case "Jour fleur": return "camera.macro"
        default: return "leaf"
        }
    }

    private func getMoonPhase(julianDay: JulianDay) -> MoonPhase {
        let moonPhaseAngle = moon.phaseAngle()
        return MoonPhase.fromDegree(moonPhaseAngle.value)
    }
    
    private func getMoonDirection(julianDay: JulianDay) -> String {
        // Compare current ecliptic latitude with 1 hour ago
        // Increasing -> Montante (Ascending)
        // Decreasing -> Descendante (Descending)
        let currentLat = moon.eclipticCoordinates.celestialLatitude.value

        // 1 hour ago
        let prevDate = Date().addingTimeInterval(-3600)
        let prevMoon = Moon(julianDay: JulianDay(prevDate))
        let prevLat = prevMoon.eclipticCoordinates.celestialLatitude.value

        if currentLat > prevLat {
            return "Montante"
        } else {
            return "Descendante"
        }
    }
    
    private func getMoonTrend(julianDay: JulianDay) -> String {
        // Phase angle 0-180 is Waxing (Croissante)
        // Phase angle 180-360 is Waning (Décroissante)
        let phaseAngle = moon.phaseAngle().value
        let normalized = phaseAngle.truncatingRemainder(dividingBy: 360)
        let angle = normalized < 0 ? normalized + 360 : normalized
        
        if angle < 180 {
            return "Croissante"
        } else {
            return "Décroissante"
        }
    }
    
    private func getDateString(_ julianDay: JulianDay) -> String {
        let date = julianDay.date
        return date.formatted(date: .abbreviated, time: .shortened)
    }
    
    private func getGardeningDay(phase: MoonPhase, sign: ZodiacSign) -> String {
        return GardeningLogic.getGardeningDay(phase: phase, sign: sign)
    }
    
    private func getMoonSign(julianDay: JulianDay) -> ZodiacSign {
        let apparentCoordinates = moon.apparentEclipticCoordinates
        let longitude = apparentCoordinates.celestialLongitude
        return ZodiacSign.fromDegree(longitude.value)
    }
    
    private func calculateSunTimes() {
        let latitude: Double
        let longitude: Double
        
        if let loc = locationManager.location {
            latitude = loc.coordinate.latitude
            longitude = loc.coordinate.longitude
        } else {
            // Default to Paris
            latitude = 48.8566
            longitude = 2.3522
        }
        
        let coords = GeographicCoordinates(positivelyWestwardLongitude: Degree(-longitude), latitude: Degree(latitude))
        let sun = Sun(julianDay: jd)
        
        let details = RiseTransitSetTimes(celestialBody: sun, geographicCoordinates: coords)
        
        if let rise = details.riseTime {
            self.sunriseTime = rise.date.formatted(.dateTime.hour().minute())
        } else {
            self.sunriseTime = "--:--"
        }
        
        if let set = details.setTime {
            self.sunsetTime = set.date.formatted(.dateTime.hour().minute())
        } else {
            self.sunsetTime = "--:--"
        }
    }
}
