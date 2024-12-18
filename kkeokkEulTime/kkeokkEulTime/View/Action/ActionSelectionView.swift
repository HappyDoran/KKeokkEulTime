//
//  ActionSelectionView.swift
//  kkeokkEulTime
//
//  Created by 남유성 on 6/15/24.
//

import SwiftUI

struct ActionSelectionView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                SelectionView(action: ActionModel.all)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "12DE89"), lineWidth: 3)
                        
                    )
                    .padding(.top, 12)
                    .padding(.bottom, 22)
                
                ForEach(ActionModel.details, id: \.selectionTitle) { actionModel in
                    SelectionView(action: actionModel)
                }
            }
            .padding(.horizontal, 16)
        }
        .background(Color(hex: "#323232"))
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("꺾을 시간")
    }
}

extension ActionSelectionView {
    @ViewBuilder
    func SelectionView(action: ActionModel) -> some View {
        Button {
            NavigationManager.shared.push(to: .actionDetail(actionModel: action))
        } label: {
            ZStack {
                Image(action.selectionImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .clipped()
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "505050"),
                        Color(hex: "1B1B1D").opacity(0)
                    ]),
                    startPoint: .leading, endPoint: .trailing
                )
                .cornerRadius(12)
                .frame(width: 285)
                .offset(x: -130)
                
                HStack {
                    Text(action.selectionTitle)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    NavigationStack {
        ActionSelectionView()
    }
    .preferredColorScheme(.dark)
}
