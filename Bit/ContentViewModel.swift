//
//  ContentViewModel.swift
//  Bit
//
//  Created by horo on 8/2/24.
//

import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    @Published var widgets: [Widget] = []
    let buttonColors: [Color] = [.blue, .pink, .yellow, .green, .orange]
    
    func addWidget(color: Color) {
        let newWidget = Widget(id: UUID(), color: color, position: CGPoint(x: 50, y: 50))
        widgets.append(newWidget)
    }
    
    func dragging(_ widget: Widget, to location: CGPoint) {
        if let index = widgets.firstIndex(where: { $0.id == widget.id }) {
            widgets[index].position = location
        }
    }
    
    func drop(_ widget: Widget, at location: CGPoint) {
        // Ensure the widget fits within the layout area
        if let index = widgets.firstIndex(where: { $0.id == widget.id }) {
            let adjustedLocation = CGPoint(x: min(max(location.x, 50), UIScreen.main.bounds.width - 50),
                                           y: min(max(location.y, 50), 300 - 50))
            widgets[index].position = adjustedLocation
        }
    }
}

struct Widget: Identifiable {
    let id: UUID
    let color: Color
    var position: CGPoint
    var view: some View {
        RoundedRectangle(cornerRadius: 36)
            .fill(color)
            .frame(width: 100, height: 100)
            .shadow(color: .black.opacity(0.5), radius: 10, x: 2, y: 2)
    }
}
