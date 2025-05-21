.PHONY: build deploy clean hosting

# Step 1: Build Flutter Web
build:
	@echo "🚀 Building Flutter Web..."
	cd web && flutter build web

# Step 2: Copy build output to Flask static folder
deploy: build
	@echo "📦 Copying build output to Flask static folder..."
	rm -rf server/static/*
	cp -r web/build/web/* server/static/

# Step 3: Deploy to Firebase Hosting
hosting: deploy
	@echo "🔥 Deploying to Firebase Hosting..."
	cd server && firebase deploy --only hosting

# Optional: Clean both build and static folders
clean:
	@echo "🧹 Cleaning previous builds..."
	rm -rf Web/build/
	rm -rf Server/static/*
