//
//  ContentView.swift
//  Bit
//
//  Created by horo on 8/2/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    @State private var rectangleFrame: CGRect = .zero
    
    var body: some View {
        ZStack { // 使用 ZStack 包住整個視圖
            VStack {
                Spacer()
                
                // Layout area for widgets
                ZStack {
                    VStack {
                        Text("👋")
                            .font(.system(size: 64))  // 放大 "👋"
                            .padding()
                            .frame(alignment: .center)
                        Text("Hi! Drag and drop your widgets to unleash your creativity!")
                            .font(.headline)
                            .foregroundColor(Color.gray)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.clear)
                        .frame(height: 300)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundColor(.gray)
                        )
                        .background(
                            GeometryReader { geometry in
                                Color.clear.onAppear {
                                    self.rectangleFrame = geometry.frame(in: .named("full screen"))
                                }
                            }
                        )
                        .overlay(
                            ForEach(viewModel.widgets) { widget in
                                widget.view
                                    .frame(width: widget.size.width, height: widget.size.height)
                                    .position(widget.position)
                            }
                        )
                }
                .padding()
                
                Spacer()
                
                // Draggable widgets at the bottom
                ZStack {
                    RoundedRectangle(cornerRadius: 36.0)
                        .fill(Color.white)
                        .frame(height: 72.0)
                        .shadow(radius: 10)
                        .padding()
                    HStack(spacing: 20) {  // 增加 widget 之間的間距
                        ForEach(viewModel.buttonColors, id: \.self) { color in
                            Circle()
                                .fill(color.opacity(viewModel.isDragging && viewModel.draggedColor == color ? 0.2 : 1.0))
                                .frame(width: 50, height: 50)
                                .gesture(
                                    DragGesture(coordinateSpace: .named("full screen"))
                                        .onChanged { gesture in
                                            viewModel.draggingNewWidget(color: color, at: gesture.location)
                                        }
                                        .onEnded { gesture in
                                            viewModel.dropNewWidget(color: color, at: gesture.location, in: rectangleFrame)
                                        }
                                )
                        }
                    }
                }
            }
            
            // Display the dragged widget on top of everything
            if let draggedWidget = viewModel.draggedWidget {
                draggedWidget.view
                    .frame(width: draggedWidget.size.width, height: draggedWidget.size.height)
                    .position(draggedWidget.position)
            }
        }
        .coordinateSpace(.named("full screen"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
