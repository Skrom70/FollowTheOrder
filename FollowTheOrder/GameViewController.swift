//
//  GameViewController.swift
//  FollowTheOrder
//
//  Created by Viacheslav Tolstopianteko on 23.08.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, Router, FinishViewControllerDelegate {
	
	var finishViewController: FinishViewController!
	var gamescene: GameScene!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		finishViewController = storyboard?.instantiateViewController(withIdentifier: "FinishViewController") as? FinishViewController
		finishViewController.delegate = self
		
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
				scene.scaleMode = .aspectFit
				
				gamescene = scene as! GameScene
				gamescene.routeDelegate = self
                
                // Present the scene
                view.presentScene(scene)
				
				self.view.backgroundColor = scene.view?.backgroundColor
            }
		
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
		
		
    }
	
	func showGameOverView() {
		addChild(finishViewController)
		view.addSubview(finishViewController.view)
		finishViewController.mode = .gameover
		finishViewController.view.frame =  view.bounds
		finishViewController.view.alpha = 0
		UIView.animate(withDuration: 0.6, animations: { [weak self] in
			guard let `self` = self else {return}
			self.finishViewController.view.alpha = 1
		}, completion: { _ in
			self.gamescene.view?.isUserInteractionEnabled = true
		})
	}
	
	func showSuccesView() {
		addChild(finishViewController)
		view.addSubview(finishViewController.view)
		finishViewController.mode = .success
		finishViewController.view.frame =  view.bounds
		finishViewController.view.alpha = 0
		UIView.animate(withDuration: 0.4, animations: { [weak self] in
			guard let `self` = self else {return}
			self.finishViewController.view.alpha = 1
		}, completion: { _ in
			self.gamescene.view?.isUserInteractionEnabled = true
		})
	}
	
	func finishViewControllerHide(vc: FinishViewController, with mode: FinishMode) {
		vc.willMove(toParent: nil)
		vc.removeFromParent()
		vc.view.alpha =  1
		
		UIView.animate(withDuration: 1.5,  animations: {
			vc.view.alpha = 0
		}) { [weak self] (completed)  in
			guard let `self` = self else {return}
			vc.view.removeFromSuperview()
			mode == .gameover ? self.gamescene.gameOver() : self.gamescene.nextLevel()
		}
	}

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
