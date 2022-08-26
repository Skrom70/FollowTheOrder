//
//  GameScene.swift
//  FollowTheOrder
//
//  Created by Viacheslav Tolstopianteko on 23.08.2022.
//

import SpriteKit
import GameplayKit

protocol Router: AnyObject {
	func showGameOverView()
	func showSuccesView()
}

class GameScene: SKScene {

	private let levelLabelInsets = UIEdgeInsets(top: 58, left: 10, bottom: 10, right: 10)
	private var circleSize: CGFloat!
	private var circleScale: CGFloat!
	
	// Nodes
	private var levelNode: SKLabelNode!
	private var loadingNode: SKLabelNode!
	private var simonCircleNode: SKSpriteNode!
	private var circles: [SKSpriteNode] = []
	
	private var currentSequenceIndex = 0
	private var currentLevel: Int = 1 {
		didSet {
			if currentLevel >= 6 {
				UserDefaults.standard.set(currentLevel, forKey: "current_level")
			}
		}
	}
	
	weak var routeDelegate: Router!
	
	var pointGenerator: ShapePointGenerator!
	
	override func didMove(to view: SKView) {
		currentLevel = (UserDefaults.standard.value(forKey: "current_level") as? Int) ?? 1
		startAnimation { [weak self] in
			guard let `self` = self else {return}
			
			self.circleSize = self.frame.width / 6
			
			let circleAssetImageSize: CGFloat = 96.0 // -_-
			
			self.circleScale = self.circleSize / circleAssetImageSize
			
			self.buildLevelSection()
			
			let minX = self.frame.minX + self.circleSize / 2
			let maxX = self.frame.maxX - self.circleSize / 2
			
			let minY = self.frame.minY + self.circleSize / 2
			let maxY = self.simonCircleNode.frame.minY - self.circleSize / 2 - 16
			
			self.pointGenerator = ShapePointGenerator(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
			
			self.buildCircles()
		}
	}
	
	private func startAnimation(complete: @escaping () -> Void) {
		let startNode = SKLabelNode()
		startNode.fontName = "AvenirNext-Bold"
		startNode.fontSize = 245
		startNode.zPosition = 5
		
		startNode.xScale = 0.0
		startNode.yScale = 0.0
		
		addChild(startNode)
		
		startNode.text = "3"
		
		let scaleTo = SKAction.scale(to: 1.0, duration: 0.5)
		let action1 = SKAction.run {
			startNode.text = "2"
			startNode.xScale = 0.0
			startNode.yScale = 0.0
		}
		let action2 = SKAction.run {
			startNode.text = "1"
			startNode.xScale = 0.0
			startNode.yScale = 0.0
		}
		let action3 = SKAction.run {
			startNode.text = "GO!"
			startNode.xScale = 0.0
			startNode.yScale = 0.0
		}
		
		let deley = SKAction.wait(forDuration: 0.3)
		
		let sequence = SKAction.sequence([scaleTo, deley, action1, scaleTo, deley, action2, scaleTo, deley, action3, scaleTo, SKAction.wait(forDuration: 0.5)])
		
		startNode.run(sequence) { [weak startNode] in
			startNode?.removeFromParent()
			complete()
		}
	}
	
	private func buildLevelSection() {
		// MARK: Level Node

		levelNode = SKLabelNode(text: "\(currentLevel)")
		levelNode.fontSize = 45
		levelNode.fontName = "AvenirNext-Bold"
		levelNode.position = CGPoint(x: 54, y: frame.maxY - levelNode.frame.size.height - levelLabelInsets.top)
		levelNode.fontColor = .white
		levelNode.name = "level"
		
		// MARK: Simon Circle Node
		
		simonCircleNode = SKSpriteNode(imageNamed: "simon-circle")
		simonCircleNode.position = CGPoint(x: levelNode.frame.midX + 3, y: levelNode.frame.midY)
		simonCircleNode.xScale = currentLevel > 9 ? 1.5 : 1.3
		simonCircleNode.yScale = currentLevel > 9 ? 1.5 : 1.3
		simonCircleNode.name = "level"
		
		let levelTitleNode = SKLabelNode(text: "LVL:")
		levelTitleNode.fontSize = 40
		levelTitleNode.fontName = "AvenirNext-Bold"
		levelTitleNode.position = CGPoint(x: levelNode.position.x - (levelTitleNode.frame.width / 2) - (simonCircleNode.frame.size.width / 2) - 20 , y: levelNode.frame.minY)
		levelTitleNode.fontColor = .white
		levelTitleNode.name = "level"
		
		
		addChild(levelNode)
		addChild(simonCircleNode)
		addChild(levelTitleNode)
	}
	
	private func buildCircles() {
		view?.isUserInteractionEnabled = false
		
		// generation circle
		circles = []
		currentSequenceIndex = 0
		let circlesCount = currentLevel + 4
		guard let circlePoints = pointGenerator.generatePoints(count: circlesCount,
															   size: CGSize(width: circleSize, height: circleSize)) else {return}
		
		circles = circlePoints.map({createCircle(with: $0)})
			
		if !circles.isEmpty {
			var sequences: [SKAction] = []
			circles.forEach { circle in
				let circleCreate = SKAction.run { [weak self] in
					guard let `self` = self else {return}
					self.addChild(circle)
					circle.alpha = 0.0
					circle.xScale = 0.0
					circle.yScale = 0.0
					
					let group1 = SKAction.group([SKAction.fadeIn(withDuration: 0.3), SKAction.scale(to: self.circleScale * 1.15, duration: 0.3)])
					let anim1 = SKAction.group([SKAction.wait(forDuration: 0.1)])
					let anim2 = SKAction.group([SKAction.scale(to: self.circleScale * 0.95, duration: 0.18)])
					let anim4 = SKAction.group([SKAction.scale(to: self.circleScale, duration: 0.12)])

					circle.run(SKAction.sequence([group1, anim1, anim2, anim4]), withKey: "fadeInOut")
				}
				let circleSequenceAction  = SKAction.sequence([circleCreate, SKAction.wait(forDuration: 1, withRange: 0.5)])
				sequences.append(circleSequenceAction)
			}
			let sequence = SKAction.sequence(sequences)
			
			self.run(sequence) { [weak self] in
				guard let `self` = self else {return}
				self.view?.isUserInteractionEnabled = true
			}
		}
	}
	
	private func createCircle(with origin: CGPoint, color: CircleButtonColors = .blue) -> SKSpriteNode {
		let circle = SKSpriteNode(imageNamed: "\(color.rawValue)-circle")
		circle.xScale = circleScale
		circle.yScale = circleScale
		circle.position = origin
		circle.name = "circle"
		
		return circle
	}
	
	enum CircleButtonColors: String {
		case blue, green, red
	}
	
	func nextLevel() {
		if (currentLevel < 10) {
			changeCurrentLevel()
			buildCircles()
		} else {
			let finishNode = SKLabelNode(text: "Finish 🏆")
			finishNode.fontName = "AvenirNext-Bold"
			finishNode.fontSize = 55
			addChild(finishNode)
		}
	}

	func gameOver() {
		startAnimation { [weak self] in
			guard let `self` = self else {return}
			self.buildCircles()
			self.buildLevelSection()
		}
	}

	func changeCurrentLevel() {
		self.currentLevel += 1
		
		let groupOut = SKAction.group([SKAction.fadeOut(withDuration: 0.3), SKAction.scale(to: 0.5, duration: 0.3)])
		let groupIn = SKAction.group([SKAction.fadeIn(withDuration: 0.3), SKAction.scale(to: 1, duration: 0.3)])

		let changeValue = SKAction.run { [weak self] in
			guard let `self` = self else {return}
			self.levelNode.text = "\(self.currentLevel)"
		}

		let sequence = SKAction.sequence([groupOut, changeValue, groupIn])
		levelNode.run(sequence)
	}
}

extension GameScene {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let point = touches.first!.location(in: self)
		let size = CGSize(width: 1, height: 1)
		let touchFrame = CGRect(origin: point, size: size)
		
