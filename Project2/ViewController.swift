//
//  ViewController.swift
//  Project2
//
//  Created by Alex Cannizzo on 14/08/2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    // MARK: - Properties
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    var topScore = 0  {
        didSet {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Top Score: \(topScore)")
        }
    }
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        // create border around buttons because some flags have white stripes which makes them invisible
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        // change color of border
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        // create button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(viewScore))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Top Score: \(topScore)", style: .plain, target: self, action: nil)
        
        let defaults = UserDefaults.standard
        topScore = defaults.object(forKey: "TopScore") as? Int ?? 0
        askQuestion()
    }
    
    // MARK: - Methods
    func askQuestion(action: UIAlertAction! = nil) {
        
        // shuffle countries in the array
        countries.shuffle()
        
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        // set the navbar title to be the name of a country
        title = "\(countries[correctAnswer].uppercased())"
        
        // end and reset game after 10 questions answered
        if questionsAsked == 10 {
            let ac = UIAlertController(title: "Game Finished!", message: "Your Final Score Is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: askQuestion))
            present(ac, animated: true)
            score = 0
            questionsAsked = 0
            viewScore()
        }
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
        } else {
            title = "Wrong! That's \(countries[sender.tag].uppercased())"
            score -= 1
        }
        viewScore()
        topScoreKeeper()
        
        // set up alert to tell user if answer is correct and total score
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
        questionsAsked += 1
    }
    
    // view score on button
    @objc func viewScore() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String(score))
    }
    
    func topScoreKeeper() {
        let defaults = UserDefaults.standard
        if score > topScore {
            topScore = score
        }
        defaults.set(topScore, forKey: "TopScore")
    }
    
}

