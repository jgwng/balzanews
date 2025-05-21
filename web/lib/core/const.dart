String mediumHTML(String htmlContent, double width){
  return '''
<html>
  <head>
    <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <style>
      body {
        margin: 0;
        width: 100vw;
        font-family: 'Roboto', sans-serif;
      }

      h3 {
        font-family: sohne, "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-size: 32px;
        font-weight: 700;
        margin: 1em 0;
        line-height: 38px;
        color: #242424;
      }

      p {
        font-family: source-serif-pro, Georgia, Cambria, "Times New Roman", Times, serif;
        font-size: 18px;
        line-height: 28px;
        font-style: italic;
        margin: 1.56em 0;
        color: #242424;
      }
    </style>
  </head>
  <body>
    $htmlContent
  </body>
</html>

          ''';
}



List techCorps = [
  {
    "id": 7156194000607,
    "name": "무신사(MUSINSA) 기술 블로그",
    "menuName": "무신사",
    "url": "https://medium.com/feed/musinsa-tech",
    "link": "https://medium.com/musinsa-tech",
    "useLink": false,
  },
  {
    "id": 6161576591171,
    "name": "네이버 D2 기술 블로그",
    "menuName": "네이버 D2",
    "url": "https://d2.naver.com/d2.atom",
    "link": "https://d2.naver.com/home",
    "useLink": false,
  },
  {
    "id": 1885857526244,
    "name": "우아한형제들 기술 블로그",
    "menuName": "우아한형제들",
    "url": "https://techblog.woowahan.com/feed",
    "link": "https://techblog.woowahan.com",
    "useLink": false,
  },
  {
    "id": 3058707769330,
    "name": "쿠팡(Coupang) 기술 블로그",
    "menuName": "쿠팡",
    "url": "https://medium.com/feed/coupang-engineering",
    "link": "https://medium.com/coupang-engineering",
    "useLink": false,
  },
  {
    "id": 6887381058797,
    "name": "당근마켓 기술 블로그",
    "menuName": "당근",
    "url": "https://medium.com/feed/daangn",
    "link": "https://medium.com/daangn",
    "useLink": false,
  },
  {
    "id": 9235124778225,
    "name": "토스(Toss) 기술 블로그",
    "menuName": "토스",
    "url": "https://toss.tech/rss.xml",
    "link": "https://toss.tech",
    "useLink": true,
  },
  {
    "id": 7957393015172,
    "name": "직방 기술 블로그",
    "menuName": "직방",
    "url": "https://medium.com/feed/zigbang",
    "link": "https://medium.com/zigbang",
    "useLink": false,
  },
  {
    "id": 5297051556969,
    "name": "왓챠(Watcha) 기술 블로그",
    "menuName": "왓챠",
    "url": "https://medium.com/feed/watcha",
    "link": "https://medium.com/watcha",
    "useLink": false,
  },
  {
    "id": 3263023895334,
    "name": "뱅크샐러드(banksalad) 기술 블로그",
    "menuName": "뱅크샐러드",
    "url": "https://blog.banksalad.com/rss.xml",
    "link": "https://blog.banksalad.com",
    "useLink": true,
  },
  {
    "id": 3526106578915,
    "name": "요기요(yogiyo) 기술 블로그",
    "menuName": "요기요",
    "url": "https://techblog.yogiyo.co.kr/feed",
    "link": "https://techblog.yogiyo.co.kr",
    "useLink": false,
  },
  {
    "id": 5926255611991,
    "name": "여기어때 기술 블로그",
    "menuName": "여기어때",
    "url": "https://techblog.gccompany.co.kr/feed",
    "link": "https://techblog.gccompany.co.kr",
    "useLink": false,
  },
  {
    "id": 8721706690824,
    "name": "넷마블 기술 블로그",
    "menuName": "넷마블",
    "url": "https://netmarble.engineering/feed",
    "link": "https://netmarble.engineering",
    "useLink": true,
  },
  {
    "id": 4157598485519,
    "name": "29cm 기술 블로그",
    "menuName": "29cm",
    "url": "https://medium.com/feed/@dev29cm",
    "link": "https://medium.com/@dev29cm",
    "useLink": false,
  },
  {
    "id": 7420343341210,
    "name": "인프랩 기술 블로그",
    "menuName": "인프랩",
    "url": "https://tech.inflab.com/rss.xml",
    "link": "https://tech.inflab.com",
    "useLink": true,
  }
];