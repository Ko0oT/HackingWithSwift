//
//  ViewController.swift
//  VolchkovTest
//
//  Created by Citylink on 25.01.2025.
//

import UIKit
import Stevia

final class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        scoreLabel = UILabel()
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        
//        scoreLabel.layer.borderWidth = 1
//        scoreLabel.layer.borderColor = UIColor.black.cgColor //потом убрать
        
        cluesLabel = UILabel()
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        
//        cluesLabel.layer.borderWidth = 1
//        cluesLabel.layer.borderColor = UIColor.black.cgColor //потом убрать
        
        answersLabel = UILabel()
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        
//        answersLabel.layer.borderWidth = 1
//        answersLabel.layer.borderColor = UIColor.black.cgColor //потом убрать
        
        currentAnswer = UITextField()
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        
//        currentAnswer.layer.borderWidth = 1
//        currentAnswer.layer.borderColor = UIColor.black.cgColor //потом убрать
        
        let submit = UIButton(type: .system)
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
//        submit.layer.borderWidth = 1
//        submit.layer.borderColor = UIColor.black.cgColor //потом убрать

        let clear = UIButton(type: .system)
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
//        clear.layer.borderWidth = 1
//        clear.layer.borderColor = UIColor.black.cgColor //потом убрать
        
        let buttonsView = UIView()
//        buttonsView.layer.borderWidth = 1
//        buttonsView.layer.borderColor = UIColor.black.cgColor //потом убрать

        view.subviews(scoreLabel, cluesLabel, answersLabel, currentAnswer, submit, clear, buttonsView)
        
        scoreLabel.Top == view.layoutMarginsGuide.Top
        scoreLabel.Trailing == view.layoutMarginsGuide.Trailing
        cluesLabel.Top == scoreLabel.Bottom
        cluesLabel.Leading == view.layoutMarginsGuide.Leading + 100
        cluesLabel.width(40%)
        answersLabel.Top == scoreLabel.Bottom
        answersLabel.Trailing == view.layoutMarginsGuide.Trailing - 100
        answersLabel.width(30%)
        answersLabel.Height == cluesLabel.Height
        currentAnswer.CenterX == view.CenterX
        currentAnswer.width(50%)
        currentAnswer.Top == cluesLabel.Bottom + 20
        
        //Content hugging priority Приоритет обхвата контента определяет, насколько вероятно, что это представление будет сделано больше, чем его собственный размер контента. Если этот приоритет высок, это означает, что Auto Layout предпочитает не растягивать его; если он низок, то он, скорее всего, будет растянут.
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        submit.Top == currentAnswer.Bottom
        submit.CenterX == view.CenterX - 100
        submit.height(44)
        clear.CenterX == view.CenterX + 100
        clear.CenterY == submit.CenterY
        clear.height(44)
        buttonsView.width(750)
        buttonsView.height(320)
        buttonsView.CenterX == view.CenterX
        buttonsView.Top == submit.Bottom + 20
        buttonsView.Bottom == view.layoutMarginsGuide.Bottom - 20
        
        //Нам нужно создать 20 кнопок в четырех строках и пяти столбцах, что является идеальным моментом для использования вложенных циклов: создать и настроить каждую кнопку, затем разместить ее внутри представления кнопок.
        
        //Однако мы положимся на замечательную функцию Auto Layout, которая значительно упростит весь этот процесс: мы не будем устанавливать translatesAutoresizingMaskIntoConstraintsзначение false для этих кнопок, а это значит, что мы можем задать им определенное положение и размер, а UIKit определит ограничения за нас.
        
        let width = 150
        let height = 80

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WWW", for: .normal)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterButton)

                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                letterButton.layer.cornerRadius = 20
                // and also to our letterButtons array
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                letterButtons.append(letterButton)
            }
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()

                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]

                    clueString += "\(index + 1). \(clue)\n"

                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)

                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }

        // Now configure the buttons and labels
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

        letterBits.shuffle()

        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }

        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()

            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")

            currentAnswer.text = ""
            score += 1

            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
    }
    
    private func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        loadLevel()

        for btn in letterButtons {
            btn.isHidden = false
        }
    }

    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""

        for btn in activatedButtons {
            btn.isHidden = false
        }

        activatedButtons.removeAll()
    }
    
}


