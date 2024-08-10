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
        var newPosition = location
        
        // 初始位置為圓角矩形中心
        newPosition.x = layoutSize.width / 2
        newPosition.y = layoutSize.height / 2

        // 檢查新 widget 是否在已存在的 widget 範圍內
        for otherWidget in widgets {
            if widget.id != otherWidget.id && otherWidget.frame.contains(newPosition) {
                // 根據 newWidget 的位置來決定與 oldWidget 的對齊方式
                if abs(newPosition.x - otherWidget.position.x) > abs(newPosition.y - otherWidget.position.y) { // left or right
                    newPosition.y = otherWidget.position.y
                    balance(y: newPosition.y, layoutSize: layoutSize)
                } else { // top or botton
                    newPosition.x = otherWidget.position.x
                    balance(x: newPosition.x, layoutSize: layoutSize)
                }
            }
        }
        
        return newPosition
    }

    private func balance(x: CGFloat? = nil, y: CGFloat? = nil, layoutSize: CGSize) {
        if let x = x { // top or botton case
            var pickedWidgets = widgets.filter { $0.position.x == x }
            
            // 確保所有 widget 是連接的，計算總高度
            let totalHeight = pickedWidgets.reduce(0) { $0 + $1.size.height }
            let newHeight = layoutSize.height / CGFloat(pickedWidgets.count)
            
            // 調整每個 widget 的中心和大小
            var currentY: CGFloat = 0
            for i in 0..<pickedWidgets.count {
                pickedWidgets[i].size.height = newHeight
                pickedWidgets[i].position.y = currentY + newHeight / 2
                currentY += newHeight
            }
        } else if let y = y { // left or right case
            var pickedWidgets = widgets.filter { $0.position.y == y }
            
            // 確保所有 widget 是連接的，計算總寬度
            let totalWidth = pickedWidgets.reduce(0) { $0 + $1.size.width }
            let newWidth = layoutSize.width / CGFloat(pickedWidgets.count)
            
            // 調整每個 widget 的中心和大小
            var currentX: CGFloat = 0
            for i in 0..<pickedWidgets.count {
                pickedWidgets[i].size.width = newWidth
                pickedWidgets[i].position.x = currentX + newWidth / 2
                currentX += newWidth
            }
        }
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
