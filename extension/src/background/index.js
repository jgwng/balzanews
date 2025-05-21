import { sendMessage } from "./sendMessage.js";

chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: "openSidePanel",
    title: "개발자 신문 보기",
    contexts: ["all"],
  });
});

chrome.contextMenus.onClicked.addListener(async (info, tab) => {
  if (tab.url.includes('chrome://')) {
    return;
  }

  if (info.menuItemId === "openSidePanel") {
    chrome.sidePanel.open({ tabId: tab.id });
  }
});

chrome.runtime.onMessage.addListener(function (message, sender, sendResponse) {
  console.log('background message : ', message);
  switch (message.type) {
    case "createPopup":
      sendMessage(message);
      return true;
    case "readNews":
      const tabId = message.tabId;
      chrome.tabs.onUpdated.addListener(function listener(updatedTabId, changeInfo) {
        if (updatedTabId === tabId && changeInfo.status === "complete") {
          sendMessage(message);
          chrome.tabs.onUpdated.removeListener(listener);
        }
      });
      return true;
  }
});

chrome.action.onClicked.addListener(async (tab) => {
  if (tab.url.includes('chrome://')) {
    return;
  }
  try {
    chrome.sidePanel.open({ tabId: tab.id });
  } catch (error) {
    console.error("Error opening side panel:", error);
  }
});

// chrome.tabs.onActivated.addListener(async (activeInfo) => {
//   const tab = await chrome.tabs.get(activeInfo.tabId);
//   if (tab.url.includes('chrome://')){
//     return;
//   }
// });

// chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
//   if (tab.url.includes('chrome://')){
//     return;
//   }

//   if (changeInfo.status === "complete" && tab.active) {
//   }
// });

// chrome.runtime.onConnect.addListener(function (port) {
//   if (port.name === 'sidepanel') {
//     port.onDisconnect.addListener(async () => {
//       sendMessage({ type: "sidePanelClosed" });
//     });
//   }
// });