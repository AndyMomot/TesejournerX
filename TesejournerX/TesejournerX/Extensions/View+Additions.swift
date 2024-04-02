//
//  View+Additions.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

//
//  View+Additions.swift
//  Sample Project Renamed
//
//  Created by Andrii Momot on 04.03.2024.
//

import SwiftUI

extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

enum SwipeDirection {
    case left
    case right
}

extension View {
    func swipeGesture(onEnded: @escaping (SwipeDirection) -> Void) -> some View {
        return self.gesture(
            DragGesture(minimumDistance: 50, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width > 0 {
                        onEnded(.right)
                    } else {
                        onEnded(.left)
                    }
                }
        )
    }
}
