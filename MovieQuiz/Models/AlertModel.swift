//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Волошин Александр on 23.01.2025.
//

struct AlertModel {
    var title: String
    var message: String
    var buttonText:String
    var completion: (() -> Void)?
}
