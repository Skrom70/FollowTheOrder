//
//  ShapePointGenerator.swift
//  FollowTheOrder
//
//  Created by Viacheslav Tolstopianteko on 25.08.2022.
//

import Foundation
import SpriteKit

class ShapePointGenerator {
	
	let minX: CGFloat
	let maxX: CGFloat
	let minY: CGFloat
	let maxY: CGFloat
	
	init(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
		self.minX = minX
		self.maxX = maxX
		self.minY = minY
		self.maxY = maxY
	}
	
	func generatePoints(count: Int, size: CGSize) -> [CGPoint]? {
		var frames: [CGRect] = []
		
		var counter = 0
		while frames.count < count {
			let randomX = CGFloat.random(in: minX..<maxX)
			let randomY = CGFloat.random(in: minY..<maxY)
			let testСircleFrame = CGRect(origin: CGPoint(x: randomX, y: randomY), size: size)
			
			var isIntersected = false
			
			for frame in frames {
				if frame.intersects(testСircleFrame) {
					isIntersected = true
					break
				}
			}
			
			if !isIntersected {
				frames.append(testСircleFrame)
			}
			
			counter += 1
			if counter > 999999 {
				break
			}
		}
		
		guard frames.count == count else {return nil}
		
		return frames.map({$0.origin})
	}
}
