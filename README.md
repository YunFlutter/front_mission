# Front Mission — 인증·게시판 Flutter 애플리케이션

Riverpod과 MVVM 구조로 구현한 게시판 애플리케이션입니다. 인증 토큰 관리부터 게시글 CRUD, 파일 업로드, 무한 스크롤까지 실제 서비스에서 자주 마주치는 흐름을 구현했습니다.

> 이 저장소는 빅스페이먼츠 사전 과제로 제출한 프로젝트입니다. 제출일: 2026. 01. 17.

## 핵심 구현

- 회원가입·로그인 입력값 검증 및 인증 상태 관리
- `FlutterSecureStorage`를 이용한 Access Token·Refresh Token 저장
- `Dio Interceptor` 기반 토큰 자동 주입·갱신·실패 요청 재전송
- 게시글 목록·상세·작성·수정·삭제 구현
- `NotificationListener` 기반 무한 스크롤 구현
- 일반 파일 및 이미지 첨부, 1MB 초과 이미지 자동 압축
- `Freezed`와 `json_serializable`을 이용한 불변 데이터 모델 구성

## 기술 스택

| 구분 | 기술 |
| --- | --- |
| Language | Dart 3.8.1 |
| Framework | Flutter 3.32.8 |
| State Management | Riverpod, Riverpod Generator |
| Network | Dio |
| Model | Freezed, JSON Serializable |
| Local Storage | Flutter Secure Storage |
| File Handling | File Picker, Flutter Image Compress, MIME |

## 설계 판단

### 인증 요청과 일반 요청의 책임 분리

- 인증이 필요 없는 `/auth/signin`, `/auth/signup`, `/auth/refresh` 요청에는 토큰을 주입하지 않도록 분기함
- 일반 요청에는 저장된 Access Token을 자동 주입하여 화면 코드에서 인증 헤더 처리를 제거함
- `401` 또는 `403` 응답 시 Refresh Token으로 Access Token을 갱신하고 기존 요청을 재전송함

### 파일 업로드 요청 재시도 처리

- `FormData`의 파일 스트림은 한 번 소비되면 그대로 재사용할 수 없음
- 토큰 갱신 후 재시도할 때 필드와 파일을 복제한 새 `FormData`를 생성하도록 처리함

### UI와 데이터 접근 로직 분리

- UI는 화면 표시와 사용자 입력에 집중하도록 구성함
- Repository에서 API 통신을 담당하고 Provider·Controller에서 화면 상태를 관리함
- Freezed 모델을 사용하여 서버 응답 모델의 불변성과 직렬화 규칙을 명확히 함

## 프로젝트 구조

```text
lib/
├── core/
│   ├── config/        # API 및 앱 설정
│   ├── network/       # Dio, 인증 Interceptor
│   └── utils/         # 입력값 검증, 이미지 압축
├── data/
│   ├── model/         # Freezed 데이터 모델
│   ├── repository/    # 인증·게시글 API 통신
│   └── service/       # Secure Storage
├── provider/          # 인증·게시글 상태 관리
└── ui/
    ├── auth/          # 로그인·회원가입
    ├── post/          # 목록·상세·작성·수정
    └── common/        # 공통 UI
```

## 주요 사용자 흐름

### 인증

1. 이메일·비밀번호·이름 입력값 검증
2. 로그인 성공 시 토큰을 Secure Storage에 저장
3. 이후 API 요청에 Access Token 자동 추가
4. 인증 만료 응답 시 토큰 갱신 후 기존 요청 재전송

### 게시글

1. 목록 조회 및 스크롤 하단 도달 시 다음 페이지 요청
2. 상세 화면에서 작성자 권한에 따라 수정·삭제 버튼 노출
3. 글 작성·수정 시 일반 파일 또는 이미지 첨부
4. 1MB 초과 이미지는 압축한 뒤 MIME type과 함께 전송

## 테스트 및 품질 검사

현재 이메일·이름·비밀번호 검증 로직의 정상·경계·실패 입력을 단위 테스트합니다. GitHub Actions에서 정적 분석과 테스트를 자동 실행합니다.

```bash
flutter analyze --no-fatal-infos
flutter test
```

## 실행 방법

### 1. 저장소 복제

```bash
git clone https://github.com/YunFlutter/front_mission.git
cd front_mission
```

### 2. 의존성 설치 및 코드 생성

```bash
flutter pub get
dart run build_runner build -d
```

### 3. iOS 의존성 설치

```bash
cd ios
pod install
cd ..
```

### 4. 앱 실행

```bash
flutter run
```

> 인증과 게시글 기능을 확인하려면 과제용 API 서버에 연결할 수 있는 환경이 필요합니다.

## 향후 개선

- Dio 인증 Interceptor의 토큰 갱신·동시 요청 시나리오 테스트 추가
- Repository 성공·실패 응답 테스트 추가
- 주요 인증·게시글 화면의 Widget 테스트 추가
- 실행 화면과 사용자 흐름 GIF 추가
