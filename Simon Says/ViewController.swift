//
//  ViewController.swift
//  Simon Says
//
//  Created by Ryan Tallmage on 1/13/18.
//  Copyright © 2018 Ryan Tallmage. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorButtons: [RoundButton]!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet var scoreLabels: [UILabel]!
    @IBOutlet var playerLabels: [UILabel]!
    
    var currentPlayer = 0
    var scores = [0, 0]
    var sequenceIndex = 0
    var colorSequence = [Int]()
    var colorsTap = [Int]()
    
    var gameEnded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorButtons = colorButtons.sorted(by: sortViews)
        scoreLabels = scoreLabels.sorted(by: sortViews)
        playerLabels = playerLabels.sorted(by: sortViews)
        createNewGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded {
            gameEnded = false
            createNewGame()
        }
    }
    
    func createNewGame() {
        colorSequence.removeAll()
        actionButton.setTitle("Start Game", for: .normal)
        actionButton.isEnabled = true
        for button in colorButtons {
            button.alpha = 0.5
            button.isEnabled = false
        }
        
        currentPlayer = 0
        scores = [0, 0]
        playerLabels[currentPlayer].alpha = 1.0
        playerLabels[1].alpha = 0.75
        updateScoreLabels()
    }
    
    func starGame() {
        sequenceIndex = 0
        actionButton.setTitle("Memorize", for: .normal)
        actionButton.isEnabled = false
        view.isUserInteractionEnabled = false
        addNewColor()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.playSequence()
            self.view.isUserInteractionEnabled = true
            self.actionButton.setTitle("Tap The Circles", for: .normal)
            for button in self.colorButtons {
                button.isEnabled = true
            }
        }
    }
    
    func addNewColor() {
        colorSequence.append(Int(arc4random_uniform(UInt32(colorButtons.count))))
    }
    
    func playSequence() {
        if sequenceIndex < colorSequence.count {
            flash(button: colorButtons[colorSequence[sequenceIndex]])
            sequenceIndex += 1
        } else {
            colorsTap = colorSequence
        }
    }
    
    func flash(button: RoundButton) {
        UIView.animate(withDuration: 0.5, animations: {
            button.alpha = 1.0
            button.alpha = 0.5
        }) { (bool) in
            self.playSequence()
        }
    }
    
    func updateScoreLabels()  {
        for (index, label) in scoreLabels.enumerated() {
            label.text = "\(scores[index])"
        }
    }
    
    func switchPlayers() {
        playerLabels[currentPlayer].alpha = 0.75
        currentPlayer = currentPlayer == 0 ? 1 : 0
        playerLabels[currentPlayer].alpha = 1.0
    }
    
    func endGame() {
        let winningPlayer = currentPlayer == 0 ? 2 : 1
        actionButton.setTitle("Player \(winningPlayer) Won!", for: .normal)
        gameEnded = true
    }

    @IBAction func colorButtonPressed(_ sender: RoundButton) {
        if sender.tag == colorsTap.removeFirst() {
            
        } else {
            for button in colorButtons {
                button.isEnabled = false
            }
            endGame()
            return
        }
        
        if colorsTap.isEmpty {
            for button in colorButtons {
                button.isEnabled = false
            }
            scores[currentPlayer] += 1
            updateScoreLabels()
            switchPlayers()
            actionButton.setTitle("Continue", for: .normal)
            actionButton.isEnabled = true
        }
        
    }
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        starGame()
    }
    
    func sortViews(a: UIView, b: UIView) -> Bool {
        return a.tag < b.tag
    }
}

