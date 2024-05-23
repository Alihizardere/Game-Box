//
//  InformationCustomView.swift
//  Game Box
//
//  Created by alihizardere on 23.05.2024.
//

import UIKit

class InformationCustomView: UIView {

  override init(frame: CGRect) {
     super.init(frame: frame)
     commonInit()
   }

   required init?(coder: NSCoder) {
     super.init(coder: coder)
     commonInit()
   }

  private func commonInit() {
     let bundle = Bundle(for: type(of: self))
     let nib = UINib(nibName: "InformationCustomView", bundle: bundle)
     let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
     view.frame = self.bounds
     view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
     addSubview(view)
   }
}
