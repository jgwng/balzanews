<script>
    import { createEventDispatcher, onMount } from "svelte";
    import feedUrlsKR from '../../assets/json/tech_blogs_kr.json';
    import feedUrlsEN from '../../assets/json/tech_blogs_en.json';

    export let techCorp;
    let techCorpSearchValue = '';

    const dispatch = createEventDispatcher();
    let regionList = [
      {
        name: 'kr',
        label: '국내',
      },
      {
        name: 'en',
        label: '해외',
      }
    ];
    
    let displayFeeds = [];

    let selectedRegion = 'kr';
    let selectedRegionFeeds = [];

    $: {
      if (selectedRegion === 'kr') {
        selectedRegionFeeds = feedUrlsKR.feeds;
      } else {
        selectedRegionFeeds = feedUrlsEN.feeds;
      }
      if(techCorpSearchValue.length > 0) {
        displayFeeds = selectedRegionFeeds.filter(feed => feed.menuName.includes(techCorpSearchValue));
      } else {
        displayFeeds = selectedRegionFeeds;
      }
    }

    onMount(() => {
      if(techCorp.region) { 
        selectedRegion = techCorp.region;
      }
    });

    function closeModal() {
      dispatch("close");
    }
  
    function selectTab(region) {
      selectedRegion = region;
    }
  
    function selectCompany(index) {
      const selectedBlog = selectedRegionFeeds[index];
      selectedBlog.region = selectedRegion;
      dispatch("select", { selectedBlog });
      closeModal();
    }
    
    function handleKeydown(event) {
        if (event.key === 'Escape') {
          closeModal();
        }
    }
    
    function clearInput() {
      techCorpSearchValue = '';
      deleteButton.style.display = 'none';
    }

    function handleInput(event) {
      techCorpSearchValue = event.target.value;
      console.log('value : ', techCorpSearchValue);
      const deleteButton = document.getElementById('deleteButton');

      if(techCorpSearchValue.length > 0) {
        deleteButton.style.display = 'flex'; 
        displayFeeds = selectedRegionFeeds.filter(feed => feed.menuName.includes(techCorpSearchValue));
      } else {
        deleteButton.style.display = 'none';
        displayFeeds = selectedRegionFeeds;
      }
    }

  </script>
  <div class="modal-overlay" on:click={closeModal} on:keydown={handleKeydown}>
    <div class="modal-content" on:click|stopPropagation on:keydown={handleKeydown}>
      <div class="modal-content-header">
        <div class="modal-content-header-title">기업 선택</div>
        <div class="close-icon" on:click={closeModal} on:keydown={handleKeydown}>
          <svg enable-background="new 0 0 512 512" height="512" viewBox="0 0 512 512" width="512" xmlns="http://www.w3.org/2000/svg"><path d="m292.2 256 109.9-109.9c10-10 10-26.2 0-36.2s-26.2-10-36.2 0l-109.9 109.9-109.9-109.9c-10-10-26.2-10-36.2 0s-10 26.2 0 36.2l109.9 109.9-109.9 109.9c-10 10-10 26.2 0 36.2 5 5 11.55 7.5 18.1 7.5s13.1-2.5 18.1-7.5l109.9-109.9 109.9 109.9c5 5 11.55 7.5 18.1 7.5s13.1-2.5 18.1-7.5c10-10 10-26.2 0-36.2z"/></svg>
        </div>
      </div>

      <div class="searchBar">
        <div class="search-icon" id="searchIcon">
          <svg fill="none" height="512" viewBox="0 0 512 512" width="512" xmlns="http://www.w3.org/2000/svg"><g fill="rgb(0,0,0)"><path d="m209.552 386.103c-97.351 0-176.552-79.201-176.552-176.551 0-97.351 79.201-176.552 176.552-176.552 97.35 0 176.551 79.201 176.551 176.552 0 97.35-79.201 176.551-176.551 176.551zm0-317.7927c-77.877 0-141.2417 63.3647-141.2417 141.2417s63.3647 141.241 141.2417 141.241 141.241-63.364 141.241-141.241-63.347-141.2417-141.241-141.2417z"/><path d="m461.887 479.543c-2.318.002-4.615-.453-6.757-1.341s-4.087-2.19-5.725-3.832l-135.839-135.839c-1.639-1.639-2.939-3.585-3.826-5.727-.887-2.141-1.344-4.437-1.344-6.755s.457-4.614 1.344-6.755c.887-2.142 2.187-4.088 3.826-5.727 1.64-1.639 3.585-2.94 5.727-3.827s4.437-1.344 6.756-1.344c2.318 0 4.613.457 6.755 1.344s4.088 2.188 5.727 3.827l135.839 135.839c2.477 2.465 4.165 5.612 4.851 9.039s.338 6.981-.999 10.21c-1.338 3.229-3.605 5.988-6.513 7.926-2.908 1.939-6.326 2.97-9.822 2.962z"/></g></svg>
        </div>
        <input required="" bind:value={techCorpSearchValue} placeholder="검색어를 입력해주세요" type="text" id="messageInput" on:input={handleInput}/>
        <button id="deleteButton" on:click={clearInput}>
          <svg xmlns="http://www.w3.org/2000/svg" version="1.1" xmlns:xlink="http://www.w3.org/1999/xlink" width="512" height="512" x="0" y="0" viewBox="0 0 254000 254000" style="enable-background:new 0 0 512 512" xml:space="preserve" fill-rule="evenodd" class=""><g><path fill="#cecece" d="M127000 0c70129 0 127000 56871 127000 127000s-56871 127000-127000 127000S0 197129 0 127000 56871 0 127000 0zM62810 172969l45969-45969-45969-45969c-2637-2638-2637-6941 0-9578l8643-8643c2637-2637 6940-2637 9578 0l45969 45969 45969-45969c2638-2637 6941-2637 9578 0l8643 8643c2637 2637 2637 6940 0 9578l-45969 45969 45969 45969c2637 2638 2637 6941 0 9578l-8643 8643c-2637 2637-6940 2637-9578 0l-45969-45969-45969 45969c-2638 2637-6941 2637-9578 0l-8643-8643c-2637-2637-2637-6940 0-9578z" opacity="1" data-original="#ff4141" class=""></path></g></svg>
        </button>
      </div>

      <div class="tab-container">
        {#each regionList as region}
          <div class="tab" class:selected={selectedRegion === region.name} on:click={() => selectTab(region.name)} on:keydown={handleKeydown}>{region.label}</div>
        {/each}
      </div>
      <div class="grid-container">
        {#if displayFeeds.length === 0}
        <div id="emptyResult">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="512" height="512"><g id="_01_align_center" data-name="01 align center"><path d="M12,24A12,12,0,1,1,24,12,12.013,12.013,0,0,1,12,24ZM12,2A10,10,0,1,0,22,12,10.011,10.011,0,0,0,12,2Z"/><rect x="11" y="5" width="2" height="10"/><rect x="11" y="17" width="2" height="2"/></g></svg>
          <div>검색 결과가 없습니다.</div>
        </div>
        {:else}
        {#each displayFeeds as blog, index}
          <div class="grid-item" class:selected={blog.id === techCorp.id} on:click={() => selectCompany(index)} on:keydown={handleKeydown}>
            {blog.menuName}
          </div>
        {/each}
        {/if}
      </div>
    </div>
  </div>
  
  <style>
    .modal-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 9999;
    }
    .modal-content {
      background-color: white;
      padding: 20px;
      border-radius: 8px;
      max-width: 90%;
      width: 1200px;
      position: relative;
      display: flex;
      flex-direction: column;
      height: 80vh;
    }

    .modal-content-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 20px;
      font-weight: bold;
      padding: 0px 10px;
      color: #171717;
      margin-bottom: 10px;
      flex-shrink: 0;
    }

    .close-icon {
      cursor: grab;
      display: flex;
      align-items: center;
      justify-content: center;
      width: 24px;
      height: 24px;
    }

    .close-icon svg {
      width: 16px;
      height: 16px;
      display: block;
    }

    .grid-container {
      display: grid;
      grid-template-columns: repeat(5, 1fr);
      gap: 10px;
      padding: 10px;
      margin-bottom: 20px;
      overflow-y: auto;
      flex: 1;
      min-height: 0;
    }

    .grid-item {
      background-color: #f0f0f0;
      color: #171717;
      padding: 10px;
      border-radius: 4px;
      cursor: pointer;
      transition: background-color 0.3s;
      display: flex;
      align-items: center;
      justify-content: center;
      text-align: center;
      min-height: 44px;
      font-size: 18px;
    }

    .grid-item:hover {
      background-color: #e0e0e0;
    }

    .grid-item.selected {
      background-color: #292A2D;
      color: white;
    }

    .tab-container {
      display: flex;
      gap: 10px;
      margin: 0px 10px;
      border-bottom: 1px solid #eee;
      flex-shrink: 0;
    }
    
    .tab {
      padding: 8px 16px;
      cursor: pointer;
      color: #71717A;
      font-size: 16px;
      font-weight: bold;
    }
    
    .tab:hover {
      background-color: #e0e0e0;
    }
    
    .tab.selected {
      color: #292A2D;
      border-bottom: 2px solid #292A2D;
    }

    .searchBar {
      height: 40px;
      display: flex;
      background-color: #FFF;
      padding: 0 15px;
      margin: 10px;
      border-radius: 10px;
      border: 1px solid #ddd;
      position: relative;
      flex-shrink: 0;
    }
    .searchBar:focus-within {
      border: 1px solid #171717;
    }
    .search-icon {
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      width: 24px;
    }
    #messageInput {
      height: 100%;
      background-color: transparent;
      outline: none;
      border: none;
      padding-left: 10px;
      color: #171717;
      flex: 1;
      min-width: 0;
    }

    #messageInput:focus ~ #sendButton svg path,
    #messageInput:valid ~ #sendButton svg path {
      fill: #3c3c3c;
      stroke: white;
    }

    #deleteButton {
      height: 100%;
      background-color: transparent;
      outline: none;
      border: none;
      position: absolute;
      right: 15px;
      top: 0;
      display: none;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.3s;
      width: 24px;
      padding: 0;
    }
    #deleteButton svg {
      height: 20px;
      transition: all 0.3s;
    }

    #emptyResult {
      grid-column: 1 / -1;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100%;
      min-height: inherit;
      color: var(--font-color);
      gap: 12px;
    }

    #emptyResult svg {
      width: 48px;
      height: 48px;
      opacity: 0.6;
    }

    #emptyResult div {
      font-size: 14px;
      opacity: 0.8;
    }
  </style>
  