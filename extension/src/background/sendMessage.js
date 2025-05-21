export function sendMessage(message) {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      if (tabs.length > 0) {
        const tabId = tabs[0].id;
  
        // First, check if the content script is already injected
        chrome.tabs.sendMessage(tabId, { type: "ping" }, (response) => {
          if (chrome.runtime.lastError || !response) {
            // If there's an error or no response, inject the content script
            console.log("Injecting content script...");
            injectAndSendMessage(tabId, message);
          } else {
            // If the content script is already injected, just send the message
            console.log("Content script already injected, sending message...");
            sendToContentScript(tabId, message);
          }
        });
      } else {
        console.error("No active tab found.");
      }
    });
  }
  
  // Injects the content script, then sends the message
  function injectAndSendMessage(tabId, message) {
    chrome.scripting.executeScript(
      {
        target: { tabId: tabId },
        files: ["content-scripts.js"], // Ensure the correct script path
      },
      () => {
        if (chrome.runtime.lastError) {
          console.error("Error injecting content script:", chrome.runtime.lastError.message);
        } else {
          sendToContentScript(tabId, message);
        }
      }
    );
  }
  
  // Sends the message after confirming content script is present
  function sendToContentScript(tabId, message) {
    chrome.tabs.sendMessage(tabId, message, (response) => {
      if (chrome.runtime.lastError) {
        console.error("Error sending message to content script:", chrome.runtime.lastError.message);
      } else {
        console.log("Message sent to content script:", response);
      }
    });
  }