//
//  BiGradient.swift
//  Pride2025
//
//  Created by Joseph Simpson on 5/29/25.
//

import SwiftUI

struct BiGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.biMagenta, .biPurple, .biRoyalBlue]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    BiGradient()
}
