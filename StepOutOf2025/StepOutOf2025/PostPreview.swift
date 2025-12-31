//
//  PostPreview.swift
//  StepOutOf2025
//
//  Created by Joseph Simpson on 12/31/25.
//

import SwiftUI

struct PostPreview: View {
    // Query stepinto.vision for all posts in 2025
    // Load cycle through them one at at time, loading each one in a web view
    // If possible, wait until a post loads before replacing the current one

    private let feedURL = URL(string: "https://stepinto.vision/")!

    var body: some View {
        PostsSlideshowView(feedURL: feedURL, displayDuration: 2.0)
            .ignoresSafeArea()
    }
}
#Preview {
    PostPreview()
}

