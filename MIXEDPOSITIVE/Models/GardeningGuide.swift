import Foundation

struct GardeningGuide {
    static func getPlants(for element: String) -> [String] {
        switch element {
        case "Jour racine":
            return ["Carotte", "Radis", "Navet", "Betterave", "Ail", "Oignon", "Pomme de terre"]
        case "Jour feuille":
            return ["Salade", "Épinard", "Chou", "Persil", "Basilic", "Poireau", "Blette"]
        case "Jour fleur":
            return ["Brocoli", "Chou-fleur", "Artichaut", "Fleurs ornementales", "Lavande"]
        case "Jour fruit":
            return ["Tomate", "Concombre", "Courgette", "Aubergine", "Fraise", "Framboise", "Haricot"]
        default:
            return []
        }
    }
}
