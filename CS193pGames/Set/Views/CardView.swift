//
//  CardView.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 11.12.20.
//

import UIKit
 

class CardView: UIView {
    
    var card: Card! { didSet { setNeedsDisplay(); setNeedsLayout() }}
    var glowColor: UIColor! {
        didSet {
            isUserInteractionEnabled = [GlowType.selected.color, GlowType.usual.color].contains(glowColor)
            setNeedsDisplay()
        }
    }
    var isFaceUp = false { didSet { setNeedsDisplay() }}
    
    convenience init(frame: CGRect, card: Card) {
        self.init(frame: frame)
        self.card = card
        backgroundColor = .clear
        clipsToBounds = true
    }
    
    
    override func draw(_ rect: CGRect) {
        //Setting background
        drawBezierBackgroundRoundedRect(at: bounds.zoom(by: SizeRatio.zoomOfCardBackgroundToBounds))
        
        if isFaceUp {
            //Setting Color
            var color: UIColor
            switch card.color {
            case 0: color = UIColor.appColor(.shapeRed)!
            case 1: color = UIColor.appColor(.shapeGreen)!
            case 2: color = UIColor.appColor(.shapeBlue)!
            default: color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
            color.setStroke()
            color.setFill()

            
            //Choosing Shape
            let shapeDrawer: ((CGFloat) -> UIBezierPath)?
            switch card.shape {
            case 0: shapeDrawer = bezierRoundedRect(_:)
            case 1: shapeDrawer = bezierRhombus(_:)
            case 2: shapeDrawer = bezierWeird(_:)
            default: shapeDrawer = nil
            }
            
            
            //Applying number of shapes
            let shape = UIBezierPath()
            switch card.numberOfShapes {
            case 0: shape.append(shapeDrawer!(bounds.midY))
            case 1:
                let offsetToMiddleOfShape = (spacing + shapeHeight) / 2
                shape.append(shapeDrawer!(bounds.midY - offsetToMiddleOfShape))
                shape.append(shapeDrawer!(bounds.midY + offsetToMiddleOfShape))
            case 2:
                let offsetToMiddleOfShape = (spacing + shapeHeight)
                shape.append(shapeDrawer!(bounds.midY - offsetToMiddleOfShape))
                shape.append(shapeDrawer!(bounds.midY))
                shape.append(shapeDrawer!(bounds.midY + offsetToMiddleOfShape))
            default: break
            }
            
            shape.lineWidth = 3
            shape.addClip()
            shape.stroke()
            
            //Setting Shading
            switch card.shading {
            case 0: shape.fill()
            case 1: bezierCrateLines().stroke()
            default: break
            }
        }
    }
}


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
    private func bezierRoundedRect(_ offsetY: CGFloat) -> UIBezierPath {
        return UIBezierPath(roundedRect: CGRect(x: insetX, y: offsetY - shapeHeight / 2, width: shapeWidth, height: shapeHeight), cornerRadius: roundedRectShapeCornerRadius)
    }
    
    
    private func bezierRhombus(_ offsetY: CGFloat) -> UIBezierPath {
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
    
    
    private func bezierWeird(_ offsetY: CGFloat) -> UIBezierPath {
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
