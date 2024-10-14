//
//  FlipClock.swift
//  
//
//  Created by OmerErbalta on 13.10.2024.
//

#if canImport(UIKit)
import UIKit
#endif

public enum ClockType: Equatable {
    case clock
    case countdown(minutes:Int)
}

open class FlipClockView: UIView {
    
    // MARK: - Properties
    private var timer: Timer?
    private var seconds: Int = 0 {
        didSet { updateFlipClockCards() }
    }
   
    open var clockType: ClockType = .clock {
        didSet {
            hourCard.clockType = clockType
            minuteCard.clockType = clockType
            secondCard.clockType = clockType
            
            if case .countdown(let minutes) = clockType {
                seconds = minutes * 60
            } else {
                seconds = 0
            }
            startTimer()
        }
    }

    open var color: UIColor = UIColor.fromFramework(named: "primarry") ?? .black {
        didSet {
            hourCard.color = color
            minuteCard.color = color
            secondCard.color = color
        }
    }

    open var textColor: UIColor =  UIColor.fromFramework(named: "secondry") ?? .white  {
        didSet {
            hourCard.textColor = textColor
            minuteCard.textColor = textColor
            secondCard.textColor = textColor
        }
    }

   open var font: UIFont = UIFont.systemFont(ofSize: 60, weight: .semibold) {
        didSet {
            hourCard.font = font
            minuteCard.font = font
            secondCard.font = font
        }
    }

    private var previousHours = 0
    private var previousMinutes = 0
    private var previousSeconds = 0

    private let hourCard: FlipClockCardView
    private let minuteCard: FlipClockCardView
    private let secondCard: FlipClockCardView

    // MARK: - Initializers
    public init(
        clockType: ClockType? = nil,
        color: UIColor? = nil,
        textColor: UIColor? = nil,
        font: UIFont? = nil
    ) {
        self.clockType = clockType ?? self.clockType
        self.color = color ?? self.color
        self.textColor = textColor ?? self.textColor
        self.font = font ?? self.font

        hourCard = FlipClockCardView(
            clockType: self.clockType,
            backgroundColor: self.color,
            textColor: self.textColor,
            font: self.font
        )
        minuteCard = FlipClockCardView(
            clockType: self.clockType,
            backgroundColor: self.color,
            textColor: self.textColor,
            font: self.font
        )
        secondCard = FlipClockCardView(
            clockType: self.clockType,
            backgroundColor: self.color,
            textColor: self.textColor,
            font: self.font
        )

        super.init(frame: .zero)
        setupView()
        startTimer()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [hourCard, minuteCard, secondCard])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }

    // MARK: - Timer Methods
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateSeconds()
        }
    }

    private func updateSeconds() {
        switch clockType {
        case .clock:
            seconds += 1
        case .countdown:
            seconds -= 1
            if seconds <= 0 {
                seconds = 0
                timer?.invalidate()
            }
        }
    }

    // MARK: - Update Methods
    
    private func updateColorMode() {
        
    }
    
    private func updateFlipClockCards() {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60

        if hours != previousHours {
            hourCard.update(with: hours)
            previousHours = hours
        }
        if minutes != previousMinutes {
            minuteCard.update(with: minutes)
            previousMinutes = minutes
        }
        if secs != previousSeconds {
            secondCard.update(with: secs)
            previousSeconds = secs
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let isLandscape = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        hourCard.isLandSpace = isLandscape
        minuteCard.isLandSpace = isLandscape
        secondCard.isLandSpace = isLandscape
    }

    deinit {
        timer?.invalidate()
    }
}
