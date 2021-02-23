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
    
    // Constants
    private let MAX_X_SPEED: Double = 20.0
    private let MAX_Y_SPEED: Double = 40.0
    private let MAX_NORMAL_DAMPING: CGFloat = 0.7
    private let MAX_ALTERNATE_DAMPING: CGFloat = 0.9
    private let NORMAL_DAMPING_DEC: CGFloat = 0.1
    private let ALTERNATE_DAMPING_DEC: CGFloat = 0.01
    private let SLOW_SPEED: CGFloat = 0.1
    
    // Global variables
    private let ballRadius: CGFloat = 30.0
    private var ballPosition: CGPoint = .zero
    private var ballVelocity: CGVector = .zero
    private var ballYAccel: CGFloat = -2.0
    
    private var normalDamping: CGFloat = .zero
    private var alternateDamping: CGFloat = .zero
    
//    private let system_colors: Array<NSColor> = [.systemTeal, .systemPink, .systemPurple, .systemIndigo, .systemRed, .systemBlue, .systemGray, .systemGreen, .systemBrown, .systemOrange, .systemYellow]
    
    private var backgroundColor: NSColor = .systemIndigo
    // TODO: Figure out how to use local image
    private let myImg = NSImage(contentsOf: URL(string: "https://i.pinimg.com/originals/9f/cb/f7/9fcbf766603ed3d1e6c2808ee63ff3f3.png")!)
    

    // Initialization
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        initializeBall()
    }
    
    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Animate one frame of the screensaver
    override func animateOneFrame() {
        super.animateOneFrame()
        
        ballPosition.x += ballVelocity.dx
        ballPosition.y += ballVelocity.dy
        
        // Don't let the ball leave the bounds
        let OOB = isBallOOB()
//        if OOB.xOOB || OOB.yOOB {
//            backgroundColor = system_colors.randomElement()!
//        }
        if OOB.xOOB {
            ballVelocity.dx *= -1 * normalDamping
            ballVelocity.dy *= alternateDamping
            ballPosition.x = (ballPosition.x - ballRadius <= 0) ? ballRadius : bounds.width - ballRadius
        }
        if OOB.yOOB {
            ballVelocity.dy *= -1 * normalDamping
            ballVelocity.dx *= alternateDamping
            ballPosition.y = (ballPosition.y - ballRadius <= 0) ? ballRadius : bounds.height - ballRadius
            normalDamping -= NORMAL_DAMPING_DEC    // Decrement the damping force, I guess?
            alternateDamping -= ALTERNATE_DAMPING_DEC
            // normalDamping -= (normalDamping * (bounds.height / 2)) / 10  // Alternative decrement
        } else {
            ballVelocity.dy += ballYAccel
        }
        
        if ballVelocity.dy.magnitude <= SLOW_SPEED && ballVelocity.dx.magnitude <= SLOW_SPEED {
            initializeBall()    // Ball has essentially come to a stop
        }
        
        // Only updating in the current rectangle, not intentional but maybe good?
//        setNeedsDisplay(NSRect(x: ballPosition.x - ballRadius,
//                               y: ballPosition.y - ballRadius,
//                               width: ballRadius * 2,
//                               height: ballRadius * 2))
        // TODO: Figure out how to correctly draw new images on top of old
        // Consider storing list of visited positions, if current position is
        // close to an old position, draw both so as not to paint background over
         setNeedsDisplay(bounds)
    }
    
    // Draw one frame of the screensaver
    override func draw(_ rect: NSRect) {
        drawBackground(backgroundColor)
        drawBall()
    }
    
    // Fill in the screensaver background
    private func drawBackground(_ color: NSColor) {
        let background = NSBezierPath(rect: bounds)
        color.setFill()
        background.fill()
    }
    
    // Draw myImg at ball position
    private func drawBall() {
        let ballRect = NSRect(x: ballPosition.x - ballRadius,
                              y: ballPosition.y - ballRadius,
                              width: ballRadius * 2,
                              height: ballRadius * 2)
        myImg?.draw(in: ballRect)
    }
    
    // Initialize position and velocity of ball, (re)set damping values
    private func initializeBall() {
        ballPosition = CGPoint(x: frame.width/2, y: frame.height/2)
        ballVelocity = CGVector(dx: Double.random(in: -1*MAX_X_SPEED...MAX_X_SPEED), dy: Double.random(in: MAX_Y_SPEED-10...MAX_Y_SPEED))
        normalDamping = MAX_NORMAL_DAMPING
        alternateDamping = MAX_ALTERNATE_DAMPING
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
