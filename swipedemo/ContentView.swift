import SwiftUI

// Extension for clamping values
extension Int {
    func clamped(to limits: ClosedRange<Int>) -> Int {
        return Swift.min(Swift.max(self, limits.lowerBound), limits.upperBound)
    }
}

// Add this new struct above ContentView
struct BarView: View {
    let index: Int
    
    var body: some View {
        Rectangle()
            .fill(Color(hue: 1,
                       saturation: 0.5,
                       brightness: 0.002 * Double(index)))
            .frame(width: 5)
            .frame(height: (sin(Double(index)/4)+1) * 20)
            .id(index)
            .padding(.leading, 1)
            .animation(.smooth(duration: 1.2, extraBounce: 0.0), value: index)
    }
}
// Add this preference key at the top level of the file
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
// Using GeometryReader
struct ContentView: View {
    @State private var currentIndex: Int? = 0
    private let totalBars = 500
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Current Index: \(currentIndex ?? 0)")
                    .padding()
                
                ZStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        let padding = geometry.size.width / 2
                        HStack(spacing: 0) {
                            Color.clear.frame(width: padding)
                            
                            ForEach(0..<totalBars) { index in
                                BarView(index: index)
                            }
                            
                            Color.clear.frame(width: padding)
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $currentIndex,  anchor: .center)
                    // .scrollTargetBehavior(.viewAligned(limitBehavior: .never))
                    .scrollTargetBehavior( .viewAligned(limitBehavior: .always))
                    // .scrollBounceBehavior(.always)
                    .scrollClipDisabled()
                    
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 1, height: geometry.size.height)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }

                HStack {
                    Text(String(format: "%.2f", progress))
                    Slider(value: Binding(
                        get: { progress },
                        set: { currentIndex = Int($0 * Double(totalBars - 1)) }
                    ))
                    Text(String(format: "%.2f", 1 - progress))
                }
                .padding()
            }
        }
        .frame(height: 300)
    }
    
    private var progress: Double {
        Double(currentIndex ?? 0) / Double(totalBars - 1)
    }
}

// With TabView for paging
struct PagingView: View {
    var body: some View {
        TabView {
            Rectangle()
                .fill(Color.red)
            
            Rectangle()
                .fill(Color.blue)
            
            Rectangle()
                .fill(Color.green)
        }
        .frame(height: 100)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .never))
    }
}

// With custom swipe gesture
struct CustomSwipeView: View {
    @State private var currentIndex = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(0..<3) { index in
                    Rectangle()
                        .fill(index == 0 ? Color.red :
                                index == 1 ? Color.blue : Color.green)
                        .frame(width: geometry.size.width)
                        .overlay(
                            Text("Page \(index + 1)")
                                .foregroundColor(.white)
                        )
                }
            }
            .offset(x: -CGFloat(currentIndex) * geometry.size.width)
            .offset(x: dragOffset)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        let threshold = geometry.size.width * 0.3
                        let newIndex = Int(
                            (-CGFloat(currentIndex) * geometry.size.width - value.translation.width)
                            / geometry.size.width
                        ).clamped(to: 0...2)
                        
                        withAnimation {
                            currentIndex = newIndex
                        }
                    }
            )
        }
        .frame(height: 100)
    }
}

// For easy switching between different implementations
struct SwitchableView: View {
    @State private var selectedImplementation = 0
    
    var body: some View {
        VStack {
            switch selectedImplementation {
            case 0:
                ContentView()
            case 1:
                PagingView()
            case 2:
                CustomSwipeView()
            default:
                ContentView()
            }
            
            Picker("Implementation", selection: $selectedImplementation) {
                Text("ScrollView").tag(0)
                Text("TabView").tag(1)
                Text("Custom").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchableView()
    }
}
