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
                backdropImage: nil,
                posterImage: nil
            )
        ], shouldShowSingleMovie: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (MovieWidgetEntry) -> Void) {
        let snapshot = MovieWidgetEntry(movies: [
            MovieWidget(
                title: "Upcoming Movies",
                subtitle: "21 Oct 2026",
                dateTitle: "27",
                dateSubtitle: "days",
                backdropImage: nil,
                posterImage: nil
            )
        ], shouldShowSingleMovie: true)
        completion(snapshot)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MovieWidgetEntry>) -> Void) {
        Task {
            let response = await SharedDataStore.fetchData()
            guard case let .success(data) = response, let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: Date()), let dataProcessed = await data.getTopNearestMovie() else {
                return
            }
            
            // Ask system to refresh tomorrow (once a day)
            let timeline = Timeline(entries: [dataProcessed], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}

struct HeimdallWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            smallUI()
        case .systemMedium:
            mediumUI()
        case .systemLarge:
            EmptyView()
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func smallUI() -> some View {
        if let first = entry.movies.first {
            let subtitle = first.dateTitle != nil ? (first.dateTitle ?? "") + " days" : first.subtitle
            
            if let subtitle {
                ZStack(alignment: .leading) {
                    if let ui = first.posterImage?.cgImage {
                        Image(decorative: ui, scale: 1.0)
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }else{
                        Rectangle().fill(.secondary)
                    }
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(first.title)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .bold()
                        
                        Text(subtitle)
                            .font(.system(size: 14, design: .rounded))
                            .foregroundStyle(.white)
                            .opacity(0.8)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                }
                .containerBackground(.clear, for: .widget)
            }
        }else{
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func mediumUI() -> some View {
        let firstMovie = entry.movies.first!
        let dateTitle = firstMovie.dateTitle
        let dateSubtitle = firstMovie.dateSubtitle
        
        if entry.shouldShowSingleMovie {
            HStack() {
                if let dateTitle, let dateSubtitle {
                    VStack(alignment: .leading, spacing: -2) {
                        Text(dateTitle)
                            .font(.system(size: 28, design: .rounded))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .bold()
                        Text(dateSubtitle)
                            .multilineTextAlignment(.leading)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(.top, 4)
                }
                
                ZStack(alignment: .leading) {
                    if let ui = firstMovie.backdropImage?.cgImage {
                        Image(decorative: ui, scale: 1.0)
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }else{
                        Rectangle().fill(.secondary)
                    }
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(firstMovie.title)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .bold()
                        
                        if let subtitle = firstMovie.subtitle {
                            Text(subtitle)
                                .font(.system(size: 14, design: .rounded))
                                .foregroundStyle(.white)
                                .opacity(0.8)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                }
            }
            .padding(.vertical, 8)
            .padding(.leading, dateTitle != nil ? 16 : 8)
            .padding(.trailing, 8)
            .containerBackground(.clear, for: .widget)
        }else{
            EmptyView()
        }
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
