//
//  ContentView.swift
//  QuickAPNS
//
//  Created by Xavier on 2024-07-14.
//

import SwiftUI

struct NotificationTextFieldStyle: TextFieldStyle {
    @State private var hovering = false
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textFieldStyle(.plain)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
    }
}

extension TextFieldStyle where Self == NotificationTextFieldStyle {
    static var notification: NotificationTextFieldStyle { .init() }
}

struct ContentView: View {
    let TITLE_PROMPT = "Title"
    let SUBTITLE_PROMPT = "Subtitle"
    let BODY_PROMPT = "Body"
    
    @State private var bundleIdInput = ""
    @State private var titleInput = "Game Request"
    @State private var subtitleInput = "Five Card Draw"
    @State private var bodyInput = "Bob wants to play poker"
    
    @State private var showSubtitle = false
    @State private var showImage = false
    
    @State private var hoverDragButton = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                form
                    .frame(idealWidth: 382)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(spacing: 20) {
                    preview
                    dragButton
                }
                .fixedSize(horizontal: true, vertical: true)
                .padding(.bottom, 20)
            }
            .fixedSize(horizontal: true, vertical: true)
            .scrollDisabled(true)
        }
    }
    
    
    var preview: some View {
        HStack(spacing: 14) {
            appIcon
            VStack(alignment: .leading, spacing: 1.5) {
                HStack(alignment: .top) {
                    TextField("", text: $titleInput, prompt: Text(TITLE_PROMPT))
                        .textFieldStyle(.plain)
                        .font(.headline)
                    Spacer()
//                    Text("now")
//                        .foregroundStyle(.secondary)
//                        .font(.callout)
                }
                if showSubtitle {
                    TextField("", text: $subtitleInput, prompt: Text(SUBTITLE_PROMPT))
                        .textFieldStyle(.plain)
                        .font(.headline)
                }
                
                TextField("", text: $bodyInput, prompt: Text(BODY_PROMPT), axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(2)
            }
            .frame(width: 260)
        }
        .padding(14)
        .background(Color(.windowBackgroundColor), in: .rect(cornerRadius: 24))
    }
    
    var appIcon: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.blue)
            .frame(width: 38, height: 38)
            .overlay {
                Image(systemName: "app.dashed")
                    .font(.title)
                    .foregroundStyle(.white)
            }
    }
    
    var dragPreview: some View {
        HStack(spacing: 14) {
            appIcon
            VStack(alignment: .leading, spacing: 1.5) {
                HStack {
                    Text(titleInput == "" ? " " : titleInput)
                        .font(.headline)
                    Spacer()
//                    Text("now")
//                        .foregroundStyle(.secondary)
                }
                if showSubtitle && subtitleInput != "" {
                    Text(subtitleInput)
                        .font(.headline)
                }
                
                if bodyInput != "" {
                    Text(bodyInput)
                        .lineLimit(2)
                }
            }
            .frame(width: 260)
        }
        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        .padding(14)
        .background(Color(.windowBackgroundColor), in: .rect(cornerRadius: 22))
    }
    
    var dragButtonIcon: some View {
        VStack(spacing: 3) {
            RoundedRectangle(cornerRadius: 4)
                .frame(height: 1)
            RoundedRectangle(cornerRadius: 4)
                .frame(height: 1)
            RoundedRectangle(cornerRadius: 4)
                .frame(height: 1)
        }
        .frame(width: 10)
    }
    
    var dragButton: some View {
        HStack(spacing: 12) {
            dragButtonIcon
                .opacity(0.2)
            Text("Drag me")
            dragButtonIcon
                .opacity(0.2)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background {
            Color(.textBackgroundColor)
                .clipShape(.rect(cornerRadius: 4))
                .shadow(color: .black.opacity(0.25), radius: 1, y: 0.5)
            
        }
        .onHover(perform: { hovering in
            hoverDragButton = hovering
        })
        .draggable(
            Notification(
                bundle: bundleIdInput,
                title: titleInput,
                subtitle: showSubtitle ? subtitleInput : nil,
                body: bodyInput
            )
        ) {
            dragPreview
        }
        
    }
    
    var form: some View {
        Form {
            Section {
                TextField("Bundle", text: $bundleIdInput, prompt: Text("com.company.appname"))
                    .overlay {
                        Color.clear
                            .dropDestination(for: String.self) { _, _ in
                                false
                            }
                    }
            }
            
//            Section {
//                Toggle("Subtitle", isOn: $showSubtitle.animation())
//                    .controlSize(.small)
//                HStack {
//                    Text("Image")
//                    Spacer()
//                    Button("Choose...") {}
//                        .tint(.red)
//                }
//            }
        }
        .autocorrectionDisabled()
        .formStyle(.grouped)
    }
}

#Preview {
    ContentView()
}
