//
//  GameController.swift
//  TicTacToe
//
//  Created by Роман Васильев on 10.05.2023.
//

import UIKit

class GameController: UIViewController {
    
    lazy var board: GameBoard = {
       let view = GameBoard()
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        view.addSubview(board)
        board.frame = CGRect(x: 30, y: 150, width: 400, height: 400)
    }
    
}

extension GameController: GameBoardDelegate {
    func presentMessage(_ message: String) {
            let alertController = UIAlertController(title: "Игра окончена", message: message, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Начать заново", style: .default) { [self] (_) in
                board.resetBoard()
            }
            alertController.addAction(restartAction)
            present(alertController, animated: true, completion: nil)
        }

}

