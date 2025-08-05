//
//  SimpleWidgetsBundle.swift
//  SimpleWidgets
//
//  Created by Joseph Simpson on 7/27/25.
//

import WidgetKit
import SwiftUI

@main
struct SimpleWidgetsBundle: WidgetBundle {
    var body: some Widget {
        SimpleWidgets()
        EmojiWidget()
        ClockWidget()
        MoodWidgets()
    }
}
