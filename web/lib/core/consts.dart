enum TechCorps {
  musinsa("무신사", "https://medium.com/feed/musinsa-tech", "https://medium.com/musinsa-tech", false),
  naverD2("네이버 D2", "https://d2.naver.com/d2.atom", "https://d2.naver.com/home", false),
  woowa("우아한형제들", "https://techblog.woowahan.com/feed", "https://techblog.woowahan.com", false),
  coupang("쿠팡", "https://medium.com/feed/coupang-engineering", "https://medium.com/coupang-engineering", false),
  daangn("당근", "https://medium.com/feed/daangn", "https://medium.com/daangn", false),
  toss("토스", "https://toss.tech/rss.xml", "https://toss.tech", true),
  zigbang("직방", "https://medium.com/feed/zigbang", "https://medium.com/zigbang", false),
  watcha("왓챠", "https://medium.com/feed/watcha", "https://medium.com/watcha", false),
  banksalad("뱅크샐러드", "https://blog.banksalad.com/rss.xml", "https://blog.banksalad.com", true),
  yogiyo("요기요", "https://techblog.yogiyo.co.kr/feed", "https://techblog.yogiyo.co.kr", false),
  yeogiotte("여기어때", "https://techblog.gccompany.co.kr/feed", "https://techblog.gccompany.co.kr", false),
  netmarble("넷마블", "https://netmarble.engineering/feed", "https://netmarble.engineering", true),
  cm29("29cm", "https://medium.com/feed/@dev29cm", "https://medium.com/@dev29cm", false),
  inflab("인프랩", "https://tech.inflab.com/rss.xml", "https://tech.inflab.com", true);

  const TechCorps(this.name, this.rssUrl, this.link, this.useLink);

  final String name;
  final String rssUrl;
  final String link;
  final bool useLink;
}
