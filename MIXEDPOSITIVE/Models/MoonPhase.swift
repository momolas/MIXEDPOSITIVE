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
        switch ageOfTheMoonInDegrees {
        case 0:
            return .fullMoon
        case 1..<45:
            return .waningGibbous
        case 45:
            return .firstQuarter
        case 46..<90:
            return .waningGibbous
        case 90:
            return .lastQuarter
        case 91..<135:
            return .waxingGibbous
        case 135:
            return .waningCrescent
        case 136..<180:
            return .waxingGibbous
        case 180:
            return .newMoon
        default:
            return .error
        }
    }
}
