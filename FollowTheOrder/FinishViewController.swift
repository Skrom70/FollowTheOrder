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

	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var playButton: UIButton!
	
	var mode: FinishMode!
	
	weak var delegate: FinishViewControllerDelegate!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//		playButton.imageView?.image = UIImage(named: mode == .gameover ? "try-again" : "next-level")
		
		self.view.isUserInteractionEnabled = true
		
		messageLabel.text = mode == .gameover ? "Oooooops!" : "Nice!"
		
		playButton.setImage(UIImage(named: mode == .gameover ? "try-again" : "next-level"), for: .normal)
		messageLabel.numberOfLines = 0
	}


	@IBAction func tryAgain(_ sender: UIButton) {
		delegate.finishViewControllerHide(vc: self, with: self.mode)
	}
}

enum FinishMode {
	case success, gameover
}
