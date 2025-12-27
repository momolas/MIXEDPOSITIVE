import Foundation

enum ZodiacSign: String, CaseIterable {
    case aries = "Bélier"
    case taurus = "Taureau"
    case gemini = "Gémeaux"
    case cancer = "Cancer"
    case leo = "Lion"
    case virgo = "Vierge"
    case libra = "Balance"
    case scorpio = "Scorpion"
    case sagittarius = "Sagittaire"
    case capricorn = "Capricorne"
    case aquarius = "Verseau"
    case pisces = "Poissons"
    
    static func fromDegree(_ degree: Double) -> ZodiacSign {
        let adjustedDegree = (degree < 0) ? degree + 360 : degree
        let signNumber = Int(floor(adjustedDegree / 30)) % 12
        return ZodiacSign.allCases[signNumber]
    }
}
