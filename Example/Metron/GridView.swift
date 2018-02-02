//
//  GridView.swift
//  Metron
//
//  Copyright © 2017 Toine Heuvelmans. All rights reserved.
//  
//  NOTE: This GridView is only for demonstration purposes, 
//  and is not at all optimised in any way. Feel free to use
//  it in your code, but don't expect too much of it.
//

import UIKit
import Metron

class GridView : UIView {
    
    weak var drawableSource: DrawableSource?
    
    var displayCenter: CGPoint = .zero
    var scale: CGFloat = 1.0 / 15.0
    
    var gridColor: UIColor = UIColor(white: 1.0, alpha: 0.5)
    
    
    ///  The effective grid frame that is displayed
    var displayFrame: CGRect {
        let displaySize = scale * frame.size
        let halfSize = 0.5 * displaySize
        let displayOrigin = CGPoint(x: -halfSize.width + displayCenter.x,
                                    y: -halfSize.height + displayCenter.y)
        return CGRect(origin: displayOrigin, size: displaySize)
    }
    
    ///  Converts a point in screen coordinates to a point on the grid
    func convert(_ point: CGPoint) -> CGPoint {
        let dpf = displayFrame
        return CGPoint(x: dpf.minX + (point.x * scale), y: dpf.minY + ((frame.size.height - point.y) * scale))
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(updateTranslation(_:)))
        pan.maximumNumberOfTouches = 1
        pan.delegate = self
        addGestureRecognizer(pan)
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(updateScale(_:)))
        pinch.delegate = self
        addGestureRecognizer(pinch)
        backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.2588235294, blue: 0.5764705882, alpha: 1)
    }
    
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.saveGState()
        
        ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: frame.height))
        
        let displayFrame = self.displayFrame
        
        ctx.scaleBy(x: 1.0 / scale, y: 1.0 / scale)
        ctx.translateBy(x: -displayFrame.origin.x, y: -displayFrame.origin.y)
        
        ctx.setLineWidth(2.0 * scale)
        ctx.move(to: CGPoint(x: displayFrame.minX, y: 0.0))
        ctx.addLine(to: CGPoint(x: displayFrame.maxX, y: 0.0))
    
        ctx.move(to: CGPoint(x: 0.0, y: displayFrame.minY))
        ctx.addLine(to: CGPoint(x: 0.0, y: displayFrame.maxY))
    
        ctx.setStrokeColor(gridColor.withAlphaComponent(0.3).cgColor)
        ctx.drawPath(using: .stroke)
        
        let lineWidth = 1.0 * scale
        ctx.setLineWidth(lineWidth)
        ctx.saveGState()
        ctx.setLineDash(phase: lineWidth, lengths: [lineWidth, lineWidth])
        
        let s = pow(10.0, ceil(log10(scale)) + 1)
        
        let minX = floor(displayFrame.minX / s) * s
        let maxX = ceil(displayFrame.maxX / s) * s
        for x in stride(from: minX, to: maxX, by: s) {
            ctx.move(to: CGPoint(x: CGFloat(x), y: displayFrame.minY))
            ctx.addLine(to: CGPoint(x: CGFloat(x), y: displayFrame.maxY))
        }
        
        let minY = floor(displayFrame.minY / s) * s
        let maxY = ceil(displayFrame.maxY / s) * s
        for y in stride(from: minY, to: maxY, by: s) {
            ctx.move(to: CGPoint(x: displayFrame.minX, y: CGFloat(y)))
            ctx.addLine(to: CGPoint(x: displayFrame.maxX, y: CGFloat(y)))
        }
        
        ctx.drawPath(using: .stroke)
        ctx.restoreGState()
        
//        ctx.saveGState()
//        ctx.setLineWidth(lineWidth)
//        ctx.setLineDash(phase: 0, lengths: [2.0 * lineWidth, 2.0 * lineWidth])
//        
//        let subGridStrength = (0.9 - ((10 * scale) / s)) * 0.3
//        
//        for x in stride(from: minX, to: maxX, by: s / 10.0) {
//            ctx.move(to: CGPoint(x: CGFloat(x), y: displayFrame.minY))
//            ctx.addLine(to: CGPoint(x: CGFloat(x), y: displayFrame.maxY))
//        }
//        for y in stride(from: minY, to: maxY, by: s / 10.0) {
//            ctx.move(to: CGPoint(x: displayFrame.minX, y: CGFloat(y)))
//            ctx.addLine(to: CGPoint(x: displayFrame.maxX, y: CGFloat(y)))
//        }
//        
//        ctx.setStrokeColor(gridColor.withAlphaComponent(subGridStrength * subGridStrength).cgColor)
//        
//        ctx.drawPath(using: .stroke)
//        ctx.restoreGState()
        
        let hasSelectedDrawable = drawableSource?.drawables.first { $0.selected } != nil
        
        if hasSelectedDrawable {
            //  fill
            ctx.saveGState()
            drawableSource?.drawables.flatMap { $0.selected ? $0.shape.path : nil }.forEach { ctx.addPath($0) }
            ctx.clip()
            
            let shift = s
            for y in stride(from: minY, to: maxY, by: s / 10.0) {
                ctx.move(to: CGPoint(x: displayFrame.minX, y: CGFloat(y) - shift))
                ctx.addLine(to: CGPoint(x: displayFrame.maxX, y: CGFloat(y) + shift))
            }
            
            ctx.setLineWidth(1.0 * lineWidth)
            ctx.setStrokeColor(gridColor.withAlphaComponent(0.5).cgColor)
            ctx.drawPath(using: .stroke)
            
            ctx.restoreGState()
        }
        
        //  lines
        ctx.saveGState()
        drawableSource?.drawables.flatMap { $0.shape.path }.forEach { ctx.addPath($0) }
        ctx.setLineWidth(3.0 * lineWidth)
        ctx.setStrokeColor(gridColor.withAlphaComponent(1.0).cgColor)
        ctx.drawPath(using: .stroke)
        ctx.restoreGState()
        
        ctx.restoreGState()
    }
    
    // MARK: - Pan / Pinch
    
    @objc func updateTranslation(_ panGestureRecognizer: UIPanGestureRecognizer) {
        switch panGestureRecognizer.state {
        case .changed:
            if isUserInteractionEnabled {
                let t = panGestureRecognizer.translation(in: self)
                displayCenter = displayCenter - (scale * CGVector(dx: t.x, dy: -t.y))
                panGestureRecognizer.setTranslation(.zero, in: self)
                setNeedsDisplay()
            }
        default: break
        }
    }
 
    @objc func updateScale(_ pinchGestureRecognizer: UIPinchGestureRecognizer) {
        switch pinchGestureRecognizer.state {
        case .changed:
            if isUserInteractionEnabled {
                guard pinchGestureRecognizer.numberOfTouches > 1 else { return }
                let touch1 = pinchGestureRecognizer.location(ofTouch: 0, in: self)
                let touch2 = pinchGestureRecognizer.location(ofTouch: 1, in: self)
                let focus = touch1 + (0.5 * (touch2 - touch1))
                let offset = (focus - center) * scale
                let shiftedOffset = offset / pinchGestureRecognizer.scale
                var dif = shiftedOffset - offset
                dif.dy = -dif.dy
                displayCenter = (displayCenter - dif)
                
                scale = scale / pinchGestureRecognizer.scale
                pinchGestureRecognizer.scale = 1.0
                setNeedsDisplay()
            }
        default: break
        }
    }
}

extension GridView : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizers = gestureRecognizers else { return false }
        return gestureRecognizers.contains(otherGestureRecognizer)
    }
}
