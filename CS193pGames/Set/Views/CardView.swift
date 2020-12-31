//
//  CardView.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 11.12.20.
//

import UIKit
 

class CardView: UIView {
    
    var card: Card!
    //TODO: 1. Make shapeDrawerWithOffsetByY be just shape: UIBezierPath (current problem is with offsets)
    //      2. View shouldn't contain a model object. Make card be a computed, not a stored property (or delegate that task to ViewController). 
    
    var shapeDrawerWithOffsetByY: ((CGFloat) -> UIBezierPath)? {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    var shapeColor:     UIColor!     { didSet { setNeedsDisplay(); setNeedsLayout() }}
    var numberOfShapes: Int!         { didSet { setNeedsDisplay(); setNeedsLayout() }}
    var shading:        ShadingType! { didSet { setNeedsDisplay(); setNeedsLayout() }}
    var isFaceUp = false             { didSet { setNeedsDisplay() }}
    
    enum ShadingType { case fill, crate, clear }
    
    var glowColor: UIColor! {
        didSet {
            isUserInteractionEnabled = [GlowType.selected.color, GlowType.usual.color].contains(glowColor)
            setNeedsDisplay()
        }
    }
    
    
    convenience init(frame: CGRect, card: Card) {
        self.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = true
        
        self.card = card // to be removed (see TODO)
        
        switch card.shape {
        case 0:  shapeDrawerWithOffsetByY = bezierRoundedRectOffsetYBy(_:)
        case 1:  shapeDrawerWithOffsetByY = bezierRhombusOffsetYBy(_:)
        case 2:  shapeDrawerWithOffsetByY = bezierWeirdOffsetYBy(_:)
        default: shapeDrawerWithOffsetByY = nil
        }

        switch card.color {
        case 0:  self.shapeColor = UIColor.appColor(.shapeRed)!
        case 1:  self.shapeColor = UIColor.appColor(.shapeGreen)!
        case 2:  self.shapeColor = UIColor.appColor(.shapeBlue)!
        default: self.shapeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
        
        self.numberOfShapes = card.numberOfShapes + 1
        
        switch card.shading {
        case 0:  self.shading = .fill
        case 1:  self.shading = .crate
        case 2:  self.shading = .clear
        default: self.shading = .none
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        drawBezierBackgroundRoundedRect(at: bounds.zoom(by: SizeRatio.zoomOfCardBackgroundToBounds))
        guard isFaceUp else { return }
        
        shapeColor.setStroke()
        shapeColor.setFill()
        
        let result = UIBezierPath()
        switch numberOfShapes {
        case 1: result.append(shapeDrawerWithOffsetByY!(bounds.midY))
        case 2:
            let offsetToMiddleOfShape = (spacing + shapeHeight) / 2
            result.append(shapeDrawerWithOffsetByY!(bounds.midY - offsetToMiddleOfShape))
            result.append(shapeDrawerWithOffsetByY!(bounds.midY + offsetToMiddleOfShape))
        case 3:
            let offsetToMiddleOfShape = (spacing + shapeHeight)
            result.append(shapeDrawerWithOffsetByY!(bounds.midY - offsetToMiddleOfShape))
            result.append(shapeDrawerWithOffsetByY!(bounds.midY))
            result.append(shapeDrawerWithOffsetByY!(bounds.midY + offsetToMiddleOfShape))
        default: return
        }
        
        result.lineWidth = 3
        result.addClip()
        result.stroke()
        
        switch shading {
        case .fill:     result.fill()
        case .crate:    bezierCrateLines().stroke()
        case .clear:    break
        case .none:     return
        }
    }
}


//MARK:- Drawing shapes
extension CardView {
    
    //MARK: Bezier background
    private func drawBezierBackgroundRoundedRect(at frame: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: frame, cornerRadius: backgroundRectCornerRadius)
        roundedRect.addClip()
        
        (isFaceUp ? UIColor.appColor(.cardFaceUp)! : UIColor.appColor(.cardFaceDown)!).setFill()
        roundedRect.fill()
        
        roundedRect.lineWidth = 4.0
        (isFaceUp ? glowColor : .clear)?.setStroke()
        roundedRect.stroke()
    }
    
    
    //MARK: Bezier shapes
    private func bezierRoundedRectOffsetYBy(_ offsetY: CGFloat) -> UIBezierPath {
        return UIBezierPath(roundedRect: CGRect(x: insetX, y: offsetY - shapeHeight / 2, width: shapeWidth, height: shapeHeight), cornerRadius: roundedRectShapeCornerRadius)
    }
    
    
    private func bezierRhombusOffsetYBy(_ offsetY: CGFloat) -> UIBezierPath {
        let rhombus = UIBezierPath()
        rhombus.move(to: CGPoint(x: insetX, y: offsetY))
        
        rhombus.addLine(to: CGPoint(x: bounds.midX,
                                    y: offsetY - shapeHeight / 2))
        
        rhombus.addLine(to: CGPoint(x: bounds.width - insetX,
                                    y: offsetY))
        
        rhombus.addLine(to: CGPoint(x: bounds.width / 2,
                                    y: offsetY + shapeHeight / 2))
        
        rhombus.close()
        return rhombus
    }
    
    
    private func bezierWeirdOffsetYBy(_ offsetY: CGFloat) -> UIBezierPath {
        let weird = UIBezierPath()
        let startPoint = CGPoint(x: insetX, y: offsetY)
        weird.move(to: startPoint)
        
        //Constants have no real meaning here
        weird.addCurve(to: CGPoint(x: bounds.width * 0.75,
                                   y: startPoint.y - bounds.height * 0.072),
                       
                       controlPoint1: CGPoint(x: bounds.width * 0.35,
                                              y: startPoint.y - bounds.height * 0.062),
                       
                       controlPoint2: CGPoint(x: bounds.width * 0.55,
                                              y: startPoint.y - bounds.height * 0.04))

        weird.addCurve(to: CGPoint(x: bounds.width * 0.45,
                                   y: startPoint.y + bounds.height * 0.075),
                       
                       controlPoint1: CGPoint(x: bounds.width * 0.8,
                                              y: startPoint.y + bounds.height * 0.065),
                       
                       controlPoint2: CGPoint(x: bounds.width * 0.65,
                                              y: startPoint.y + bounds.height * 0.05))
        
        weird.close()
        return weird
    }
    
    
    //MARK: Bezier Crate
    private func bezierCrateLines() -> UIBezierPath {
        let lines = UIBezierPath()
        let numberOfLines: CGFloat = bounds.width > 50 ? 20 : 11
        
        for offsetX in stride(from: 0, to: bounds.width, by: bounds.width / numberOfLines) {
            lines.move(to: CGPoint(x: offsetX, y: 0))
            lines.addLine(to: CGPoint(x: offsetX, y: bounds.height))
        }
        
        return lines
    }
}


extension CardView {
    private struct SizeRatio {
        static let heightToBackgroundRectCornerRadius: CGFloat   = 0.085
        static let heightToRoundedRectShapeCornerRadius: CGFloat = 0.2
        static let zoomOfCardBackgroundToBounds: CGFloat         = 0.9
    }
    
    private var backgroundRectCornerRadius: CGFloat {
        return bounds.height * SizeRatio.heightToBackgroundRectCornerRadius
    }
    
    private var roundedRectShapeCornerRadius: CGFloat {
        return bounds.height * SizeRatio.heightToRoundedRectShapeCornerRadius
    }
    
    private var insetX: CGFloat {
        return bounds.width * 0.2
    }

    private var spacing: CGFloat {
        return bounds.height * 0.05
    }
    
    private var shapeHeight: CGFloat {
        return bounds.height * 0.15
    }
    
    private var shapeWidth: CGFloat {
        return bounds.width * 0.6
    }
}
