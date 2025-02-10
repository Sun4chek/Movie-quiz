//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Волошин Александр on 23.01.2025.
//

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
