//
//  HabitWidgetBundle.swift
//  HabitWidget
//
//  Created by Hansen Yudistira on 13/07/24.
//

import WidgetKit
import SwiftUI
import SwiftData

@main
struct HabitWidgetBundle: WidgetBundle {
    
    @WidgetBundleBuilder
    var body: some Widget {
        HabitWidget()
//        HabitDailyWidget()
    }
}
