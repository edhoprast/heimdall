//
//  HeimdallWidget.swift
//  HeimdallWidget
//
//  Created by Edho Prasetyo on 17/09/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MovieWidgetEntry {
        return MovieWidgetEntry(movies: [
            MovieWidget(
                title: "Upcoming Movies",
                subtitle: "21 Oct 2026",
                dateTitle: "27",
                dateSubtitle: "days",
                backdropImage: nil
            )
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (MovieWidgetEntry) -> Void) {
        let snapshot = MovieWidgetEntry(movies: [
            MovieWidget(
                title: "Upcoming Movies",
                subtitle: "21 Oct 2026",
                dateTitle: "27",
                dateSubtitle: "days",
                backdropImage: nil
            )
        ])
        completion(snapshot)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MovieWidgetEntry>) -> Void) {
        Task {
            let response = await SharedDataStore.fetchData()
            guard case let .success(data) = response, let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else { return }
            
            let dataProcessed = await data.getTopNearestMovie()
            
            // Ask system to refresh tomorrow (once a day)
            let timeline = Timeline(entries: [dataProcessed!], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}

struct HeimdallWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        let firstMovie = entry.movies.first!
        
        HStack() {
            VStack(spacing: -4) {
                Text(firstMovie.dateTitle)
                    .font(.system(size: 28, design: .rounded))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Text(firstMovie.dateSubtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            
            if let ui = firstMovie.backdropImage?.cgImage {
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
