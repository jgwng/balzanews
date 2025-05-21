<script>
  import Loader from './loader.svelte';
  import '../../styles/global.css';
  export let url = '';
  export let region = '';
  export let company = '';

  let articles = [];
  let isLoading = false;
  let previousUrl = '';
  async function fetchFeed(url) {
  try {
    const response = await fetch(url);
    const xmlText = await response.text();

    // Parse the XML response
    const parser = new DOMParser();
    const xml = parser.parseFromString(xmlText, "text/xml");

    let items = [];

    // Detect whether it's an RSS or Atom feed
    if (xml.querySelector("item")) {
      // RSS Feed (Standard)
      items = [...xml.querySelectorAll("item")].map(item => ({
        title: item.querySelector("title")?.textContent || "No title",
        link: item.querySelector("link")?.textContent || "#",
        description: item.querySelector("description")?.textContent || "",
        pubDate: item.querySelector("pubDate")?.textContent || "",
      }));
    } else if (xml.querySelector("entry")) {
      // Atom Feed (like tech.socarcorp.kr)
      items = [...xml.querySelectorAll("entry")].map(entry => ({
        title: entry.querySelector("title")?.textContent || "No title",
        link: entry.querySelector("link")?.getAttribute("href") || "#",
        description: entry.querySelector("summary")?.textContent || entry.querySelector("content")?.textContent || "",
        pubDate: entry.querySelector("updated")?.textContent || entry.querySelector("published")?.textContent || "",
      }));
    } else {
      console.warn("Unknown feed format.");
    }

    console.log("Parsed Feed Data:", items);
    return items;
  } catch (error) {
    console.error("Error fetching RSS feed:", error);
    return [];
  }
}

  $: if (url !== previousUrl) {
    refreshFeed();
    previousUrl = url;
  }

  export function refreshFeed() {
    if (!url) return;

    isLoading = true;
    console.log('url : ', url);
    fetchFeed(url).then(items => {
      articles = items;
      isLoading = false;
    });
  }

  function openUrl(article) {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        if (tabs.length === 0) {
          console.error("No active tab found.");
          return;
        }

        const currentTabId = tabs[0].id;

        // Update the current active tab's URL
        chrome.tabs.update(currentTabId, { url: article.link }, (updatedTab) => {
          if (chrome.runtime.lastError) {
            console.error("Error updating tab:", chrome.runtime.lastError.message);
            return;
          }

          console.log("Tab URL updated:", currentTabId);

          // Notify the background script to listen for page load completion
          chrome.runtime.sendMessage({
            type: "readNews",
            tabId: currentTabId,
            url: article.link,
            title: article.title,
            region: region,
            company: company,
          });
        });
      });
  }
  
</script>

{#if isLoading === true}
  <Loader />
{:else}
  <ul>
    {#each articles as article}
      <li>
        <div 
          class="article" 
          role="button"
          tabindex="0"
          on:click={() => openUrl(article)}
          on:keydown={(e) => {
            if (e.key === 'Enter' || e.key === ' ') {
              e.preventDefault();
            }
          }}
          aria-label={article.title}
        >
          {article.title}
        </div>
      </li>
    {/each}
  </ul>
{/if}

<style>
  .article {
    background-color: var(--color-bg);
    position: relative;
    padding: 16px;
    margin-top: 8px;
    margin-left: 8px;
    margin-right: 8px;
    border: 1px solid var(--color-border);
    border-radius: 8px;
    cursor: pointer;
    transition: background-color 0.2s ease;
    color: var(--font-color);
  }

  .article:hover {
    background-color: var(--color-bg-hover);
    cursor: grab;
  }
  
  ul {
    list-style-type: none;
    padding: 0;
    margin: 0;
    padding-bottom: 20px;
  }
  
</style>