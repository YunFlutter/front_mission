아래는 **Markdown 문법에 맞게 정리된 전체 내용**입니다.
👉 그대로 **복사해서 `README.md`에 붙여넣기** 하시면 됩니다.

````markdown
# 📘 Front Mission - Flutter Application

이 프로젝트는 **Flutter**를 사용하여 개발된 게시판 애플리케이션입니다.  
**Riverpod**을 이용한 상태 관리, **Dio**를 이용한 네트워크 통신(Interceptor 포함),  
그리고 **MVVM 아키텍처**를 기반으로 구현되었습니다.

---

## 🛠️ 개발 환경 및 요구사항 (Prerequisites)

이 프로젝트를 실행하기 위해 다음 도구들이 설치되어 있어야 합니다.

- **Flutter SDK**: 3.32.8 (Stable Channel 권장)
- **Dart SDK**: 3.8.1
- **Android Studio** 또는 **VS Code**
- **Xcode** (iOS 시뮬레이터 실행 시, macOS 필요)

---

## 🚀 설치 및 실행 가이드 (Installation & Run)

### 🛑 매우 중요 (Critical Check)

이 프로젝트는 **Freezed**와 **Riverpod Generator**를 사용하여 코드를 생성합니다.  
반드시 **3. 코드 생성** 단계를 수행해야 앱이 정상적으로 실행됩니다.

---

### 1. 프로젝트 클론 (Clone)

터미널을 열고 소스 코드를 내려받거나 압축을 해제한 폴더로 이동합니다.

```bash
git clone [레포지토리 주소]
cd [프로젝트 폴더명]
````

---

### 2. 의존성 패키지 설치 (Install Dependencies)

프로젝트 실행에 필요한 라이브러리들을 다운로드합니다.

```bash
flutter pub get
```

---

### 3. 코드 생성 (Code Generation) ★ 필수 단계

이 단계를 건너뛰면
`Target of URI doesn't exist`, `Undefined class` 등의 컴파일 에러가 발생합니다.

아래 명령어를 실행하여 `*.g.dart`, `*.freezed.dart` 파일을 생성해주세요.

```bash
dart run build_runner build -d
```

* `-d` 옵션은 기존 생성 파일과 충돌 시 삭제 후 재생성합니다.

---

### 4. iOS 실행 환경 설정 (macOS Only)

iOS 시뮬레이터에서 실행할 경우 **CocoaPods** 설치가 필요합니다.
(Android만 실행할 경우 이 단계는 생략하세요.)

```bash
cd ios
pod install
cd ..
```

---

### 5. 앱 실행 (Run App)

디바이스(시뮬레이터 또는 실기기)를 연결한 후 앱을 실행합니다.

```bash
flutter run
```

---

## 🏗️ 프로젝트 구조 (Architecture)

기능 단위(Feature-first)와 계층형 아키텍처를 혼합하여 유지보수성을 높였습니다.

```text
lib/
├── core/               # 앱 전역 설정 및 유틸리티
│   ├── config/         # API URL 등 앱 설정 (AppConfig)
│   ├── network/        # Dio 설정, Interceptor (Token 자동 주입/갱신)
│   └── utils/          # Validator, FileCompressor 등
├── data/               # 데이터 계층
│   ├── model/          # 데이터 모델 (Freezed 불변 객체)
│   ├── repository/     # API 통신 로직 (Dio)
│   └── service/        # 로컬 스토리지 서비스 (SecureStorage)
├── provider/           # 전역 상태 관리 (Riverpod Providers)
└── ui/                 # 화면 및 뷰 컨트롤러 (Presentation Layer)
    ├── auth/           # 로그인, 회원가입
    ├── post/           # 게시글 목록, 상세, 작성, 수정
    └── common/         # 공통 위젯 (UserInfo, ResponsiveLayout 등)
```

---

## ✨ 주요 기능 (Features)

### 1. 인증 (Authentication)

* **회원가입 / 로그인**

    * 이메일 형식, 비밀번호 복잡성 등 엄격한 유효성 검사
* **자동 로그인**

    * `FlutterSecureStorage`를 사용하여 토큰 안전하게 저장
* **토큰 갱신 (Silent Refresh)**

    * API 요청 중 `401 Unauthorized` 또는 `403 Unauthorized` 발생 시
      `Dio Interceptor`가 Refresh Token을 사용해 Access Token 갱신 후 요청 재전송

---

### 2. 게시판 (Board)

* **목록 조회**

    * `NotificationListener` 기반 페이지네이션 (Infinite Scroll)
* **상세 조회**

    * 게시글 내용 확인 및 본인 권한에 따른 수정/삭제 버튼 노출
* **글 작성 / 수정**

    * 파일 첨부: 일반 파일 및 이미지 지원
    * 이미지 압축: `flutter_image_compress` 사용
      (1MB 초과 이미지 자동 압축)
    * MimeType 처리:
      `application/json` 및 파일별 정확한 MimeType 전송
* **글 삭제**

    * 삭제 전 확인 다이얼로그 제공

---

## ❓ 트러블슈팅 (Troubleshooting)

### Q. `Build failed` 또는 `Undefined class` 에러가 발생합니다.

**A.** 코드 생성이 되지 않은 상태입니다.
프로젝트 루트에서 아래 명령어를 실행하세요.

```bash
dart run build_runner build -d
```

---

### Q. iOS 실행 시 CocoaPods 관련 에러가 발생합니다.

**A.** `ios` 폴더로 이동하여 팟파일을 업데이트하세요.

```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install --repo-update
cd ..
```

---

### Q. 401 에러가 계속 발생합니다.

**A.** 저장된 토큰이 만료되었거나 손상되었을 수 있습니다.
앱 데이터를 삭제하거나 로그아웃 후 다시 로그인해주세요.

---

## 📝 사용된 라이브러리 (Dependencies)

* **State Management**: `flutter_riverpod`, `riverpod_annotation`
* **Network**: `dio`
* **Data Class & Code Gen**: `freezed_annotation`, `json_annotation`, `build_runner`
* **Storage**: `flutter_secure_storage`
* **Utils**:

    * `file_picker` (파일 선택)
    * `flutter_image_compress` (이미지 압축)
    * `mime` (MimeType 감지)
    * `jwt_decoder` (JWT 파싱)

---

**제출일**: 2026. 01. 17.

