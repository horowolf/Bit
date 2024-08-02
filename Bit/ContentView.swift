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
        VStack {
            // Initial greeting message
            Text("👋 Hi! Drag and drop your widgets to unleash your creativity!")
                .font(.headline)
                .foregroundColor(Color.gray)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
            
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
            }
            .padding()
            
            Spacer()
            
            // Buttons at the bottom
            HStack {
                ForEach(viewModel.buttonColors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            viewModel.addWidget(color: color)
                        }
                }
            }
            .padding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
