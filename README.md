# SwiftUI Scroll View Demo

A demonstration project showcasing different scrolling and paging implementations in SwiftUI, with a focus on horizontal scrolling behaviors and animations.

## Features

### 1. Advanced ScrollView Implementation
- Horizontal scrolling with centered content
- Dynamic bar visualization with smooth animations
- Scroll position tracking
- View-aligned scrolling behavior
- Interactive slider control for precise navigation

### 2. Multiple View Types

The project includes three different implementation approaches:

#### ScrollView Implementation (`ContentView`)
- Custom horizontal scrolling with centered content
- Animated bars with dynamic heights and colors
- Real-time index tracking
- Slider control for manual navigation
- View alignment with `.scrollTargetBehavior`
- Center indicator line

#### TabView Implementation (`PagingView`)
- Built-in SwiftUI paging
- Page style navigation
- Simple page indicator
- Smooth transitions between pages

#### Custom Swipe Implementation (`CustomSwipeView`)
- Custom gesture-based navigation
- Drag gesture with threshold detection
- Smooth animations
- Value clamping for boundaries

## Technical Highlights
### Scroll Position Tracking
```swift
.scrollPosition(id: $currentIndex, anchor: .center)
.scrollTargetBehavior(.viewAligned(limitBehavior: .always))
```

### Custom Bar Visualization
```swift
struct BarView: View {
    let index: Int
    var body: some View {
        Rectangle()
            .fill(Color(hue: 1,
                saturation: 0.5,
                brightness: 0.002 Double(index)))
            .frame(width: 5)
            .frame(height: (sin(Double(index)/4)+1) 20)
            .animation(.smooth(duration: 1.2, extraBounce: 0.0), value: index)
    }
}
```

### Progress Tracking
- Real-time progress calculation
- Two-way binding between slider and scroll position
- Formatted progress display

## Usage

The demo includes a segmented control to switch between different implementations:
1. **ScrollView**: Advanced implementation with dynamic bars
2. **TabView**: Simple paging with SwiftUI's built-in TabView
3. **Custom**: Gesture-based custom implementation

## Key SwiftUI Features Demonstrated

- `.scrollTargetLayout()`
- `.scrollPosition()`
- `.scrollTargetBehavior()`
- `.scrollClipDisabled()`
- Gesture handling
- Animations
- GeometryReader usage
- Custom PreferenceKey
- Value clamping
- Two-way bindings

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Implementation Notes

- The main ScrollView implementation uses modern SwiftUI scrolling APIs
- Custom animations provide smooth transitions
- Gesture handling includes velocity-based calculations
- View alignment ensures precise positioning
- Progress tracking is normalized between 0 and 1

