//
//  ContentView.swift
//  Bit
//
//  Created by horo on 8/2/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack { // 使用 ZStack 包住整個視圖
            VStack {
                Spacer()
                
                // Layout area for widgets
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 300)
                        .border(Color.gray, width: 2)
                        .overlay(
                            ForEach(viewModel.widgets) { widget in
                                widget.view
                                    .frame(width: 100, height: 100)
                                    .position(widget.position)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { gesture in
                                                viewModel.dragging(widget, to: gesture.location)
                                            }
                                            .onEnded { gesture in
                                                viewModel.drop(widget, at: gesture.location)
                                            }
                                    )
                            }
                        )
                    
                    Text("👋 Hi! Drag and drop your widgets to unleash your creativity!")
                        .font(.headline)
                        .foregroundColor(Color.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                }
                .padding()
                
                Spacer()
                
                // Draggable widgets at the bottom
                HStack {
                    ForEach(viewModel.buttonColors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 50, height: 50)
                            .gesture(
                                DragGesture(coordinateSpace: .named("full screen"))
                                    .onChanged { gesture in
                                        viewModel.draggingNewWidget(color: color, at: gesture.location)
                                    }
                                    .onEnded { gesture in
                                        viewModel.dropNewWidget(color: color, at: gesture.location)
                                    }
                            )
                    }
                }
                .padding(.bottom)
            }
            
            // Display the dragged widget on top of everything
            if let draggedWidget = viewModel.draggedWidget {
                draggedWidget.view
                    .frame(width: 50, height: 50)
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
