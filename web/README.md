# 📰 테크 블로그 모아보기 서비스 개발자 신문

![readme_mockup2](https://balzanewss.web.app/ogimage.png)

- 웹사이트 배포 URL : https://balzanewss.web.app/

<br>

## 프로젝트 소개
- 개발자 신문은 국내 유명 테크 기업들의 최신 블로그 글들을 볼 수 있는 서비스입니다.
    

<br>

## 1. 개발 환경
- Front : Flutter , JavaScript
- Database : IndexedDB 사용
- 호스팅 : Google Cloud Platform 사용
- 버전 관리 : Github
<br>

## 2. 주요 기능

- 📌 **블로그 북마크 기능 (PWA 지원)**  
  원하는 블로그 글을 저장하고, 언제든지 다시 찾아볼 수 있습니다.  
  PWA로 설치하면 앱처럼 더욱 편리하게 사용할 수 있습니다.

- 📊 **스크롤 인디케이터**  
  블로그 상세 페이지에 스크롤 진행률을 시각적으로 보여주는 인디케이터가 추가되어,  
  글을 얼마나 읽었는지 한눈에 파악할 수 있습니다.

- 🌙 **다크모드 지원**  
  시스템 설정 또는 사용자 설정에 따라 다크모드로 자동 전환되어  
  눈의 피로를 줄여줍니다.


## 3. 화면 구성 💻

| 메인 페이지 | 북마크 목록 페이지 |
|-------------|--------------------|
| <img src="https://github.com/user-attachments/assets/c557657d-48e3-4671-9da2-57f3db4fcfe8" width="300"/> <br> | <img src="https://github.com/user-attachments/assets/cad3d812-4556-41bd-9b94-41db08db8c70" width="300"/> |

| 블로그 상세보기 페이지 
|------------------------------------|
| <img src="https://github.com/user-attachments/assets/9bb85c53-a434-4a02-891b-e0512c94d9b7" width="300"/> <br>| <img src="https://github.com/user-attachments/assets/7b59f3c1-f44e-4179-a86f-f8ed66dae3d9" width="300"/> <br> |



## 4. 프로젝트 진행하며 발생한 이슈
### 1. 플러터 웹 최초 진입 시 폰트 다운로드 이슈

- Flutter Web에서는 첫 진입 시 텍스트 렌더링을 위해 기본적으로 `Roboto` 폰트를 다운로드합니다.  
  한글이 포함된 경우에는 `NotoSansKR`, 이모지가 사용된 경우에는 `NotoEmoji` 폰트까지 추가로 로드됩니다.

- 이로 인해 초기 렌더링 시 최소 수십 ms부터 길게는 **1~2초까지 딜레이**가 발생하는 경우도 확인했습니다.

- 이를 해결하기 위해 `ThemeData` 내 `fontFamilyFallback`을 설정하여  
  **필요한 폰트만 로드되도록 제한**하였고, 프로젝트 내 사용 중인 폰트로만 렌더링되도록 조정했습니다.

- 이를 해결하는 다른 방법으로는 아래 config에 fontFallbackBaseUrl을 설정하여 시간을 단축시킬수 있지만 추천 드리지 않습니다..
기존에 ttf를 다운 받는 것에서 분할된 woff2를 받는것으로 변경되었고, 분할된 파일들 중 어떤 파일을 다운 받을지 모르기 때문에 무한 에러가 발생할수 있습니다.(경험을 이미 해봤었습니다)  
```dart
_flutter.loader.load({
    onEntrypointLoaded: async function (engineInitializer) {
        const config = {
            fontFallbackBaseUrl: "./",
            canvasKitBaseUrl: "./canvaskit/",
        };
        const appRunner = await engineInitializer.initializeEngine(config);

        appRunner.runApp().then((_) => {
        });
    }
});
```


### 2. IOS Safari에서 스와이프로 화면 이탈시 이전 화면이 두 개 보이는 이슈


### 3. IOS Swipe로 Iframe 화면 이탈시 Iframe 깜빡이는 이슈


### 4. IFrameElement 내부 document에 이벤트 리스너 추가하기
- IframeElement에 스크롤을 감지하기 위해 아래와 같이 해당 위젯에 listener를 추가했지만 실패했습니다.
```dart
html.IFrameElement _iFrameElement = html.IFrameElement();
 _iFrameElement.onScroll.listen((event){});
```
- IFrameElement의 src / srcdoc에 부여한 주소가 현재 웹사이트와 Same Origin이 아니기에 위의 Listener가 정상 동작하지 않았습니다.

- 이를 해결하기 위해 자체적으로 Proxy서버를 구축했고, 해당 서버를 거친 이후에
위와 같이 Listener를 할당해서 확인했지만 이 또한 성공하지 못했습니다.

결국 srcDoc로 설정할 html 내부의 body에 eventListener를 추가했고,
Iframe 내부에서 스크롤이 발생했을때 아래와 같이 부모에게 스크롤 관련 정보를 포함하여 메세지를 보내도록 했습니다.

```dart
window.addEventListener('scroll', () => {
        const scrollTop = window.scrollY || document.documentElement.scrollTop;
        const scrollHeight = document.documentElement.scrollHeight;
        const clientHeight = window.innerHeight;

        const scrollPercentage = Math.min(100,
          Math.round((scrollTop / (scrollHeight - clientHeight)) * 100)
        );

        parent.postMessage({
          type: 'scroll',
          y: scrollTop,
          scrollPercentage: scrollPercentage
        }, '*');
      });

String htmlWithScript = body.replaceFirst(
        RegExp(r'</body>', caseSensitive: false),
        '$injectionScript</body>',
);

html.IFrameElement _iFrameElement = html.IFrameElement();
 _iFrameElement.srcDoc = htmlWithScript;
```
그리고 아래와 같이 플러터쪽에서 관련해서 메세지를 받았을 경우 
관련하여 처리하도록 했습니다.

```dart
 _messageSub = html.window.onMessage.listen((event) {
      final data = event.data;
      if (data is Map && data['type'] == 'scroll') {
        scrollPercentage.value =
            (data['scrollPercentage'] as num).toDouble() / 100;
      }
    });
```







