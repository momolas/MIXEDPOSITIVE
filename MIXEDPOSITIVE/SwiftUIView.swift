//
//  SwiftUIView.swift
//  MIXEDPOSITIVE
//
//  Created by Mo on 03/04/2023.
//

import SwiftUI
import SwiftAA

struct ContentView: View {
    
    @State var moonPhase = ""
    @State var element: String = ""
    
    let date = Date() // Récupère la date actuelle
    let calendar = Calendar.current // Récupère le calendrier actuel
	let jd = JulianDay(Date())
	let moon = Moon(julianDay: JulianDay(Date()))
	let paris = GeographicCoordinates(positivelyWestwardLongitude: Degree(45.18612), latitude: Degree(5.70556))
	
    var body: some View {
        VStack {
            Group {
                Text("Phase de la lune")
                    .font(.largeTitle)
                Text(moonPhase)
                Text("\(moon.illuminatedFraction()*100)%")
                
                Text("Tendance")
                    .font(.largeTitle)
                Text("\(getMoonTrend(julianDay: jd))")
                
                Text("Trajectoire")
                    .font(.largeTitle)
                Text("\(getMoonDirection(julianDay: jd))")
            }
            Group {
                Text("Nœud ascendant")
                    .font(.largeTitle)
                Text("\(getDateString(moon.passageThroughAscendingNode()))")
                
                Text("Nœud descendant")
                    .font(.largeTitle)
                Text("\(getDateString(moon.passageThroughDescendingNode()))")
                
                Text("Signe astrologique")
                    .font(.largeTitle)
                Text("\(getMoonSign(JulianDay: jd).rawValue)")
                
                Text("Jardinage")
                    .font(.largeTitle)
                Text("\(element)")
            }
        }
        .onAppear {
            moonPhase = getMoonPhase(julianDay: jd).rawValue
            element = getGardeningDay(phase: getMoonPhase(julianDay: jd), sign: getMoonSign(JulianDay: jd))
        }
    }
    
    func getMoonPhase(julianDay: JulianDay) -> MoonPhase {
        // Calcul de l'angle de phase de la lune à partir de la date julienne
        let moonPhaseAngle = moon.phaseAngle()
        
        let moonPhase = MoonPhase.fromDegree(moonPhaseAngle.value)
        return moonPhase
    }
    
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
    
    func getMoonDirection(julianDay: JulianDay) -> String {
        let ascendingNode = moon.passageThroughAscendingNode()
        if jd < ascendingNode {
            return "Descendante"
        } else {
            return "Montante"
        }
    }
    
    func getMoonTrend(julianDay: JulianDay) -> String {
        let currentDate = Date()
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        
        let currentPhase = moon.illuminatedFraction()
        let previousMoon = Moon(julianDay: JulianDay(previousMonth))
        let previousPhase = previousMoon.illuminatedFraction()
        
        if currentPhase > previousPhase {
            return "Croissante"
        } else {
            return "Décroissante"
        }
    }
    
    func getDateString(_ julianDay: JulianDay) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .long
        let date = julianDay.date
        return dateFormatter.string(from: date)
    }
    
    func getElementForDay(_ day: Int) -> String {
        let result = (day - 1) % 4
        switch result {
        case 0:
            return "racine"
        case 1:
            return "fleur"
        case 2:
            return "feuille"
        case 3:
            return "fruit"
        default:
            return "rien"
        }
    }
    
    func getGardeningDay(phase: MoonPhase, sign: ZodiacSign) -> String {
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
    
    func getMoonSign(JulianDay: JulianDay) -> ZodiacSign {
        let apparentCoordinates = moon.apparentEclipticCoordinates
        let longitude = apparentCoordinates.celestialLongitude
        let sign = ZodiacSign.fromDegree(longitude.value)
        return sign
    }
    
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
}

#Preview {
	ContentView()
		.environment(\.locale, Locale(identifier: "fr"))
		.preferredColorScheme(.dark)
}
