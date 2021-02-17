//
//  MyScreensaverView.swift
//  MyScreensaver
//
//  Created by Jerome Schweitzer on 2/17/21.
//

import ScreenSaver

class MyScreensaverView: ScreenSaverView {
    
    private var ballPosition: CGPoint = .zero
    private var ballVelocity: CGVector = .zero
    private let ballRadius: CGFloat = 15

    // MARK: - Initialization
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        ballPosition = CGPoint(x: frame.width/2, y: frame.height/2)
        ballVelocity = getInitialVelocity()
    }
    
    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getInitialVelocity() -> CGVector {
        return CGVector(dx: 7.5, dy: 7.5)
    }
    
    private func isBallOOB() -> (xOOB: Bool, yOOB: Bool) {
        //  Is the ball out of bounds in x-axis or y-axis
        
        let xOOB = ballPosition.x - ballRadius <= 0 ||
            ballPosition.x + ballRadius >= bounds.width
        let yOOB = ballPosition.y - ballRadius <= 0 ||
            ballPosition.y + ballRadius >= bounds.height
        return (xOOB, yOOB)
    }

    // MARK: - Lifecycle
    override func draw(_ rect: NSRect) {
        // Draw a single frame in this function
        drawBackground(.white)
        drawBall()
    }
    
    private func drawBackground(_ color: NSColor) {
        let background = NSBezierPath(rect: bounds)
        color.setFill()
        background.fill()
    }
    
    private func drawBall() {
        let ballRect = NSRect(x: ballPosition.x - ballRadius,
                              y: ballPosition.y - ballRadius,
                              width: ballRadius * 2,
                              height: ballRadius * 2)
        let ball = NSBezierPath(roundedRect: ballRect,
                                xRadius: ballRadius,
                                yRadius: ballRadius)
        NSColor.black.setFill()
        ball.fill()
    }

    override func animateOneFrame() {
        super.animateOneFrame()
        // Update the "state" of the screensaver in this function
        
        let OOB = isBallOOB()
        if OOB.xOOB {
            ballVelocity.dx *= -1
        }
        if OOB.yOOB {
            ballVelocity.dy *= -1
        }
        
        ballPosition.x += ballVelocity.dx
        ballPosition.y += ballVelocity.dy
        
        setNeedsDisplay(bounds)
        
    }

}
