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
        // Observe location changes? In pure Swift Observation, this is tricky if LocationManager is a separate object.
        // We can just call calculateData when accessing or trigger updates.
        // For simplicity, we'll start location updates and recalculate when location changes if possible.
        // However, linking them in this structure without Combine is manual.
        // Let's just request permission and use the location if available.
        locationManager.requestPermission()

        // Recalculate when location updates
        locationManager.onLocationUpdate = { [weak self] in
            guard let self = self else { return }
            Task { @MainActor in
                self.calculateData()
            }
        }

        calculateData()
    }

    func scheduleNotifications() {
        // To find the next full moon, we can iterate or use a known algorithm.
        // A simple way is to check the phase for future dates.
        // Or just schedule a generic notification for demonstration if SwiftAA's helper is missing.
        // Let's iterate day by day until we hit a Full Moon phase.

        var dateToCheck = Date()
        var daysChecked = 0
        let maxDays = 40 // Lunar cycle is ~29.5 days

        while daysChecked < maxDays {
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: dateToCheck) else { break }
            dateToCheck = nextDate
            daysChecked += 1

            let jd = JulianDay(dateToCheck)
            let moon = Moon(julianDay: jd)
            let phaseAngle = moon.phaseAngle().value
            let phase = MoonPhase.fromDegree(phaseAngle)

            if phase == .fullMoon {
                // Found it
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
        case "Jour fruit": return "apple.logo" // apple.logo might be technically "apple", but "cup.and.saucer" or something else might be better. There is no generic fruit icon in standard SF Symbols usually, maybe "apple.logo" is bad practice as it's a brand. Let's use "fork.knife" or "circle.fill". Wait, "carrot" exists? "leaf" exists.
        // Checking SF Symbols... "carrot" exists in SF Symbols 4. "leaf" exists. "apple.logo" exists but is the Apple logo.
        // For fruit, maybe "circle.hexagongrid.fill" (seeds)? Or just "leaf.arrow.circlepath"?
        // Actually "drop.fill" for water (leaf?), "flame.fill" for fruit (fire/warmth)?
        // Biodynamics elements: Root (Earth), Leaf (Water), Flower (Air), Fruit (Fire).
        // Earth: "globe.europe.africa.fill" or "square.stack.3d.up.fill" (solid). Maybe "leaf" (root? no).
        // Let's stick to simple ones.
        // Racine -> "carrot" (if exists, checking context... carrot was added in SF Symbols 4? I think so). If not, "circle.circle".
        // Fleur -> "camera.macro" (flower icon? No). "rosette"? "star"?
        // Let's try to map best effort.
        case "Jour fleur": return "camera.macro" // Resembles a flower
        default: return "leaf"
        }
    }

    private func getMoonPhase(julianDay: JulianDay) -> MoonPhase {
        // Calcul de l'angle de phase de la lune à partir de la date julienne
        let moonPhaseAngle = moon.phaseAngle()
        return MoonPhase.fromDegree(moonPhaseAngle.value)
    }

    private func getMoonDirection(julianDay: JulianDay) -> String {
        let ascendingNode = moon.passageThroughAscendingNode()
        if jd < ascendingNode {
            return "Descendante"
        } else {
            return "Montante"
        }
    }

    private func getMoonTrend(julianDay: JulianDay) -> String {
        let currentDate = Date()
        // Force unwrap safe here as date calculation is standard
        guard let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) else {
            return "Inconnu"
        }

        let currentPhase = moon.illuminatedFraction()
        let previousMoon = Moon(julianDay: JulianDay(previousMonth))
        let previousPhase = previousMoon.illuminatedFraction()

        if currentPhase > previousPhase {
            return "Croissante"
        } else {
            return "Décroissante"
        }
    }

    private func getDateString(_ julianDay: JulianDay) -> String {
        // Using DateFormatter as originally, but could update to Text(format:) in View.
        // However, this returns a String for the VM.
        // Directives say "Prefer modern Foundation API".
        // We can use date.formatted() in Swift.
        let date = julianDay.date
        return date.formatted(date: .abbreviated, time: .shortened)
    }

    private func getGardeningDay(phase: MoonPhase, sign: ZodiacSign) -> String {
        switch (phase, sign) {
        case (.newMoon, .aries), (.lastQuarter, .cancer), (.lastQuarter, .scorpio), (.waningGibbous, .scorpio), (.waxingCrescent, .taurus), (.waxingCrescent, .virgo), (.waxingGibbous, .capricorn), (.waxingGibbous, .pisces):
            return "Jour racine"
        case (.newMoon, .taurus), (.firstQuarter, .cancer), (.firstQuarter, .scorpio), (.fullMoon, .aries), (.fullMoon, .leo), (.fullMoon, .sagittarius), (.fullMoon, .aquarius), (.waningCrescent, .pisces):
            return "Jour feuille"
        case (.firstQuarter, .aries), (.firstQuarter, .leo), (.firstQuarter, .sagittarius), (.waxingGibbous, .gemini), (.waxingGibbous, .libra), (.waningCrescent, .taurus), (.waningCrescent, .virgo), (.waningCrescent, .capricorn):
            return "Jour fruit"
        case (.newMoon, .gemini), (.newMoon, .virgo), (.newMoon, .sagittarius), (.newMoon, .pisces), (.firstQuarter, .taurus), (.firstQuarter, .virgo), (.firstQuarter, .capricorn), (.fullMoon, .gemini), (.fullMoon, .libra), (.waningCrescent, .aries), (.waningCrescent, .leo), (.waningCrescent, .sagittarius), (.waningCrescent, .aquarius):
            return "Jour fleur"
        default:
            return "Autre jour"
        }
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

        // RiseTransitSetTimes init signature check: (celestialBody: CelestialBody, geographicCoordinates: GeographicCoordinates)
        // It uses the JD from the celestial body.
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
