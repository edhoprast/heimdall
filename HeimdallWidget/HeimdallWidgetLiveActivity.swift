//
//  HeimdallWidgetLiveActivity.swift
//  HeimdallWidget
//
//  Created by Edho Prasetyo on 17/09/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HeimdallWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HeimdallWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HeimdallWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension HeimdallWidgetAttributes {
    fileprivate static var preview: HeimdallWidgetAttributes {
        HeimdallWidgetAttributes(name: "World")
    }
}

extension HeimdallWidgetAttributes.ContentState {
    fileprivate static var smiley: HeimdallWidgetAttributes.ContentState {
        HeimdallWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: HeimdallWidgetAttributes.ContentState {
         HeimdallWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: HeimdallWidgetAttributes.preview) {
   HeimdallWidgetLiveActivity()
} contentStates: {
    HeimdallWidgetAttributes.ContentState.smiley
    HeimdallWidgetAttributes.ContentState.starEyes
}
