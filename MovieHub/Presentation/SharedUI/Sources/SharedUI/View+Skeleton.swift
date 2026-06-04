//
//  View+Skeleton.swift
//  SharedUI
//
//  Created by Antigravity on 04/06/26.
//

import SwiftUI

@available(iOS 14.0, *)
public struct ShimmerModifier: ViewModifier {
    public let isActive: Bool
    public let baseColor: Color
    public let highlightColor: Color
    public let cornerRadius: CGFloat
    
    @State private var phase: CGFloat = 0
    
    public init(
        isActive: Bool,
        baseColor: Color,
        highlightColor: Color,
        cornerRadius: CGFloat
    ) {
        self.isActive = isActive
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.cornerRadius = cornerRadius
    }
    
    public func body(content: Content) -> some View {
        if isActive {
            content
                .redacted(reason: .placeholder)
                .overlay(
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(baseColor)
                            
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [baseColor, highlightColor, baseColor]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width)
                                .offset(x: -geo.size.width + (geo.size.width * 2 * phase))
                        }
                        .clipped()
                    }
                )
                .onAppear {
                    // Start animation immediately
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        phase = 1.0
                    }
                }
        } else {
            content
        }
    }
}

@available(iOS 14.0, *)
public extension View {
    /// Applies a redacted placeholder mask with a sliding shimmer animation to the view when active.
    /// - Parameters:
    ///   - isActive: Condition to determine whether the skeleton shimmer should be shown.
    ///   - baseColor: Base background color of the skeleton.
    ///   - highlightColor: Color of the moving shimmer highlights.
    ///   - cornerRadius: Corner radius of the skeleton masks.
    func shimmeringSkeleton(
        isActive: Bool,
        baseColor: Color = Color(UIColor.systemGray6),
        highlightColor: Color = Color(UIColor.systemGray5),
        cornerRadius: CGFloat = 8
    ) -> some View {
        modifier(
            ShimmerModifier(
                isActive: isActive,
                baseColor: baseColor,
                highlightColor: highlightColor,
                cornerRadius: cornerRadius
            )
        )
    }
}
