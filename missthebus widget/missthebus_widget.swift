//
//  missthebus_widget.swift
//  missthebus widget
//
//  Created by Matthew Siu on 3/5/2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let index: Int
    let etaManager = WidgetBusStopETAManager()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), index: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), index: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let second = 30
        let loop = 10
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        self.etaManager.requestETA(self.index)
            .done{body in
                for offset in 0 ..< loop {
                    let entryDate = Calendar.current.date(byAdding: .second, value: offset * second, to: currentDate)!
                    let entry = SimpleEntry(date: entryDate, index: index, etaList: body)
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
    let index: Int
    var etaList: [WidgetBusStopETA] = []
}

struct missthebus_widgetEntryView : View {
    var entry: Provider.Entry
    

    var body: some View {
        ETAWidgetView(entry: self.entry)
    }
}

struct missthebus_widget: Widget {
    var index: Int = 0
    let kind: String = "missthebus_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(index: index)) { entry in
            missthebus_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("widget_app_name\(index + 1)".localized())
        .description("widget_description\(index + 1)".localized())
        .supportedFamilies([.systemSmall])
    }
}

struct missthebus_widget2: Widget {
    let index: Int = 1
    let kind: String = "missthebus_widget2"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(index: index)) { entry in
            missthebus_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("widget_app_name\(index + 1)".localized())
        .description("widget_description\(index + 1)".localized())
        .supportedFamilies([.systemSmall])
    }
}

struct missthebus_widget3: Widget {
    let index: Int = 2
    let kind: String = "missthebus_widget3"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(index: index)) { entry in
            missthebus_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("widget_app_name\(index + 1)".localized())
        .description("widget_description\(index + 1)".localized())
        .supportedFamilies([.systemSmall])
    }
}

@main
struct missthebus_widgets: WidgetBundle {
    
    @WidgetBundleBuilder
    var body: some Widget {
        missthebus_widget()
        missthebus_widget2()
        missthebus_widget3()
    }
}

struct missthebus_widget_Previews: PreviewProvider {
    static var previews: some View {
        missthebus_widgetEntryView(entry: SimpleEntry(date: Date(), index: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
