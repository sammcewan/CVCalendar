//
//  CVAuxiliaryView.swift
//  CVCalendar Demo
//
//  Created by Eugene Mozharovsky on 22/03/15.
//  Copyright (c) 2015 GameApp. All rights reserved.
//

import UIKit

public final class CVAuxiliaryView: UIView {
    public var shape: CVShape!
    public var strokeColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }

    public var fillColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }

    public let defaultFillColor = UIColor.colorFromCode(0xe74c3c)

    fileprivate var radius: CGFloat {
        get {
            return (min(frame.height, frame.width) - 10) / 2
        }
    }

    public unowned let dayView: DayView

    public init(dayView: DayView, rect: CGRect, shape: CVShape) {
        self.dayView = dayView
        self.shape = shape
        super.init(frame: rect)
        strokeColor = UIColor.clear
        fillColor = UIColor.colorFromCode(0xe74c3c)

        layer.cornerRadius = 5
        backgroundColor = .clear
    }

    public override func didMoveToSuperview() {
        setNeedsDisplay()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        var path: UIBezierPath!

        if let shape = shape {
            switch shape {
            case .rightFlag: path = rightFlagPath()
            case .leftFlag: path = leftFlagPath()
            case .roundedRect: path = roundedRectPath()
            case .rect: path = rectPath()
            case .custom(let customPathBlock): path = customPathBlock(rect)
            }

            switch shape {
            case .custom: break
            default: path.lineWidth = 1
            }
        }

        strokeColor.setStroke()
        fillColor.setFill()

        if let path = path {
            path.stroke()
            path.fill()
        }
    }
}

extension CVAuxiliaryView {
    public func updateFrame(_ frame: CGRect) {
        self.frame = frame
        setNeedsDisplay()
    }
}

extension CVAuxiliaryView {
    func roundedRectPath() -> UIBezierPath {
        let offset: CGFloat = 8.0
        let path = UIBezierPath(roundedRect: CGRect(x: offset, y: offset, width: bounds.width - offset * 2, height: frame.height - offset * 2), cornerRadius: 3.0)
        return path
    }
    
    private func circlePath() -> UIBezierPath {
        let arcCenter = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let startAngle = CGFloat(0)
        let endAngle = CGFloat(M_PI * 2.0)
        let clockwise = true
        
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius,
                                startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        return path
    }

    func rightFlagPath() -> UIBezierPath {
        let flag = UIBezierPath()
        flag.move(to: CGPoint(x: bounds.width / 2, y: bounds.height / 2 - radius))
        flag.addLine(to: CGPoint(x: bounds.width, y: bounds.height / 2 - radius))
        flag.addLine(to: CGPoint(x: bounds.width, y: bounds.height / 2 + radius ))
        flag.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height / 2 + radius))

        let path = CGMutablePath()
        path.addPath(circlePath().cgPath)
        path.addPath(flag.cgPath)

        return UIBezierPath(cgPath: path)
    }

    func leftFlagPath() -> UIBezierPath {
        let flag = UIBezierPath()
        flag.move(to: CGPoint(x: bounds.width / 2, y: bounds.height / 2 + radius))
        flag.addLine(to: CGPoint(x: 0, y: bounds.height / 2 + radius))
        flag.addLine(to: CGPoint(x: 0, y: bounds.height / 2 - radius))
        flag.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height / 2 - radius))

        let path = CGMutablePath()
        path.addPath(circlePath().cgPath)
        path.addPath(flag.cgPath)

        return UIBezierPath(cgPath: path)
    }

    func rectPath() -> UIBezierPath {
        let midY = bounds.height / 2

        let appearance = dayView.calendarView.appearance
        let offset = appearance?.spaceBetweenDayViews!

        print("offset = \(offset)")

        let path = UIBezierPath(rect: CGRect(x: 0 - offset!, y: midY - radius,
            width: bounds.width + offset! / 2, height: radius * 2))

        return path
    }
}
