import SwiftUI

public struct Chart<Content: View>: View {

    var content: () -> Content
    
    public var body: some View {
        content()
    }
    
    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
}
