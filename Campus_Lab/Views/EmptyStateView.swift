//
//  EmptyStateView.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-10.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(title: "No books found", systemImage: "book")
    }
}
