//
//  DrawableSource.swift
//  Metron
//
//  Copyright © 2017 Toine Heuvelmans. All rights reserved.
//

import Metron

/**
 *  The GridView requires a DrawableSource to provide drawable shapes.
 *  each drawable might be selected, causing it to be drawn with a fill.
 *  Note that a Metron Shape is a Metron Drawable, but a Drawable can
 *  be a Metron Line Segment, which isn't a Shape.
 */


struct Drawable {
    let shape: Metron.Drawable
    let selected: Bool
}

protocol DrawableSource: class {
    var drawables: [Drawable] { get }
}
