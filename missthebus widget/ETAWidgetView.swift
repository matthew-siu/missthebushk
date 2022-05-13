//
//  ETAWidgetView.swift
//  missthebus widgetExtension
//
//  Created by Matthew Siu on 5/5/2022.
//

import SwiftUI

struct ETAWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 0){
            
            ForEach(entry.etaList){ stop in
                VStack(alignment: .leading, spacing: 0){
                    HStack{
                        Text(stop.busNum)
                            .font(.headline)
                        Spacer()
                        if let eta1 = stop.eta1{
                            Text(eta1)
                                .font(.caption)
                        }
                        if let eta2 = stop.eta2{
                            Text(eta2)
                                .font(.caption)
                        }
                        
                    }
                    .padding(0)
                    HStack(){
                        Text(stop.stopName)
                            .font(.caption2)
                    }
                    Divider()
                }
            }
            .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
            
//            Spacer()
            
            HStack{
                Text("Updates:")
                    .font(.caption2)
                Spacer()
                Text(Utils.convertTime(time: entry.date, toPattern: "HH:mm:ss"))
                    .font(.caption2)
            }
            .padding(.init(top: 5, leading: 10, bottom: 0, trailing: 10))
        }
        .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
        
        
    }
}
