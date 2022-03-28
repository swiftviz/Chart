//
//  Chart.swift
//
//
//  Created by Joseph Heck on 3/25/22.
//

import SwiftUI

public struct Chart<Content: View>: View {
    var content: () -> Content

    public var body: some View {
        content()
        // if Mark returns a view, then we'll likely assemble these
        // as a ZStack, otherwise we'll need to update the generic signature
        // to accept a list of [Mark] instances that we compose directly
        // onto an instance of Canvas()
    }

    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
}
