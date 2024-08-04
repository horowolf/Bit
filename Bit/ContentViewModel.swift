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
    @Published var draggedWidget: Widget?
    let buttonColors: [Color] = [.blue, .pink, .yellow, .green, .orange]
    
    func addWidget(color: Color, position: CGPoint) {
        let newWidget = Widget(id: UUID(), color: color, position: position)
        widgets.append(newWidget)
    }
    
    func dragging(_ widget: Widget, to location: CGPoint) {
        if let index = widgets.firstIndex(where: { $0.id == widget.id }) {
            widgets[index].position = location
        }
    }
    
    func drop(_ widget: Widget, at location: CGPoint) {
        if let index = widgets.firstIndex(where: { $0.id == widget.id }) {
            let dropArea = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300)
            if dropArea.contains(location) {
                widgets[index].position = adjustedPosition(for: widget, at: location)
            } else {
                widgets.remove(at: index)
            }
        }
    }
    
    func draggingNewWidget(color: Color, at location: CGPoint) {
        draggedWidget = Widget(id: UUID(), color: color, position: location)
        print("position: \(location)")
    }
    
    func dropNewWidget(color: Color, at location: CGPoint) {
        if let widget = draggedWidget {
            let dropArea = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300)
            if dropArea.contains(location) {
                addWidget(color: color, position: adjustedPosition(for: widget, at: location))
            }
            draggedWidget = nil
        }
    }
    
    private func adjustedPosition(for widget: Widget, at location: CGPoint) -> CGPoint {
        // Adjust position to ensure the widget is fully within the drop area
        var newPosition = location
        let widgetSize: CGFloat = 100
        let layoutWidth = UIScreen.main.bounds.width
        let layoutHeight: CGFloat = 300
        
        newPosition.x = max(widgetSize / 2, min(newPosition.x, layoutWidth - widgetSize / 2))
        newPosition.y = max(widgetSize / 2, min(newPosition.y, layoutHeight - widgetSize / 2))
        
        // Avoid overlapping with other widgets
        for otherWidget in widgets {
            if widget.id != otherWidget.id && otherWidget.frame.intersects(CGRect(x: newPosition.x - widgetSize / 2, y: newPosition.y - widgetSize / 2, width: widgetSize, height: widgetSize)) {
                newPosition.y += widgetSize
            }
        }
        
        return newPosition
    }
}

struct Widget: Identifiable {
    let id: UUID
    let color: Color
    var position: CGPoint
    var view: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(color)
            .shadow(color: .black.opacity(0.5), radius: 10, x: 2, y: 2)
    }
    
    var frame: CGRect {
        CGRect(x: position.x - 50, y: position.y - 50, width: 100, height: 100)
    }
}
