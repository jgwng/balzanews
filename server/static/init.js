function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
}

document.addEventListener('DOMContentLoaded', () => {
    const isLightMode = localStorage.getItem('IS_LIGHT_MODE') ?? 'true';
    const themeColor = isLightMode === 'true' ? '#F8F8FF' : '#1C1C20';
    setThemeColor(themeColor);
    console.log('DOMCONTENTLoaded');
});

function updateViewportAttributes(attributesMap) {
    var viewportMetaTag = document.querySelector('meta[name="viewport"]');
    if (viewportMetaTag) {
        var content = viewportMetaTag.getAttribute('content');
        var contentObject = content.split(',').reduce((acc, curr) => {
            var [key, val] = curr.trim().split('=');
            acc[key] = val;
            return acc;
        }, {});

        // Update or remove attributes based on the attributesMap
        Object.keys(attributesMap).forEach(key => {
            if (attributesMap[key] === null || attributesMap[key] === undefined) {
                // Remove attribute if value is null or undefined
                delete contentObject[key];
            } else {
                // Update attribute normally
                contentObject[key] = attributesMap[key];
            }
        });

        var newContent = Object.entries(contentObject).map(([key, val]) => `${key}=${val}`).join(',');
        viewportMetaTag.setAttribute('content', newContent);
    } else {
        console.error('Viewport meta tag not found');
    }
}

function bottomInset() {
   var bottomPadding = parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--sab"));
   return bottomPadding;
}

function topInset() {
   var topPadding = parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--sat"));
   return topPadding;
}

function leftInset() {
   var leftPadding = parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--sal"));
   return leftPadding;
}

function rightInset() {
   var rightPadding = parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--sar"));
   return rightPadding;
}

function setThemeColor(color) {
  let metaTag = document.querySelector('meta[name="theme-color"]');
  if (!metaTag) {
    metaTag = document.createElement('meta');
    metaTag.setAttribute('name', 'theme-color');
    document.head.appendChild(metaTag);
  }
  metaTag.setAttribute('content', color);
}

function setThemeData(theme) {
  document.documentElement.setAttribute('data-theme', theme);
}

function showNotification(pushTitle,pushBody,pushImage) {
    const title = pushTitle;
    const options = {
        body: pushBody,
        icon: '/icons/Icon-192.png',
        image: pushImage,
        data: {
              dateOfArrival: Date.now()
        },
    };
    navigator.serviceWorker.ready.then(async function (serviceWorker) {
        await serviceWorker.showNotification(title, options);
    });
}

async function clearAppBadge() {
  if ('clearAppBadge' in navigator) {
    try {
      await navigator.clearAppBadge();
      console.log("🔕 App badge cleared.");
    } catch (err) {
      console.error("❌ Failed to clear app badge:", err);
    }
  } else {
    console.warn("⚠️ App badge not supported on this browser.");
  }
};
