import SwiftUI

class LogicaVM: ObservableObject {
    
    // Статус отслеживания срабатывания вибрации при нажатии
    @Published var generator = UISelectionFeedbackGenerator()
    
    // Массивы хранения кошельков для каждой валюты
    @Published var enterMoneyUSD: [Double] {
        didSet {
            UserDefaults.standard.set(enterMoneyUSD, forKey: "enterMoneyUSD")
        }
    }
    
    @Published var enterMoneyEUR: [Double] {
        didSet {
            UserDefaults.standard.set(enterMoneyEUR, forKey: "enterMoneyEUR")
        }
    }
    
    @Published var enterMoneyGEL: [Double] {
        didSet {
            UserDefaults.standard.set(enterMoneyGEL, forKey: "enterMoneyGEL")
        }
    }
    
    @Published var enterMoneyRUB: [Double] {
        didSet {
            UserDefaults.standard.set(enterMoneyRUB, forKey: "enterMoneyRUB")
        }
    }

    // Инициализация массивов
    init() {
        enterMoneyUSD = UserDefaults.standard.array(forKey: "enterMoneyUSD") as? [Double] ?? []
        enterMoneyEUR = UserDefaults.standard.array(forKey: "enterMoneyEUR") as? [Double] ?? []
        enterMoneyGEL = UserDefaults.standard.array(forKey: "enterMoneyGEL") as? [Double] ?? []
        enterMoneyRUB = UserDefaults.standard.array(forKey: "enterMoneyRUB") as? [Double] ?? []
    }
    
    
}

