//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
    
import UIKit

public extension UIView {
    func setSkeleton(_ show: Bool, cornerRadius: CGFloat = 5, width: CGFloat? = nil) {
        subviews.first(where: { $0.tag == 999 })?.removeFromSuperview()

        if show {
            let skeleton = UIView()
            skeleton.backgroundColor = .secondarySystemFill
            skeleton.layer.cornerRadius = cornerRadius
            skeleton.tag = 999
            skeleton.translatesAutoresizingMaskIntoConstraints = false

            addSubview(skeleton)

            NSLayoutConstraint.activate([
                skeleton.topAnchor.constraint(equalTo: topAnchor),
                skeleton.leadingAnchor.constraint(equalTo: leadingAnchor),
                skeleton.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])

            NSLayoutConstraint.activate([
                width != nil
                ? skeleton.widthAnchor.constraint(equalToConstant: width!)
                : skeleton.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
}
