import UIKit
protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func showGameResults(_ alertModel: AlertModel)
}

final class MovieQuizViewController: UIViewController,MovieQuizViewControllerProtocol{
    
    
    // MARK: - Lifecycle
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activitytIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter = AlertPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        imageView.layer.cornerRadius = 20
        self.alertPresenter.setDelegateView(self)
        showLoadingIndicator()
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func showLoadingIndicator() {
        activitytIndicator.isHidden = false
        activitytIndicator.startAnimating() 
    }
    
    func showNetworkError(message: String) {
        
        activitytIndicator.isHidden = true
        let model = AlertModel(title: "Ошибка", message: message,buttonText: "Попробовать еще раз"){ [weak self] in
            guard let self = self else {return}
            self.presenter.questionFactory?.requestNextQuestion()
            self.presenter.resetGame()
            
        }
        alertPresenter.showAlert(model: model)
        
    }
    
    func showGameResults(_ alertModel: AlertModel) {
        alertPresenter.showAlert(model: alertModel)
        self.imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    
}

