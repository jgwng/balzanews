import SelectModalCompany from './modal/selectCompanyModal.svelte';
import FloatingButton from './fab/floatingButton.svelte';
let modalInstance = null;
let fabInstance = null;

function openModal(techCorp) {
  if (modalInstance) return;
  
  const modalContainer = document.createElement("div");
  modalContainer.id = "svelte-modal-container";
  document.body.appendChild(modalContainer);
  modalInstance = new SelectModalCompany({
    target: modalContainer,
    props: {
      techCorp: techCorp
    }
  });

  // Listen for modal close event
  modalInstance.$on("close", () => {
    closeModal(modalContainer);
  });

  // Listen for company selection
  modalInstance.$on("select", (event) => {
    console.log("Selected Company:", event.detail.selectedBlog);

    // Send data to background script or another part of the extension
    chrome.runtime.sendMessage({
      type: "selected_blog",
      data: event.detail.selectedBlog
    });

    // Close modal after selection
    closeModal(modalContainer);
  });
}

function closeModal(modalContainer){
  if(modalContainer){
    modalContainer.remove();
  }
  modalInstance = null;
}

function showFloatingButton(message){
  if(fabInstance) return;

  const fabContainer = document.createElement("div");
  fabContainer.id = "svelte-fab-container";
  document.body.appendChild(fabContainer);
  fabInstance = new FloatingButton({
    target: fabContainer,
    props: {
      url: message.url,
      title: message.title,
      region: message.region,
      company: message.company,
    }
  });
}

function hideFloatingButton(){
  if(fabInstance){
    fabInstance.destroy();
    fabInstance = null;
  }
}

// Listener for messages from the Chrome extension's background script
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  console.log("Message received:", message);
  switch (message.type) {
    case "ping":
      sendResponse({ status: "alive" });
      return true;
    case "createPopup":
      openModal(message.techCorp);
      sendResponse({ status: "success", message: "Popup displayed" });
      return true;
    case "tabChanged":
    case "sidePanelClosed":  
      closeModal();
      hideFloatingButton();
      sendResponse({ status: "success", message: "Popup closed" });
      return true;
    case "readNews":
      showFloatingButton(message);
      sendResponse({ status: "success", message: "scrollListener" });
      return true;
  } 
});