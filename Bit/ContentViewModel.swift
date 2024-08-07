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
    @Published var isDragging = false
    @Published var draggedColor: Color?
    let buttonColors: [Color] = [.skyBlue, .hotPink, .brightYellow, .limeGreen, .vibrantOrange]
    
    func addWidget(color: Color, position: CGPoint, size: CGSize) {
        let newWidget = Widget(id: UUID(), color: color, position: position, size: size)
        widgets.append(newWidget)
    }
    
    func dragging(_ widget: Widget, to location: CGPoint) {
        if let index = widgets.firstIndex(where: { $0.id == widget.id }) {
            widgets[index].position = location
        }
    }
    
    func drop(_ widget: Widget, at location: CGPoint, in rectangleFrame: CGRect) {
        if let index = widgets.firstIndex(where: { $0.id == widget.id }) {
            let adjustedLocation = CGPoint(x: rectangleFrame.width / 2, y: rectangleFrame.height / 2)
            if rectangleFrame.contains(location) {
                widgets[index].position = adjustedPosition(for: widget, at: adjustedLocation, in: rectangleFrame.size)
                widgets[index].size = CGSize(width: rectangleFrame.width, height: rectangleFrame.height)
            } else {
                widgets.remove(at: index)
            }
        }
    }
    
    func draggingNewWidget(color: Color, at location: CGPoint) {
        draggedWidget = Widget(id: UUID(), color: color, position: location, size: CGSize(width: 50, height: 50))
        draggedColor = color
        isDragging = true
    }
    
    func dropNewWidget(color: Color, at location: CGPoint, in rectangleFrame: CGRect) {
        if let widget = draggedWidget {
            let adjustedLocation = CGPoint(x: rectangleFrame.width / 2, y: rectangleFrame.height / 2)
            if rectangleFrame.contains(location) {
                let newPosition = adjustedPosition(for: widget, at: adjustedLocation, in: rectangleFrame.size)
                addWidget(color: color, position: newPosition, size: CGSize(width: rectangleFrame.width, height: rectangleFrame.height))
            }
            draggedWidget = nil
            draggedColor = nil
            isDragging = false
        }
    }
    
    private func adjustedPosition(for widget: Widget, at location: CGPoint, in layoutSize: CGSize) -> CGPoint {
        // Adjust position to ensure the widget is fully within the drop area
        var newPosition = location
        let widgetSize: CGFloat = 100
        let layoutWidth = layoutSize.width
        let layoutHeight = layoutSize.height
        
        newPosition.x = layoutWidth / 2
        newPosition.y = layoutHeight / 2
        
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
    var size: CGSize
    var view: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(color)
            .shadow(color: .black.opacity(0.5), radius: 10, x: 2, y: 2)
    }
    
    var frame: CGRect {
        CGRect(x: position.x - size.width / 2, y: position.y - size.height / 2, width: size.width, height: size.height)
    }
}
