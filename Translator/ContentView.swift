//
//  ContentView.swift
//  Translator
//
//  Created by binee on 2023/05/20.
//

import SwiftUI
import SwiftyJSON
import Alamofire

struct TranslationResponse: Codable {
    let message: TranslationMessage
}

struct TranslationMessage: Codable {
    let result: TranslationResult
}

struct TranslationResult: Codable {
    let translatedText: String
}

enum TranslationDirection {
    case englishToKorean
    case koreanToEnglish
}

struct ContentView: View {
    @State private var inputText = ""
    @State private var translatedText = ""
    @State private var translationDirection: TranslationDirection = .englishToKorean
    
    var body: some View {
        VStack(spacing: 20) {
            Text("네이버 API 번역기")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Picker("번역 방향", selection: $translationDirection) {
                Text("영어 -> 한국어").tag(TranslationDirection.englishToKorean)
                Text("한국어 -> 영어").tag(TranslationDirection.koreanToEnglish)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                TextViewWrapper(text: $inputText, placeholder: "번역할 문장을 입력해주세요.")
                    .frame(height: 100)
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .padding([.trailing,.leading])
            
            HStack {
                Spacer()
                Button(action: { translateText() }) {
                    Text("번역")
                        .font(.system(size: 20))
                        .padding(10)
                        .frame(width: 80, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .padding(.trailing ,20)
            }
            //결과창
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                TranslationResultView(translatedText: $translatedText)
                    .frame(height: 100)
                    .padding()
            }
            .frame(height: 200)
            .padding([.trailing,.leading])
        }
        .padding(.vertical)
    }
    
    
    func translateText() {
        guard let url = URL(string: "https://openapi.naver.com/v1/papago/n2mt") else {
            return
        }
        guard let clientId = Bundle.main.infoDictionary?["API Client ID"] as? String else {
            // API 인증 ID를 찾을 수 없을 때의 처리 로직
            return
        }
        guard let clientKey = Bundle.main.infoDictionary?["API Client Key"] as? String else {
            // API 인증 Key를 찾을 수 없을 때의 처리 로직
            return
        }
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
            "X-Naver-Client-Id": clientId,
            "X-Naver-Client-Secret": clientKey
        ]
        
        let sourceLanguage = translationDirection == .englishToKorean ? "en" : "ko"
        let targetLanguage = translationDirection == .englishToKorean ? "ko" : "en"
        let parameters = "source=\(sourceLanguage)&target=\(targetLanguage)&text=" + inputText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = parameters.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(TranslationResponse.self, from: data) {
                DispatchQueue.main.async {
                    translatedText = decodedResponse.message.result.translatedText
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
