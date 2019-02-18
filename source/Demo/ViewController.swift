//
//  ViewController.swift
//  Metron
//
//  Copyright © 2017 Toine Heuvelmans. All rights reserved.
//

import UIKit
import Metron

class ViewController: UIViewController {

    // MARK:- Grid
    /**
     * This ViewController's view is a GridView, which shows a grid that can be panned and zoomed.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.displayCenter = CGPoint(x: 5, y: 5)
        gridView.drawableSource = self
        gridView.setNeedsDisplay()

        view.addGestureRecognizer(pinchGestureRecognizer)
    }

    var gridView: GridView {
        return view as! GridView
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK:- Rects
    /**
     * This example shows a simple Pythagorean theorem.
     */

    enum RectID {
        case a, b, c
    }

    /// Using a pinch gesture, you can select and resize a single rect
    var selectedRect: RectID? = nil {
        didSet {
            gridView.isUserInteractionEnabled = selectedRect == nil
        }
    }
    var originalSize: CGFloat = 0.0

    /// These are the effective edge lengths of each rect:
    var sizeA: CGFloat = 4.0
    var sizeB: CGFloat = 3.0
    var sizeC: CGFloat {
        return sqrt(sizeA * sizeA + sizeB * sizeB)
    }

    /// Rect A and B are the bottom two rects.
    var rectA: CGRect {
        return CGRect(origin: .zero, edges: sizeA)
    }

    var rectB: CGRect {
        return CGRect(origin: CGPoint(x: sizeA, y: sizeA), edges: sizeB)
    }

    /// Rect C is the rect along the hypothenuse. Because it is rotated, it is expressed as a poloygon of 4 points.
    var rectC: Polygon {
        //  We need to rotate rectC:
        let angle: Angle = atan(sizeB / sizeA)
        let transform = CGAffineTransform(rotationAngle: angle)
        let lineSegments = CGRect(origin: originC, edges: sizeC).lineSegments.map {
            LineSegment(a: $0.a.applying(transform, anchorPoint: originC),
                b: $0.b.applying(transform, anchorPoint: originC))
        }
        return Polygon(lineSegments: lineSegments)!
    }

    /// Both CGRects and Polygons are PolygonTypes. Each PolygonType is also a Shape. This can be used to determine if a point is inside the shape or not.
    func polygon(for rectID: RectID) -> PolygonType {
        switch rectID {
        case .a: return rectA
        case .b: return rectB
        case .c: return rectC
        }
    }

    func size(for rectID: RectID) -> CGFloat {
        switch rectID {
        case .a: return sizeA
        case .b: return sizeB
        case .c: return sizeC
        }
    }

    func setSize(size: CGFloat, for rectID: RectID) {
        switch rectID {
        case .a: sizeA = size
        case .b: sizeB = size
        case .c:
            let angle: Angle = atan(sizeB / sizeA)
            sizeA = cos(angle) * size
            sizeB = sin(angle) * size
        }
    }

    /// The minXmaxY corner of rect A is the origin (minXminY) of rect C.
    var originC: CGPoint {
        return rectA.corner(.minXmaxY)
    }

    // MARK: Pinch Gesture Recognizer

    private lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let pgr = UIPinchGestureRecognizer(target: self, action: #selector(updatePinch(_:)))
        pgr.delegate = self
        return pgr
    }()

    @objc func updatePinch(_ pinchGestureRecognizer: UIPinchGestureRecognizer) {
        switch pinchGestureRecognizer.state {
        case .began:
            let center = pinchGestureRecognizer.location(in: view)
            let convertedCenter = gridView.convert(center)
            selectedRect = [RectID.a, RectID.b, RectID.c].first { polygon(for: $0).contains(convertedCenter) }

            if let selectedRect = selectedRect {
                originalSize = size(for: selectedRect)
            }
        case .changed:
            //  we update the size of the selected rect here:
            if let selectedRect = selectedRect {
                setSize(size: originalSize * pinchGestureRecognizer.scale, for: selectedRect)
            }
        case .ended, .cancelled:
            selectedRect = nil
            originalSize = 0.0
        default: break
        }

        view.setNeedsDisplay()
    }
}

extension ViewController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pinchGestureRecognizer = gestureRecognizer as? UIPinchGestureRecognizer {
            let center = pinchGestureRecognizer.location(in: view)
            let convertedCenter = gridView.convert(center)
            return [RectID.a, RectID.b, RectID.c].first { polygon(for: $0).contains(convertedCenter) } != nil
        }
        return false
    }
}

extension ViewController: DrawableSource {
    var drawables: [Drawable] {
        return [Drawable(shape: rectA, selected: selectedRect == .a),
                Drawable(shape: rectB, selected: selectedRect == .b),
                Drawable(shape: rectC, selected: selectedRect == .c)]
    }
}
