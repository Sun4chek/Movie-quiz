//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Волошин Александр on 23.01.2025.
//

struct AlertModel {
    let title: String
    let message: String
    let buttonText:String
    let completion: (() -> Void)?
}
