//
//  Belief.swift
//  Beliefs
//
//  Created by kunal.jain on 2024/07/26.
//

import Foundation

struct Belief: Identifiable {
    var id: Int
    var title: String
    var evidence: String
    var category: String = "Misc"  // New category property with default value
}
