//
//  TranslationResultView.swift
//  Translator
//
//  Created by binee on 2023/05/21.
//

import UIKit
import SwiftUI
import SwiftyJSON
import Alamofire

struct TranslationResultView: UIViewRepresentable {
    @Binding var translatedText: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.isEditable = false
        textView.textAlignment = .left
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = translatedText
    }
}
