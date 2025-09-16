//
//  HeimdallWidgetBundle.swift
//  HeimdallWidget
//
//  Created by Edho Prasetyo on 17/09/25.
//

import WidgetKit
import SwiftUI

@main
struct HeimdallWidgetBundle: WidgetBundle {
    var body: some Widget {
        HeimdallWidget()
        HeimdallWidgetControl()
        HeimdallWidgetLiveActivity()
    }
}
