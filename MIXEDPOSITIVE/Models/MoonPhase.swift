import Foundation

enum MoonPhase: String, CaseIterable {
    case newMoon        = "Nouvelle lune"
    case waxingCrescent = "Premier croissant"
    case firstQuarter   = "Premier quartier"
    case waxingGibbous  = "Gibbeuse croissante"
    case fullMoon       = "Pleine lune"
    case waningGibbous  = "Gibbeuse décroissante"
    case lastQuarter    = "Dernier quartier"
    case waningCrescent = "Dernier croissant"
    case error          = "Erreur lors du calcul de la phase lunaire"
    
    static func fromDegree(_ ageOfTheMoonInDegrees: Double) -> MoonPhase {
        // Normalize angle to 0..<360 just in case
        let degree = ageOfTheMoonInDegrees.truncatingRemainder(dividingBy: 360)
        let normalized = degree < 0 ? degree + 360 : degree

        // Use ranges of +/- 6 degrees to capture the "day" of the phase
        // Moon moves ~12-13 degrees per day.
        switch normalized {
        case 0..<6, 354..<360:
            return .newMoon
        case 6..<84:
            return .waxingCrescent
        case 84..<96:
            return .firstQuarter
        case 96..<174:
            return .waxingGibbous
        case 174..<186:
            return .fullMoon
        case 186..<264:
            return .waningGibbous
        case 264..<276:
            return .lastQuarter
        case 276..<354:
            return .waningCrescent
        default:
            return .error
        }
    }
}
