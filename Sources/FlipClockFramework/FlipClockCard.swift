//
//  FlipClockCard.swift
//  
//
//  Created by OmerErbalta on 13.10.2024.
//

#if canImport(UIKit)
import UIKit
#endif

protocol FlipClockCardViewDelegate: AnyObject {
    func didUpdateUpRectangleValue()
}

extension UIColor {
    static func fromFramework(named name: String) -> UIColor? {
        let bundle = Bundle(for: FlipClockView.self)
        return UIColor(named: name, in: bundle, compatibleWith: nil)
    }
}
class FlipClockCardView: UIView {

    // MARK: - Properties
    private let upRectangle: ClockRectangle
    private let downRectangle: ClockRectangle
    private let upRectangleNextValue: ClockRectangle
    
    var clockType: ClockType {
        didSet {
            updateClockType()
        }
    }
    
    var isLandSpace: Bool = false {
        didSet {
            updateSize()
        }
    }
    var color: UIColor {
        didSet {
            updateRectangleColors()
        }
    }

    var textColor: UIColor {
        didSet {
            updateTextColors()
        }
    }

    var font: UIFont {
        didSet {
            updateFonts()
        }
    }

    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()

    weak var delegate: FlipClockCardViewDelegate?

    // MARK: - Initializers
    init(clockType: ClockType, backgroundColor: UIColor, textColor: UIColor, font: UIFont) {
        self.clockType = clockType
        self.color = backgroundColor
        self.textColor = textColor
        self.font = font

        self.upRectangle = ClockRectangle(
            type: .upRectangle,
            clockType: clockType,
            backgroundColor: backgroundColor,
            textColor: textColor,
            font: font
        )

        self.downRectangle = ClockRectangle(
            type: .downRectangle,
            clockType: clockType,
            backgroundColor: backgroundColor,
            textColor: textColor,
            font: font
        )

        self.upRectangleNextValue = ClockRectangle(
            type: .upRectangle,
            clockType: clockType,
            backgroundColor: backgroundColor,
            textColor: textColor,
            font: font
        )
        self.upRectangleNextValue.isHidden = true

        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func update(with newValue: Int) {
        upRectangle.value = newValue
        upRectangleNextValue.setValue(newValue) {
            self.downRectangle.value = newValue
            self.delegate?.didUpdateUpRectangleValue()
        }
    }

    // MARK: - Private Methods
    private func setupView() {
        [upRectangleNextValue, upRectangle, divider, downRectangle].forEach {
            addSubview($0)
        }

        bringSubviewToFront(upRectangleNextValue)
        upRectangleNextValue.layer.zPosition = 20
        divider.layer.zPosition = 21
        setupConstraints()
        print(UIScreen.main.bounds.width)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            upRectangleNextValue.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            upRectangleNextValue.centerYAnchor.constraint(equalTo: self.divider.centerYAnchor),
            upRectangleNextValue.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            upRectangleNextValue.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),

            upRectangle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            upRectangle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            upRectangle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            upRectangle.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),

            divider.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            divider.topAnchor.constraint(equalTo: upRectangle.bottomAnchor),
            divider.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            divider.heightAnchor.constraint(equalToConstant: 1),

            downRectangle.topAnchor.constraint(equalTo: upRectangle.bottomAnchor),
            downRectangle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            downRectangle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            downRectangle.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
        ])
    }

    private func updateClockType() {
        upRectangle.setClockType(clockType)
        downRectangle.setClockType(clockType)
        upRectangleNextValue.setClockType(clockType)
    }

    private func updateRectangleColors() {
        upRectangle.color = color
        downRectangle.color = color
        upRectangleNextValue.color = color
    }

    private func updateTextColors() {
        upRectangle.textColor = textColor
        downRectangle.textColor = textColor
        upRectangleNextValue.textColor = textColor
    }

    private func updateFonts() {
        upRectangle.font = font
        downRectangle.font = font
        upRectangleNextValue.font = font
    }
    
    private func updateSize() {
        layoutIfNeeded()
    }
}