		for i in 0..<circles.count {
			if circles[i].frame.intersects(touchFrame) {
				if i == self.currentSequenceIndex {
					circles[i].texture = SKTexture(imageNamed: "green-circle")
					currentSequenceIndex += 1
					if currentSequenceIndex >= circles.count {
						self.view?.isUserInteractionEnabled = false
						run(SKAction.wait(forDuration: 0.5)) { [weak self] in
							guard let `self` = self else {return}
							self.run(SKAction.wait(forDuration: 0.3)) { [weak self] in
								guard let `self` = self else {return}
								self.enumerateChildNodes(withName: "circle") { circle, stop in
									circle.removeFromParent()
								}
							}
							self.routeDelegate.showSuccesView()
						}
					}
				} else if i > currentSequenceIndex {
					self.view?.isUserInteractionEnabled = false
					let selectedCircle = createCircle(with: CGPoint(x: circles[i].frame.origin.x + circles[i].frame.width / 2,
																	y: circles[i].frame.origin.y + circles[i].frame.height / 2), color: .red)
					circles[i].removeFromParent()
					circles[i] = selectedCircle
					addChild(circles[i])
					
					run(SKAction.wait(forDuration: 0.5)) { [weak self] in
						guard let `self` = self else {return}
						
						self.run(SKAction.wait(forDuration: 0.3)) { [weak self] in
							guard let `self` = self else {return}
							self.enumerateChildNodes(withName: "circle") { circle, stop in
								circle.removeFromParent()
							}
							self.enumerateChildNodes(withName: "level") { circle, stop in
								circle.removeFromParent()
							}
						}
						self.routeDelegate.showGameOverView()
					}
				}
				break
			}
		}
	}
}
