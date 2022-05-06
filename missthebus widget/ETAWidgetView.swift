//
//  ETAWidgetView.swift
//  missthebus widgetExtension
//
//  Created by Matthew Siu on 5/5/2022.
//

import SwiftUI

struct ETAWidgetView: View {
    let etaList = ["277X", "T277", "215X"]

    var body: some View {
        VStack(spacing: 5){
            ForEach(etaList, id: \.self){ eta in
                VStack(alignment: .leading, spacing: 5){
                    HStack{
                        Text(eta)
                            .font(.headline)
                        Spacer()
                        Text("1")
                            .font(.body)
                        Text("12")
                            .font(.caption)
                    }
                    HStack(spacing: 0){
                        Text("AAA stop")
                            .font(.caption2)
                    }
                    Divider()
                }
            }
        }
        .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
        
        
    }
}


//struct ETAWidgetView: View {
//    let name: String
//
//    var body: some View {
//          VStack {
//            Text("Hello! \(name)!")
//              .font(.system(size: 20))
//              .font(.headline)
//              Text("Welcome \(name) with our widget!")
//              .multilineTextAlignment(.center)
//              .padding(.top, 5)
//              .padding([.leading, .trailing])
//      }
//    }
//}

//struct ETAWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        ETAWidgetView(name: "Tony")
//    }
//}
