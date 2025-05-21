<script>
    import { onMount } from 'svelte';
    import FeedList from './component/feedList.svelte';
    import Switch from './component/switch.svelte';
    import feedUrls from '../assets/json/tech_blogs_kr.json';
    import CurrentCompany from './component/currentCompany.svelte';

    let techCorp = feedUrls.feeds[0];
    let feedList;

    chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
      if (message.type === "selected_blog") {
        techCorp = message.data;
        chrome.storage.sync.set({ techCorp: techCorp });
      }
    });
    

    function openPopup() {
      const techCorpInfo = JSON.parse(JSON.stringify(techCorp));
      const message = { type: "createPopup", techCorp: techCorpInfo};
      chrome.runtime.sendMessage(message);
    }
    
    function openCorpTechBlog() {
      chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        if (tabs.length === 0) {
          console.error("No active tab found.");
          return;
        }
        const currentTabId = tabs[0].id;
        chrome.tabs.update(currentTabId, { url: techCorp.link });
      });
    }


    function getTime() {
      const date = new Date();
      const year = date.getFullYear().toString().slice(2);
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      const hours = String(date.getHours()).padStart(2, '0');
      const minutes = String(date.getMinutes()).padStart(2, '0');
      
      return `${year}.${month}.${day} ${hours}:${minutes} 기준`;
    }
    
    function refreshFeed() {
      if (feedList) {
        feedList.refreshFeed();
      }
    }
    
    onMount(() => {
        let dataTheme = localStorage.getItem("theme") || 'light';
        document.documentElement.setAttribute('data-theme', dataTheme);
        chrome.storage.sync.get("techCorp", (data) => {
          if(data.techCorp){
            techCorp = data.techCorp;
          }else{
            techCorp = feedUrls.feeds[0];
          }
        });
      });

  </script>
  
  <main>
    <div class="top-bar">
      <div class="left-section">
         <img src="../assets/icons/icon192.png" alt="Logo">
         <div class="top-bar-title">개발자 신문</div>
      </div>
      <Switch />
    </div>
    <CurrentCompany title={techCorp.menuName} onClick={openPopup} />
    <div class="header">
      <div class="left-section">
        <div class="title">주요 뉴스</div>
        <div class="refresh-icon" id="refresh" on:click={refreshFeed}>
          <img src="assets/images/refresh.svg" alt="Refresh Icon">
        </div>
      </div>
      <div class="view-all" on:click={openCorpTechBlog}>전체보기</div>
    </div>
    <FeedList url={techCorp.url} region={techCorp.region ?? 'kr'} company={techCorp.menuName} bind:this={feedList}/>
  </main>
  
  <style>
    main {
      max-width: 600px;
      margin: auto;
      text-align: center;
      display: flex;
      flex-direction: column;
      background-color: var(--color-bg);
    }
  
    .header, .top-bar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
      margin-top:30px;
      margin-left: 8px;
      margin-right: 8px;
    }
    .top-bar{
      height: 56px;
      margin-top: 12px;
    }
  
    .left-section {
      display: flex;
      align-items: center;
      cursor: grab;
    }
    .left-section img {
      width: 24px;
      height: 24px;
    }

    .top-bar-title, .title {
      font-size: 20px;
      font-weight: bold;
      color: var(--font-color);
    }
    .top-bar-title { 
      margin-left: 4px;
    }
  
    .refresh-icon {
      cursor: grab;
      display: flex;
      align-items: center;
      justify-content: center;
      width: 24px;
      height: 24px;
    }
  
    .refresh-icon img {
      width: 16px;
      height: 16px;
      display: block;
    }

    [data-theme="dark"] .refresh-icon img {
      filter: invert(1);
    }

    .view-all {
      cursor: pointer;
      font-size: 14px;
      color: #9D9FA0;
    }
  
    .view-all:hover {
      cursor: grab;
    }
  </style>
  