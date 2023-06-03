//
//  TextViewWrapper.swift
//  Translator
//
//  Created by binee on 2023/05/21.
//

import UIKit
import SwiftUI
import SwiftyJSON
import Alamofire

struct TextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    @State private var isEditing: Bool = false
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .gray
        textView.text = placeholder
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if isEditing {
            uiView.text = text
            uiView.textColor = .black
        } else {
            uiView.text = placeholder
            uiView.textColor = .gray
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper
        
        init(_ parent: TextViewWrapper) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.isEditing = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.isEditing = !textView.text.isEmpty
        }
    }
}
