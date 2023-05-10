//
//  GameBoard.swift
//  TicTacToe
//
//  Created by Роман Васильев on 10.05.2023.
//

import UIKit

protocol GameBoardDelegate: AnyObject {
    func presentMessage(_ text: String)
}

class GameBoard: UIView {
    private var buttons: [[UIButton]] = []
    private var currentPlayer: Player = .x
    var delegate: GameBoardDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGameBoard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGameBoard()
    }
    private func setupGameBoard() {
        let buttonSize: CGFloat = 100
        let spacing: CGFloat = 10

        for row in buttons {
            for button in row {
                button.removeFromSuperview()
            }
        }
        
        buttons.removeAll()

        for row in 0..<3 {
            var buttonRow: [UIButton] = []
            
            for col in 0..<3 {
                let button = UIButton(type: .system)
                button.frame = CGRect(x: CGFloat(col) * (buttonSize + spacing),
                                      y: CGFloat(row) * (buttonSize + spacing),
                                      width: buttonSize,
                                      height: buttonSize)
                customizeButton(button)
                button.tag = row * 3 + col
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

                addSubview(button)
                buttonRow.append(button)
            }

            buttons.append(buttonRow)
        }
    }
    
    private func customizeButton(_ button: UIButton) {
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        
    }
    
    
    @objc private func buttonTapped(_ sender: UIButton) {
          let row = sender.tag / 3
          let col = sender.tag % 3
          
          guard sender.titleLabel?.text?.isEmpty ?? true else { return }
          sender.setTitle(currentPlayer.rawValue, for: .normal)
          
          if checkForWinner() {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                  delegate?.presentMessage(("Победил игрок \(currentPlayer.rawValue)"))
                  resetBoard()
              }

              
          } else if isBoardFull() {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                  delegate?.presentMessage(("Победил игрок \(currentPlayer.rawValue)"))
                  resetBoard()
              }
              
          } else {  currentPlayer = (currentPlayer == .x) ? .o : .x }
      }
    
    private func checkForWinner() -> Bool {
        let board = buttons.map { $0.map { $0.titleLabel?.text ?? "" } }
        
        for row in 0..<3 {
            if board[row][0] == board[row][1] && board[row][0] == board[row][2] && !board[row][0].isEmpty {
                return true
            }
        }
        
        for col in 0..<3 {
            if board[0][col] == board[1][col] && board[0][col] == board[2][col] && !board[0][col].isEmpty {
                return true
            }
        }
        
        if (board[0][0] == board[1][1] && board[0][0] == board[2][2] && !board[0][0].isEmpty) ||
           (board[0][2] == board[1][1] && board[0][2] == board[2][0] && !board[0][2].isEmpty) {
            return true
        }
        
        return false
    }
    
    private func isBoardFull() -> Bool {
          for row in buttons {
              for button in row {
                  if button.titleLabel?.text?.isEmpty ?? true {
                      return false
                  }
              }
          }
          return true
      }
    
    
    func resetBoard() {
        for row in buttons {
            for button in row {
                button.setTitle("", for: .normal)
            }
        }
        currentPlayer = .x
        setupGameBoard()
    }


  }
    


