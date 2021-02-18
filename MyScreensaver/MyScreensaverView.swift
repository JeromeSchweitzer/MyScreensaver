//
//  MyScreensaverView.swift
//  MyScreensaver
//
//  Created by Jerome Schweitzer on 2/17/21.
//
//  Created with the help of the Trevor Phillips's
//  "How to Make a Custom Screensaver for Mac OS X"
//  article.
//

import ScreenSaver

class MyScreensaverView: ScreenSaverView {
    
    // Global variables
    private var ballPosition: CGPoint = .zero
    private var ballVelocity: CGVector = .zero
    private let ballRadius: CGFloat = 15
    private var ballYAccel: CGFloat = -2.0
    private var normalDamping: CGFloat = 0.7
    private var alternateDamping: CGFloat = 0.9
    private var minVeloMargin: CGFloat = 1
//    private var backgroundColor: NSColor = NSColor(red: 227.0, green: 83.0, blue: 73.0, alpha: 1.0)
    private var backgroundColor: NSColor = .orange
    private var balls: Array<CGPoint> = []
    private var iterations: Int = 0
    

    // MARK: - Initialization
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        initializeBall()
    }
    
    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Update the state of the screensaver
    override func animateOneFrame() {
        super.animateOneFrame()
        
        ballPosition.x += ballVelocity.dx
        ballPosition.y += ballVelocity.dy
        
        let OOB = isBallOOB()
        if OOB.xOOB {
            ballVelocity.dx *= -1 * normalDamping
            ballVelocity.dy *= alternateDamping
            ballPosition.x = (ballPosition.x - ballRadius <= 0) ? ballRadius : bounds.width - ballRadius
        }
        if OOB.yOOB {
            ballVelocity.dy *= -1 * normalDamping
            ballVelocity.dx *= alternateDamping
            ballPosition.y = (ballPosition.y - ballRadius <= 0) ? ballRadius : bounds.height - ballRadius
            normalDamping -= 0.1    // Decrement the damping force, I guess?
            alternateDamping -= 0.01
            // normalDamping -= (normalDamping * (bounds.height / 2)) / 10  // Alternative decrement
        } else {
            ballVelocity.dy += ballYAccel
        }
        
        if ballVelocity.dy.magnitude <= 0.1 && ballVelocity.dx.magnitude <= 0.1 {
//            backgroundColor = backgroundColor == .red ? .white : .red
            initializeBall()
        }
        
        let tempPoint = CGPoint(x: ballPosition.x, y: ballPosition.y)
        balls.append(_: tempPoint)
        
        setNeedsDisplay(bounds)
    }
    
    // MARK: - Lifecycle
    // Draw a single frame
    override func draw(_ rect: NSRect) {
        drawBackground(backgroundColor)
        drawBalls()
    }
    
    private func drawBackground(_ color: NSColor) {
        let background = NSBezierPath(rect: bounds)
        color.setFill()
        background.fill()
    }
    
    private func drawBalls() {
        for ball in balls {
            let ballRect = NSRect(x: ball.x - ballRadius,
                                  y: ball.y - ballRadius,
                                  width: ballRadius * 2,
                                  height: ballRadius * 2)
            let ball = NSBezierPath(roundedRect: ballRect,
                                    xRadius: ballRadius,
                                    yRadius: ballRadius)
            NSColor.black.setFill()
            
            ball.fill()
        }
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
    
    private func initializeBall() {
        iterations += 1
        ballPosition = CGPoint(x: frame.width/2, y: frame.height/2)
        ballVelocity = CGVector(dx: Double.random(in: -20.0...20.0), dy: Double.random(in: 30.0...40.0))
        normalDamping = 0.7
        alternateDamping = 0.9
        if iterations >= 6 {
            balls = []
            iterations = 1
        }
    }
    
    // Is the ball out of bounds in the x or y-axis
    private func isBallOOB() -> (xOOB: Bool, yOOB: Bool) {
        let xOOB = ballPosition.x - ballRadius <= 0 ||
            ballPosition.x + ballRadius >= bounds.width
        let yOOB = ballPosition.y - ballRadius <= 0 ||
            ballPosition.y + ballRadius >= bounds.height
        
        return (xOOB, yOOB)
    }

}
