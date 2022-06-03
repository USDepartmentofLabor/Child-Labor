

import UIKit

struct Segment {

    // the color of a given segment
    var color: UIColor

    // the value of a given segment – will be used to automatically calculate a ratio
    var value: CGFloat
    
    var title : String
}

class CircularSliceView: UIView {

    var segments = [Segment]() {
        didSet {
            totalValue = segments.reduce(0) { $0 + $1.value }
            setupLabels()
            setNeedsDisplay() // re-draw view when the values get set
            layoutLabels();
        }
    }

    private var totalValue: CGFloat = 1;
    private var labels: [UILabel] = []




    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false // when overriding drawRect, you must specify this to maintain transparency.
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        let anglePI2 = (CGFloat.pi * 2)
        let center = CGPoint.init(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = min(bounds.size.width, bounds.size.height) / 2;

        let lineWidth: CGFloat = 1;

        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(lineWidth)


        var currentAngle: CGFloat = 0

        if totalValue <= 0 {
            totalValue = 1
        }

        let iRange = 0 ..< segments.count
        for i in iRange {
            let segment = segments[i]
            // calculate percent
            let percent = segment.value / totalValue

            let angle = anglePI2 * percent

            ctx?.beginPath()
            ctx?.move(to: center)
            ctx?.addArc(center: center, radius: radius - lineWidth, startAngle: currentAngle, endAngle: currentAngle + angle, clockwise: false)
            ctx?.closePath()

            ctx?.setFillColor(segment.color.cgColor)
            ctx?.fillPath()

            ctx?.beginPath()
            ctx?.move(to: center)
            ctx?.addArc(center: center, radius: radius - (lineWidth / 2), startAngle: currentAngle, endAngle: currentAngle + angle, clockwise: false)
            ctx?.closePath()

            ctx?.setStrokeColor(UIColor.white.cgColor)
            ctx?.strokePath()

            currentAngle += angle
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutLabels()
    }
    
    private func setupLabels() {
        var diff = segments.count - labels.count;
        if diff >= 0 {
            for _ in 0 ..< diff {
                let lbl = UILabel()
                lbl.numberOfLines = 0
                lbl.adjustsFontSizeToFitWidth = true
                self.addSubview(lbl)
                labels.append(lbl)
            }
        } else { // diff < 0 (minus values)
            // loop until diff is 0
            //
            while diff != 0 {
                var lbl: UILabel!
                // if there is no more labels to remove
                // break the loop
                if labels.count <= 0 {
                    break;
                }
                // get the last label
                lbl = labels.removeLast()
                if lbl.superview != nil {
                    lbl.removeFromSuperview()
                }
                // increment the minus value by 1
                diff += 1;
            }
        }

        for i in 0 ..< segments.count {
            let lbl = labels[i]
            lbl.textColor = UIColor.white
            lbl.text = String.init(format: "%d", Int(segments[i].value))
            lbl.font = UIFont.init(name: "ArialRoundedMT-Bold", size: 12)
        }
    }
    func layoutLabels() {
        let anglePI2 = CGFloat.pi * 2
        let center = CGPoint.init(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = min(bounds.size.width / 2, bounds.size.height / 2) / 2

        var currentAngle: CGFloat = 0;
        let iRange = 0 ..< labels.count
        for i in iRange {
            let lbl = labels[i]
            let percent = segments[i].value / totalValue

            let intervalAngle = anglePI2 * percent;
            lbl.frame = .zero;
            lbl.sizeToFit()

            let x = center.x + radius * cos(currentAngle + (intervalAngle / 2))
            let y = center.y + radius * sin(currentAngle + (intervalAngle / 2))
            lbl.center = CGPoint.init(x: x, y: y)

            currentAngle += intervalAngle

        }
    }

}
