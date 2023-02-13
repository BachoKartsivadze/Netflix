//
//  Extensions.swift
//  Netflix Clone
//
//  Created by bacho kartsivadze on 08.12.22.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.dropFirst().lowercased()
    }
}
