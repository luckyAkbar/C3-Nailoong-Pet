//
//  PetDetailToolbar.swift
//  NailongPet
//
//  Created by Lucky Akbar on 07/06/26.
//

import SwiftUI

struct PetDetailToolbar: View {
    @State private var isShowingEditModal: Bool = false
    
    var onBack: () -> Void = {}
    var onEdit: () -> Void = {}

    var body: some View {
        ZStack {
            HStack {
                Button(action: onBack) {
                    AppIcon.back.image
                        .font(.calloutBold)
                }
                .buttonStyle(.glass)

                Spacer()
                
                Button(action: {
                    onEdit()
                    isShowingEditModal = true
                }) {
                    Text("Edit")
                }
                .buttonStyle(.glass)
            }

            Text("Pet")
                .font(.title2Bold)
                .foregroundColor(.blackPrimaryText)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .fullScreenCover(isPresented: $isShowingEditModal) {
            EditPetProfileModal()
        }
    }
    
}

struct EditPetProfileModal: View {
    @Environment(\.dismiss) var dismiss
    
    @State var petName = "Moli"
    @State var petDescription = "This is my second pet cat, her name is Moli. The only clear picture I have of her is this, right before she went missing three months ago."
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                HStack{
                    TextField(
                        "Add your pet name here",
                        text: $petName,
                        axis: .horizontal,
                    )
                    
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.brownSecondaryBrand)
                    Spacer()
                }
                .frame(width: 362, height: 44)
                .padding(.bottom, 8)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.brownSecondaryBrand)
                }
                .padding(.top, 15)
                
                VStack (alignment: .leading) {
                    Text("Description")
                        .bold(true)
                    
                    Divider()
                    
                    TextField(
                        "Edit your pet description here",
                        text: $petDescription,
                        axis: .vertical
                    )
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.leading)
                    
                    
                    Spacer()
                }
                .padding(15)
                .frame(width: 362, height: 199, alignment: .leading)
                .background(Color.orangePrimaryBrand)
                .cornerRadius(26)
                .padding(.top, 20)
                
                Spacer()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.subheadBold)
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // Handle save/check action here
                        dismiss()
                    }) {
                        Image(systemName: "checkmark")
                            .font(.subheadBold)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

#Preview {
    PetDetailToolbar()
        .background(Color.beigeTertiaryBrand)
}
