{{flutter_js}}

    {{flutter_build_config}}

    // Load the Flutter engine
    _flutter.loader.load({
        onEntrypointLoaded: async function(engineInitializer) {
            let target = document.querySelector("#app-area");
            const config = {
                 hostElement: target,
                 canvasKitBaseUrl: "./canvaskit/",
            };
            const appRunner = await engineInitializer.initializeEngine(config);

            appRunner.runApp().then((_) => {
                    target.classList.add("fade-in");
                    updateViewportAttributes({
                               'interactive-widget': 'resizes-content',
                               'viewport-fit': 'cover',
                               'user-scalable': 'no'
                           });

                  });
        }
    });