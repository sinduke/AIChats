//
//  CreateAvatarView.swift
//  AIChats
//
//  Created by sinduke on 12/17/25.
//

import SwiftUI

struct CreateAvatarView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AIManager.self) private var aiManager
    @State private var avatarName: String = ""
    @State private var characterOption: CharacterOption = .default
    @State private var characterAction: CharacterAction = .default
    @State private var characterLocation: CharacterLocation = .default
    @State private var isGenerating: Bool = false
    @State private var generatedImage: UIImage?
    @State private var isSaving: Bool = false
    var body: some View {
        NavigationStack {
            List {
                nameSection
                attributesSection
                imageSection
                saveSection
            }
            .navigationTitle("Create Avatar")
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: {
                    dismissButton
                })
            }
        }
    }
    // MARK: -- Views --
    private var dismissButton: some View {
        Image(systemName: "xmark")
            .font(.title2)
            .fontWeight(.semibold)
            .anyButton(.plain) {
                onDismissButtonTapped()
            }
    }
    
    private var saveSection: some View {
        Section {
            AsyncCallToActionButton(
                isLoading: isSaving,
                title: "Finished",
                action: onSaveButtonTapped
            )
            .opacity(generatedImage == nil ? 0.5 : 1)
            .disabled(generatedImage == nil)
        }
        .removeListRowFormatting()
    }
    
    private var imageSection: some View {
        Section {
            HStack(alignment: .top) {
                ZStack {
                    Text(generatedImage == nil ? "Generate Image" : "Regenerate Image")
                        .underline()
                        .foregroundStyle(.accent)
                        .anyButton {
                            onGenerateImageButtonTapped()
                        }
                        .padding(.leading)
                        .opacity(isGenerating ?  0 : 1)
                        .disabled(isGenerating || avatarName.isEmpty)
                    
                    ProgressView()
                        .opacity(isGenerating ?  1 : 0)
                }
                
                Circle()
                    .fill(.secondary.opacity(0.3))
                    .overlay {
                        ZStack {
                            if let generatedImage {
                                Image(uiImage: generatedImage)
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                    }
                    .clipShape(.circle)
            }
        }
        .removeListRowFormatting()
    }
    
    private var attributesSection: some View {
        Section {
            // Character Option Picker
            Picker(selection: $characterOption) {
                ForEach(CharacterOption.allCases, id: \.self) { option in
                    Text(option.rawValue.capitalized).tag(option)
                }
            } label: {
                Text("Is a... ")
            }
            
            // Character Action Picker
            Picker(selection: $characterAction) {
                ForEach(CharacterAction.allCases, id: \.self) { action in
                    Text(action.rawValue.capitalized).tag(action)
                }
            } label: {
                Text("That is... ")
            }
            
            // Character Location Picker
            Picker(selection: $characterLocation) {
                ForEach(CharacterLocation.allCases, id: \.self) { location in
                    Text(location.rawValue.capitalized).tag(location)
                }
            } label: {
                Text("In the... ")
            }
            
        } header: {
            Text("Attributes")
        }
    }
    
    private var nameSection: some View {
        Section {
            TextField("Player 1", text: $avatarName)
        } header: {
            Text("Name you avatar*")
        }

    }
    
    // MARK: -- Functions --
    private func onDismissButtonTapped() {
        dismiss()
    }
    
    private func onGenerateImageButtonTapped() {
        // Create Image Action
        isGenerating = true
        Task {
            do {
                let prompt = AvatarDescriptionBuilder(
                    characterOption: characterOption,
                    characterAction: characterAction,
                    characterLocation: characterLocation
                )
                .characterDescription
                
                generatedImage = try await aiManager.generateImage(from: prompt)
                
            } catch {
                print("Failed to generate image: \(error.localizedDescription)")
            }
            
            isGenerating = false
        }
    }
    
    private func onSaveButtonTapped() {
        // Create Image Action
        isSaving = true
        Task {
            try? await Task.sleep(for: .seconds(2))
            isSaving = false
            dismiss()
        }
    }

}

#Preview {
    CreateAvatarView()
        .environment(AIManager(service: MockAIService()))
}
