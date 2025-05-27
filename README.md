# 📰 테크 블로그 모아보기 서비스 개발자 신문

![readme_mockup2](https://balzanewss.web.app/ogimage.png)

- 웹사이트 배포 URL : https://balzanewss.web.app/
- 크롬 익스텐션 : https://chromewebstore.google.com/detail/%EA%B0%9C%EB%B0%9C%EC%9E%90%EC%8B%A0%EB%AC%B8/flliagkdglhpdhlbonapephikpcldimn

<br>

## 프로젝트 소개
- 개발자 신문은 국내 유명 테크 기업들의 최신 블로그 글들을 볼 수 있는 서비스입니다.
- 크롬 익스텐션의 경우 국내뿐만이 아니라 해외 유명 기업들의 블로그 글들도 확인할 수 있습니다.
- 웹 페이지의 경우 PWA로 사용시 북마크 기능을 이용할 수 있습니다.

<br>

## 1. 개발 환경
- Chrome 확장 프로그램
    - Front : Svelte
<br>

- 웹사이트
    - Front : Flutter , JavaScript
    - Database : IndexedDB 사용
    - 호스팅 : Google Cloud Platform 사용
    - 버전 관리 : Github
<br>

## 2. 프로젝트 구조
해당 프로젝트는 크게 4가지로 구분 되어 있다고 볼수 있다.<br>
프로젝트의 파일 구조는 아래와 같다.
```
.
├── README.md
├── server - 배포 및 API 
├── extension - 크롬 확장 프로그램 관련
│   └── src
│       ├── assets
│       ├── background
│       ├── content-scripts
│       ├── options
│       ├── popup
│       ├── sidepanel
│       └── styles
|
└── web - 웹앱 페이지 프론트 관련
```


