{{flutter_js}}

    {{flutter_build_config}}

    // Load the Flutter engine
    _flutter.loader.load({
        onEntrypointLoaded: async function(engineInitializer) {
            const config = {
                        fontFallbackBaseUrl:  "./",
                        canvasKitBaseUrl: "./canvaskit/",
            };
            const appRunner = await engineInitializer.initializeEngine(config);

            appRunner.runApp().then((_) => {
                    document.querySelector("flutter-view").classList.add("fade-in");
                    updateViewportAttributes({
                               'interactive-widget': 'resizes-content',
                               'viewport-fit': 'cover',
                               'user-scalable': 'no'
                           });

                  });
        }
    });