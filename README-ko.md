# JavaScript Plugin Container for Swift

## 개요
JavaScript 플러그인 컨테이너는 WKWebView 내의 JavaScript 코드와 Swift 애플리케이션 간의 통신을 용이하게 하는 Swift 기반 라이브러리입니다. 이 라이브러리는 플러그인 아키텍처를 활용하여 Swift 내에서 JavaScript 호출을 구조화하고 동적으로 처리할 수 있도록 합니다.

## 기능
- JavaScript 인터페이스에 대한 동적 플러그인 관리
- WKWebView와의 쉬운 통합
- macOS, iOS, watchOS 및 tvOS 플랫폼 지원
- 플러그인 스캐닝 및 관리를 위한 디버그 유틸리티

## 요구 사항
- iOS 13.0+
- Swift 5.10

## 설치
JavaScript 플러그인 컨테이너를 프로젝트에 통합하려면 제공된 `.swift` 파일을 직접 프로젝트로 복사하거나 Swift 패키지를 생성합니다.

### Swift 패키지 매니저
`Package.swift` 파일에서 이 라이브러리를 의존성으로 추가할 수 있습니다:

```swift
dependencies: [
    .package(url: "https://github.com/minsOne/JSInterfacePluginContainer-iOS.git", from: "1.0.0")
]
```

## 사용법

### 플러그인 정의
사용자 지정 플러그인 클래스에서 `JSInterfacePluggable` 프로토콜을 구현합니다:

```swift
class MyPlugin: JSInterfacePlugin {
    var action: String { "myAction" }

    func callAsAction(_ message: [String: Any], with webView: WKWebView) {
        // 작업 처리
    }
}
```

### 플러그인 관리
`JSInterfaceSupervisor` 인스턴스를 생성하고 플러그인을 관리합니다:

```swift
let supervisor = JSInterfaceSupervisor()
let myPlugin = MyPlugin()
supervisor.loadPlugin(myPlugin)
```

### 작업 처리
들어오는 JavaScript 호출을 처리하려면 `resolve` 함수를 사용합니다:

```swift
supervisor.resolve("myAction", message: ["key": "value"], with: webView)
```

## 디버깅
이 라이브러리에는 DEBUG 플래그로 활성화되는 디버깅 보조 도구가 포함되어 있습니다. 이 도구를 사용하면 등록된 플러그인을 식별하고 올바른 설정을 확인할 수 있습니다.

## 기여하기
JavaScript 플러그인 컨테이너에 대한 기여를 환영합니다. 다음과 같은 방법으로 기여할 수 있습니다:
- 이슈 보고
- 개선 제안
- 버그 수정 또는 새로운 기능을 추가하는 풀 리퀘스트 제출

새로운 기능에 대한 테스트를 작성하고 코딩 표준을 준수하는 것을 잊지 마세요.