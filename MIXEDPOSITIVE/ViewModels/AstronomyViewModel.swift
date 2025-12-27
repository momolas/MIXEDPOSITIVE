import Observation
import SwiftAA
import Foundation

@Observable
@MainActor
class AstronomyViewModel {
    var moonPhase: String = ""
    var element: String = ""
    var moonIlluminatedFraction: Double = 0.0
    var moonTrend: String = ""
    var moonDirection: String = ""
    var ascendingNodeDate: String = ""
    var descendingNodeDate: String = ""
    var moonSign: String = ""

    // Properties to hold state for calculation
    private let calendar = Calendar.current
    private let jd = JulianDay(Date())
    private let moon = Moon(julianDay: JulianDay(Date()))
    // paris coordinates were used in original code but not in calculation directly shown,
    // but useful if we need topocentric coordinates later.
    // Keeping it consistent with original logic which seemed to use geocentric `moon` object.

    init() {
        calculateData()
    }

    func calculateData() {
        let phase = getMoonPhase(julianDay: jd)
        let sign = getMoonSign(julianDay: jd)

        self.moonPhase = phase.rawValue
        self.element = getGardeningDay(phase: phase, sign: sign)
        self.moonIlluminatedFraction = moon.illuminatedFraction()
        self.moonTrend = getMoonTrend(julianDay: jd)
        self.moonDirection = getMoonDirection(julianDay: jd)
        self.ascendingNodeDate = getDateString(moon.passageThroughAscendingNode())
        self.descendingNodeDate = getDateString(moon.passageThroughDescendingNode())
        self.moonSign = sign.rawValue
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
        return date.formatted(date: .complete, time: .standard)
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
}
