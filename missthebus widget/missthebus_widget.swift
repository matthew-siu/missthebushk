//
//  missthebus_widget.swift
//  missthebus widget
//
//  Created by Matthew Siu on 3/5/2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let etaManager = WidgetBusStopETAManager()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let second = 30
        let loop = 10
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        self.etaManager.requestETA()
            .done{body in
                for offset in 0 ..< loop {
                    let entryDate = Calendar.current.date(byAdding: .second, value: offset * second, to: currentDate)!
                    let entry = SimpleEntry(date: entryDate, etaList: body)
                    entries.append(entry)
                }
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
            .catch{err in
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }

    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var etaList: [WidgetBusStopETA] = []
}

struct missthebus_widgetEntryView : View {
    var entry: Provider.Entry
    

    var body: some View {
        ETAWidgetView(entry: self.entry)
    }
}


@main
struct missthebus_widget: Widget {
    let kind: String = "missthebus_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            missthebus_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct missthebus_widget_Previews: PreviewProvider {
    static var previews: some View {
        missthebus_widgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
