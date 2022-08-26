//
//  GameOverViewController.swift
//  FollowTheOrder
//
//  Created by Viacheslav Tolstopianteko on 25.08.2022.
//

import UIKit

protocol FinishViewControllerDelegate: AnyObject {
	func finishViewControllerHide(vc: FinishViewController, with mode: FinishMode)
}

class FinishViewController: UIViewController {

	@IBOutlet weak var messageTextView: UITextView!
	@IBOutlet weak var playButton: UIButton!
	
	var mode: FinishMode!
	
	weak var delegate: FinishViewControllerDelegate!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.view.isUserInteractionEnabled = true
		
		messageTextView.text = mode == .gameover ? "Oooooops!" : "Nice!"
		
		if mode == .success {
			FortunaService().getData { [weak self] speach in
				guard let `self` = self, let speach = speach else {
					return
				}
				DispatchQueue.main.async {
					self.messageTextView.text = speach
					self.messageTextView.alpha = 0.0
					UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseInOut) {
						self.messageTextView.alpha = 1.0
					}

				}
			}
		}
		
		playButton.setImage(UIImage(named: mode == .gameover ? "try-again" : "next-level"), for: .normal)
	}


	@IBAction func tryAgain(_ sender: UIButton) {
		delegate.finishViewControllerHide(vc: self, with: self.mode)
	}
}

enum FinishMode {
	case success, gameover
}
