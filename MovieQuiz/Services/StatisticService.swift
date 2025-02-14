//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Волошин Александр on 28.01.2025.
//

import Foundation

final class StatisticService:StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correctBestGame
        case totalBestGame
        case dateBestGame
        case gamesCount
        case correct
        case total
    }
    
    var gamesCount: Int {
        get{
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
            
        }
    }
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.correctBestGame.rawValue)
            let total = storage.integer(forKey: Keys.totalBestGame.rawValue)
            
            let date = storage.object(forKey: Keys.dateBestGame.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue, forKey: Keys.correctBestGame.rawValue)
            storage.set(newValue, forKey: Keys.totalBestGame.rawValue)
            storage.set(newValue, forKey: Keys.dateBestGame.rawValue)
        }
    }
    var totalAccuracy: Double {
        if gamesCount > 0 {
            let procent = (Double(correct) / (Double(total))) * 100
            return procent
        } else {
            return 0
        }
    }
    
    var total : Int {
        get {
            storage.integer(forKey: Keys.total.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct : Int {
        get {
            storage.integer(forKey: Keys.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        correct += count
        total += amount
        
        
        let newGameResult = GameResult(correct: count, total: amount, date: Date())
        if newGameResult.isBetterThan(bestGame){
            storage.set(count, forKey: Keys.correctBestGame.rawValue)
            storage.set(amount, forKey: Keys.totalBestGame.rawValue)
            storage.set(Date(), forKey: Keys.dateBestGame.rawValue)
        }
    }
    
}
