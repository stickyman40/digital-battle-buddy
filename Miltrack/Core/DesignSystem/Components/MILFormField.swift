//
//  MILFormField.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct MILFormField: View {
    enum Style {
        case text
        case number
        case picker
        case secure
    }
    
    let title: String
    let placeholder: String
    let style: Style
    let options: [String]?
    @Binding var value: String
    @State private var isSecureTextVisible = false
    
    init(
        title: String,
        placeholder: String = "",
        style: Style = .text,
        value: Binding<String>,
        options: [String]? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self.style = style
        self._value = value
        self.options = options
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: MILSpacing.sm) {
            // Label
            Text(title)
                .milTypography(.subheadline, weight: .medium)
                .foregroundColor(MILColors.textPrimary)
            
            // Input Field
            Group {
                switch style {
                case .text:
                    TextField(placeholder, text: $value)
                        .textFieldStyle(MILTextFieldStyle())
                    
                case .number:
                    TextField(placeholder, text: $value)
                        .keyboardType(.numberPad)
                        .textFieldStyle(MILTextFieldStyle())
                    
                case .secure:
                    HStack {
                        if isSecureTextVisible {
                            TextField(placeholder, text: $value)
                        } else {
                            SecureField(placeholder, text: $value)
                        }
                        
                        Button(action: {
                            isSecureTextVisible.toggle()
                        }) {
                            Image(systemName: isSecureTextVisible ? "eye.slash" : "eye")
                                .foregroundColor(MILColors.textTertiary)
                        }
                    }
                    .textFieldStyle(MILTextFieldStyle())
                    
                case .picker:
                    Menu {
                        if let options = options {
                            ForEach(options, id: \.self) { option in
                                Button(option) {
                                    value = option
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(value.isEmpty ? placeholder : value)
                                .foregroundColor(value.isEmpty ? MILColors.textTertiary : MILColors.textPrimary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(MILColors.textTertiary)
                        }
                        .milPadding(.horizontal, MILSpacing.md)
                        .milPadding(.vertical, MILSpacing.md)
                        .background(MILColors.backgroundSecondary)
                        .milCornerRadius(MILRadii.input)
                        .overlay(
                            RoundedRectangle(cornerRadius: MILRadii.input)
                                .stroke(MILColors.borderSecondary, lineWidth: 1)
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Custom TextField Style
struct MILTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .milPadding(.horizontal, MILSpacing.md)
            .milPadding(.vertical, MILSpacing.md)
            .background(MILColors.backgroundSecondary)
            .milCornerRadius(MILRadii.input)
            .overlay(
                RoundedRectangle(cornerRadius: MILRadii.input)
                    .stroke(MILColors.borderSecondary, lineWidth: 1)
            )
    }
}

#Preview {
    VStack(spacing: MILSpacing.lg) {
        MILFormField(
            title: "Email",
            placeholder: "Enter your email",
            style: .text,
            value: .constant("")
        )
        
        MILFormField(
            title: "Password",
            placeholder: "Enter your password",
            style: .secure,
            value: .constant("")
        )
        
        MILFormField(
            title: "Age",
            placeholder: "Enter your age",
            style: .number,
            value: .constant("")
        )
        
        MILFormField(
            title: "Branch",
            placeholder: "Select your branch",
            style: .picker,
            value: .constant(""),
            options: ["Army", "Navy", "Air Force", "Marines", "Space Force", "Coast Guard"]
        )
    }
    .milPadding()
    .background(MILColors.backgroundPrimary)
}
