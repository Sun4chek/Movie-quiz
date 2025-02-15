//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Волошин Александр on 23.01.2025.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func setDelegateView(_ view: UIViewController)
    func showAlert(model: AlertModel)
}

class AlertPresenter: AlertPresenterDelegate {
    weak var view: UIViewController?
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
            alert.view.accessibilityIdentifier = "Game_results"
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        alert.addAction(action)
        view?.present(alert, animated: true, completion: nil)
    }
    
    func setDelegateView(_ view: UIViewController) {
        self.view = view
    }
}
    
    
    

