//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Волошин Александр on 28.01.2025.
//
protocol StatisticServiceProtocol {
    var gamesCount : Int { get }
    var bestGame : GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
