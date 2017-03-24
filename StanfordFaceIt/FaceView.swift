//
//  FaceView.swift
//  StanfordFaceIt
//
//  Created by Sinisa Vukovic on 09/10/16.
//  Copyright © 2016 Sinisa Vukovic. All rights reserved.
//

import UIKit
@IBDesignable
class FaceView: UIView {
    @IBInspectable
    var scale:CGFloat = 0.9 {didSet {setNeedsDisplay()}}
    @IBInspectable
    var mouthCurvature: Double = 1.0 {didSet {setNeedsDisplay()}}
    @IBInspectable
    var eyesOpen: Bool = true {didSet {leftEye.eyesOpen = eyesOpen; rightEye.eyesOpen = eyesOpen}}
    @IBInspectable
    var eyeBorwTilt: Double = 0.0 {didSet {setNeedsDisplay()}}
    @IBInspectable
    var color: UIColor = UIColor.blue {didSet {setNeedsDisplay(); leftEye.color = color; rightEye.color = color}}
    @IBInspectable
    var lineWidth: CGFloat = 5.0 {didSet {setNeedsDisplay(); leftEye.lineWidth = lineWidth; rightEye.lineWidth = lineWidth}}
    
    private lazy var leftEye: EyeView = self.createEye()
    private lazy var rightEye: EyeView = self.createEye()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        positionEye(eye: leftEye, center: getEyeCenter(eye: .Left))
        positionEye(eye: rightEye, center: getEyeCenter(eye: .Right))
    }
    
    private func createEye() -> EyeView {
        let eye = EyeView()
        eye.isOpaque = false
        eye.color = color
        eye.lineWidth = lineWidth
        self.addSubview(eye)
        return eye
    }
    
    private func positionEye (eye: EyeView, center: CGPoint) {
        let size = skullRadius / Ratios.SkullRadiusToEyesRadius * 2
        eye.frame = CGRect(origin:CGPoint(x:frame.minX, y:frame.minY) , size: CGSize(width: size, height: size))
        eye.center = center
    }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private var skullRadius:CGFloat{
        return (min(bounds.width, bounds.height) / 2) * scale
    }
    private var skullCenter:CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios {
        static let SkullRadiusToEyesOffset: CGFloat = 3
        static let SkullRadiusToEyesRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 5.0
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        pathForCircleCenteredAtPoint(midPoint: skullCenter, widthRadius: skullRadius).stroke()
//        pathForEye(eye: .Left).stroke()
//        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
        pathForBrow(eye: .Left).stroke()
        pathForBrow(eye: .Right).stroke()
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func getEyeCenter (eye: Eye) -> CGPoint {
        
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyesOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        
        switch eye {
        case .Left: eyeCenter.x += eyeOffset
        case .Right: eyeCenter.x -= eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForCircleCenteredAtPoint (midPoint:CGPoint, widthRadius radius: CGFloat) -> UIBezierPath{
        let path = UIBezierPath(arcCenter: midPoint,
                                radius: radius,
                                startAngle: 0.0,
                                endAngle: CGFloat(2*M_PI),
                                clockwise: false)
        path.lineWidth = self.lineWidth
        return path
    }
    
    private func pathForMouth () -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: (skullCenter.x - mouthWidth / 2), y: (skullCenter.y + mouthOffset), width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = self.lineWidth
        return path
    }
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        var tilt = eyeBorwTilt
        switch eye {
        case .Left: tilt += -1.0
        case .Right: break
        }
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y  -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyesRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) + eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x-eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y - tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = self.lineWidth
        return path
    }
    
    //    private func pathForEye (eye: Eye) -> UIBezierPath{
    //        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyesRadius
    //        let eyeCenter = getEyeCenter(eye: eye)
    //        if eyesOpen {
    //                return pathForCircleCenteredAtPoint(midPoint: eyeCenter, widthRadius: eyeRadius)
    //        }else {
    //                let path = UIBezierPath()
    //                path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
    //                path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
    //                path.lineWidth = self.lineWidth
    //                return path
    //        }
    //    }
}
