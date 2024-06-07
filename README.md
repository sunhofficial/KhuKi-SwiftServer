# KhuKiDDing - 백엔드 (Vapor)

이 프로젝트는 경희대 학생들을 위한 안전하고 진지한 만남의 장, 경희대 CC 앱의 백엔드 서버입니다. Vapor 프레임워크를 사용하여 구축되었습니다.

## 기술 스택

- **프레임워크**: Vapor
- **언어**: Swift
- **데이터베이스**: MongoDB

## 폴더 구조

```plaintext
.
├── Authenticator
├── Config
│   └── ProjectConfig.swift
├── Controllers
│   ├── CookieAPIController.swift
│   ├── SIWAAPIController.swift
│   ├── UserAPIController.swift
│   └── ViewController
│       └── SIWAViewController.swift
├── Extensions+
│   └── Environment+.swift
├── MiddleWares
│   ├── AuthenticationMiddleware.swift
│   └── LogMiddleware.swift
├── Migrations
│   ├── CookieMigration.swift
│   ├── TokenMigration.swift
│   └── UserMigration.swift
├── Models
│   ├── DTO
│   │   ├── GeneralResponse.swift
│   │   ├── GetCookiesResponse.swift
│   │   ├── PickedUserResponse.swift
│   │   ├── PostCookieRequest.swift
│   │   ├── PostPickResponse.swift
│   │   └── UserResponse.swift
│   ├── Entities
│   │   ├── Cookie.swift
│   │   ├── ProfileUpdateRequestFirst.swift
│   │   ├── ProfileUpdateRequestSecond.swift
│   │   ├── Token.swift
│   │   └── User.swift
│   ├── Errors
│   │   ├── CookieError.swift
│   │   └── UserError.swift
│   ├── JWT
│   ├── Movie.swift
│   └── SIWA
│       └── AppleAuthorizationResponse.swift
├── configure.swift
├── entrypoint.swift
└── routes.swift
```
## 주요 기능

### 유저 인증: Apple ID를 통한 로그인 (SIWA)
### 쿠키 관리: 쿠키 생성, 조회, 선택
### 프로필 업데이트: 유저 프로필 정보 업데이트
## 엔드포인트

### 유저 엔드포인트
- **POST /users**: 새로운 유저 생성
- **POST /users/login**: 유저 로그인 (SIWA)

### 쿠키 엔드포인트
- **GET /cookies**: 쿠키 목록 조회
- **POST /cookies**: 새로운 쿠키 생성
- **POST /cookies/pick**: 쿠키 선택

### 프로필 엔드포인트
- **PUT /profile/first**: 프로필 1단계 업데이트
- **PUT /profile/second**: 프로필 2단계 업데이트

## 미들웨어

- **AuthenticationMiddleware**: 요청의 인증을 처리
- **LogMiddleware**: 요청 및 응답 로그 기록

## 마이그레이션

- **CookieMigration**: 쿠키 테이블 생성 및 수정
- **TokenMigration**: 토큰 테이블 생성 및 수정
- **UserMigration**: 유저 테이블 생성 및 수정
