# The Movie App (iOS – SwiftUI)
A fully featured iOS Movie browsing app built with **SwiftUI**, integrating with **The Movie Database (TMDb)** API.  
The app supports browsing popular movies, watching trailers, detailed view, search, and favorites with persistent storage.

---
# Features
###  Movies List
- Browse popular movies from TMDb  
- Infinite scrolling (pagination)  
- Smooth UI with async/await  
- Safe error handling  

### Search
- Search movies by title  
- Debounced search input  
- Inline error + retry support  
- “No results found” handling  

### Movie Detail Page
- Title, overview, runtime, genres, rating  
- Cast list (horizontal scroll)  
- **YouTube Trailer Carousel**  
  - Swipeable horizontal video player  
  - Multiple YouTube videos  
  - Expanding animated page indicator  
- Independent section loading  
- Retry handling for:
  - Details
  - Cast
  - Videos  

### Favorites
- Add/Remove movies from favorites  
- Persist across app launches (UserDefaults)  
- Favorites grid layout  
- Empty state UI  
- Error handling + retry  
---
# Dependencies

### 1. TMDb API  
Signup to get your API key:  
https://www.themoviedb.org

Add your API key in `NetworkManager.swift`:

```swift
let API_KEY = "YOUR_API_KEY_HERE"
```

### 2. YouTube iOS Player Helper
Installed via Swift Package Manager:
```swift
https://github.com/youtube/youtube-ios-player-helper
```
Used for inline YouTube trailer playback.

---
# Project Setup & Run Instructions

### 1. Clone repository
```swift
git clone https://github.com/Debashish-hub/TheMovieApp.git
cd TheMovieApp
```
### 2. Open project
```swift
open TheMovieApp.xcodeproj
```
### 3. Add TMDb API key
Open `NetworkManager.swift` and replace:
```swift
let API_KEY = "YOUR_KEY"
```
### 4. Build & Run
- Select a simulator
- Press ⌘ + R
---

# Architecture Diagram


# Assumptions
- API key stored locally (acceptable for demo).
- No backend or Firebase required.
- Internet connection required for most features.
- Favorites list is small enough for ID-based re-fetching.
- YouTube videos from TMDb are valid YouTube URLs.
- SwiftUI is the only UI framework used (no UIKit screens).
- No caching layer implemented.

# Known Limitations
- No offline caching (data resets without internet).
- YouTubePlayerView uses web iframe → heavy if too many players load.
- Search results do not paginate.
- No dark/light theme toggle (system default used).
- Rate limiting may occur if many API requests are made quickly.
- No unit tests added yet.
- No localization (English only).

# Future Enhancements
- Shimmer loading placeholders
- Offline caching & CoreData storage
- Similar movies section
- Actor detail pages
- Genre filtering
- Dark mode customization
- Unit tests for networking & view models
- Reduce memory usage with thumbnail-only preview for trailers

# Demo

# Credits
- TMDb API — https://www.themoviedb.org
- YouTube iOS Player Helper
- SwiftUI, Combine, async/await



