//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Волошин Александр on 23.01.2025.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
