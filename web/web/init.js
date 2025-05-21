function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
}

document.addEventListener('DOMContentLoaded', () => {

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

        var newContent = Object.entries(contentObject).map(([key, val]) => `${key}=${val}`).join(', ');
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

async function removeSplashLogo() {
    setTimeout(function () {
        var loaderContent = document.querySelector('.splashArea');
        loaderContent.style.opacity = 0;
        document.querySelector("flutter-view").classList.add("fade-in");
        setTimeout(function () {
        }, 10);
    }, 0);
}
