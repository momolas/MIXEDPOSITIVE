import Foundation

struct GardeningLogic {
    static func getGardeningDay(phase: MoonPhase, sign: ZodiacSign) -> String {
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
}
