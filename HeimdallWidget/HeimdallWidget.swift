//
//  HeimdallWidget.swift
//  HeimdallWidget
//
//  Created by Edho Prasetyo on 17/09/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Movies {
        return Movies(
            originalTitle: "Upcoming Movies",
            releaseDate: "2025-01-01"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (Movies) -> Void) {
        Task{
            let img = await fetchImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTABbXr4i-QODqhy7tofHYmTYh05rYPktzacw&s")
            let entry = MessageEntry(date: Date(), message: "Snapshot", image: img)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MessageEntry>) -> Void) {
        Task {
            let img = await fetchImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTABbXr4i-QODqhy7tofHYmTYh05rYPktzacw&s")
            let entry = MessageEntry(date: Date(), message: "Timeline", image: img)
            // Ask system to refresh tomorrow (once a day)
            let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
    
    // MARK: - Image fetcher
    private func fetchImage(_ urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}

struct HeimdallWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        HStack() {
            VStack(spacing: -4) {
                Text("27")
                    .font(.system(size: 28, design: .rounded))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Text("days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            
            if let ui = entry.image?.cgImage {
                Image(decorative: ui, scale: 1.0)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }else{
                Rectangle().fill(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .containerBackground(.white, for: .widget)
    }
}

@main
struct HeimdallWidget: Widget {
    let kind: String = "WidgetDemoWidget"

    @available(iOS 17.0, *)
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HeimdallWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Message Widget")
        .contentMarginsDisabled()
        .description("Shows the latest message from the app.")
    }
}
