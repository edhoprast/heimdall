//
//  HeimdallWidget.swift
//  HeimdallWidget
//
//  Created by Edho Prasetyo on 17/09/25.
//

import WidgetKit
import SwiftUI

struct MessageEntry: TimelineEntry {
    let date: Date
    let message: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MessageEntry {
        MessageEntry(date: Date(), message: "Placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (MessageEntry) -> Void) {
        let entry = MessageEntry(date: Date(), message: SharedDataStore.loadMessage())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MessageEntry>) -> Void) {
        let entry = MessageEntry(date: Date(), message: SharedDataStore.loadMessage())
        // Ask system to refresh tomorrow (once a day)
        let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct HeimdallWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Widget Demo")
                .font(.headline)
            Text(entry.message)
                .font(.body)
        }
        .padding()
    }
}

struct HeimdallWidget: Widget {
    let kind: String = "WidgetDemoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HeimdallWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Message Widget")
        .description("Shows the latest message from the app.")
    }
}
