import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    private let questionsAmount = 10
    private var questionFactory : QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private var currentQuestionIndex = 0
    private var correctAnswers = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        let questionFactory = QuestionFactory() // 2
        questionFactory.delegate = self         // 3
        self.questionFactory = questionFactory
        self.alertPresenter.setDelegateView(self)
        questionFactory.requestNextQuestion()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber:"\(currentQuestionIndex+1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
   
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: text,
                                        buttonText: "Сыграть ещё раз") { [weak self] in
                    guard let self else { return }
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                    self.imageView.layer.borderColor = UIColor.clear.cgColor
                    questionFactory?.requestNextQuestion()
            }
            alertPresenter.showAlert(model: alertModel) // 3
        } else {
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
}

extension MovieQuizViewController : QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}
