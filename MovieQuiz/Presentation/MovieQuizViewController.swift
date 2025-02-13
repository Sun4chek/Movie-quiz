import UIKit


final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    @IBOutlet weak var activitytIndicator: UIActivityIndicatorView!
    
    private var presenter = MovieQuizPresenter()
    private var questionFactory : QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private var correctAnswers = 0
    private var statisticService: StatisticServiceProtocol = StatisticService()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticService()
        self.alertPresenter.setDelegateView(self)
        showLoadingIndicator()
        questionFactory?.loadData()
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
    private func showLoadingIndicator() {
        activitytIndicator.isHidden = false
        activitytIndicator.startAnimating() // включаем анимацию
    }
    
    private func showNetworkError(message: String) {
        
        activitytIndicator.isHidden = true// скрываем индикатор загрузки
        let model = AlertModel(title: "Ошибка", message: message,buttonText: "Попробовать еще раз"){ [weak self] in
            guard let self = self else {return}
            self.questionFactory?.requestNextQuestion()
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
        }
        alertPresenter.showAlert(model: model)
        // создайте и покажите алерт
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: 10)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            let formattedDate = dateFormatter.string(from: (statisticService.bestGame.date))
            
            
            let text = "Ваш результат \(correctAnswers)/10 \n количество сыгранных квизов:\(statisticService.gamesCount) \n Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(formattedDate))\n\(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: text,
                                        buttonText: "Сыграть ещё раз") { [weak self] in
                    guard let self else { return }
                    self.presenter.resetQuestionIndex()
                    self.correctAnswers = 0
                    self.imageView.layer.borderColor = UIColor.clear.cgColor
                    questionFactory?.requestNextQuestion()
            }
            alertPresenter.showAlert(model: alertModel)
        } else {
            imageView.layer.borderColor = UIColor.clear.cgColor
            presenter.switchToNextQuestion()
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
        let viewModel = presenter.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    func didLoadDataFromServer() {
        activitytIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
}
