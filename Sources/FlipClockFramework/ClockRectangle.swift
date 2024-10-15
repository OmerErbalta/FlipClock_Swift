//
//  ClockRectangle.swift
//
//
//  Created by OmerErbalta on 13.10.2024.
//

#if canImport(UIKit)
import UIKit
#endif

public enum RectangleType {
    case upRectangle
    case downRectangle
}

class ClockRectangle: UIView {
    // MARK: - Properties
    var value: Int = 0 {
        didSet {
            valueLabel.text = String(format: "%02d", value)
            let nextValue = calculateNextValue(currentValue: value)
            nextValueLabel.text = String(format: "%02d", nextValue)
        }
    }

    var rectangleType: RectangleType
    var clockType: ClockType {
        didSet { updateView() }
    }

    var color: UIColor {
        didSet {
            frontView.backgroundColor = color
            backView.backgroundColor = color
        }
    }

    var textColor: UIColor {
        didSet {
            valueLabel.textColor = textColor
            nextValueLabel.textColor = textColor
        }
    }

    var font: UIFont {
        didSet {
            valueLabel.font = font
            nextValueLabel.font = font
        }
    }

    // MARK: - UI Elements
    private let valueLabel = UILabel()
    private let nextValueLabel = UILabel()
    private let frontView = UIView()
    private let backView = UIView()

    // MARK: - Initializer
    init(type: RectangleType,
         clockType: ClockType,
         backgroundColor: UIColor,
         textColor: UIColor,
         font: UIFont,
         value:Int
    ) {

        self.rectangleType = type
        self.clockType = clockType
        self.color = backgroundColor
        self.textColor = textColor
        self.font = font
        self.value = value

        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true

        configureLabels()
        configureView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper Methods
    private func calculateNextValue(currentValue: Int) -> Int {
        switch clockType {
        case .clock:
            return (currentValue + 1) % 60
        case .countdown:
            return (currentValue == 0) ? 59 : currentValue - 1
        case .countup(to: let to):
            return (currentValue + 1) % 60
        }
    }

    private func configureLabels() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.textAlignment = .center
        valueLabel.backgroundColor = .clear
        valueLabel.font = self.font
        valueLabel.textColor = self.textColor
        valueLabel.text = String(format: "%02d", value)

        nextValueLabel.translatesAutoresizingMaskIntoConstraints = false
        nextValueLabel.textColor = self.textColor
        nextValueLabel.font = self.font
        nextValueLabel.textAlignment = .center
        nextValueLabel.backgroundColor = .clear

        let nextValue = calculateNextValue(currentValue: value)
        nextValueLabel.text = String(format: "%02d", nextValue)
    }

    private func configureView() {
        frontView.translatesAutoresizingMaskIntoConstraints = false
        frontView.backgroundColor = self.color
        self.addSubview(frontView)
        frontView.addSubview(valueLabel)

        switch rectangleType {
        case .upRectangle:
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            backView.translatesAutoresizingMaskIntoConstraints = false
            backView.backgroundColor = color
            self.addSubview(backView)
            backView.addSubview(nextValueLabel)
            backView.isHidden = true

        case .downRectangle:
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            frontView.topAnchor.constraint(equalTo: self.topAnchor),
            frontView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            frontView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            frontView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            valueLabel.centerXAnchor.constraint(equalTo: frontView.centerXAnchor),
        ])

        if rectangleType == .downRectangle {
            valueLabel.centerYAnchor.constraint(equalTo: frontView.topAnchor).isActive = true
        } else {
            valueLabel.centerYAnchor.constraint(equalTo: frontView.bottomAnchor).isActive = true
            NSLayoutConstraint.activate([
                backView.topAnchor.constraint(equalTo: self.topAnchor),
                backView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                backView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                backView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                nextValueLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
                nextValueLabel.centerYAnchor.constraint(equalTo: backView.bottomAnchor)
            ])
            nextValueLabel.transform = CGAffineTransform(rotationAngle: .pi)
            nextValueLabel.layer.transform = CATransform3DMakeScale(1, -1, 1)
        }
    }

    // MARK: - Public Methods
    func setClockType(_ type: ClockType) {
        self.clockType = type
    }

    private func updateView() {
        frontView.backgroundColor = color
        backView.backgroundColor = color
        valueLabel.textColor = textColor
        nextValueLabel.textColor = textColor
        valueLabel.font = font
        nextValueLabel.font = font
    }

    func setValue(_ newValue: Int, completion: @escaping () -> Void) {
        if rectangleType == .upRectangle {
            flip {
                self.value = newValue
                completion()
            }
        } else {
            completion()
        }
    }

    func flip(completion: @escaping () -> Void) {
        self.isHidden = false
        var transform = CATransform3DIdentity
        transform.m32 = 1.0 / 100.0

        self.layer.anchorPoint = CGPoint(x: 0.5, y: 1)

        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.layer.transform = CATransform3DRotate(transform, CGFloat.pi, 1, 0, 0)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.backView.isHidden = false
            }
        }, completion: { _ in
            self.backView.isHidden = true
            self.layer.transform = CATransform3DIdentity
            self.isHidden = true
            completion()
        })
    }
}
