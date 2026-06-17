# 📱 OpenDota Heroes App

Flutter application that displays information about Dota 2 heroes using the OpenDota API.  
The app includes caching, favorites system, statistics visualization and basic analytics tracking.

---

## Features

### Heroes list
- Displays all Dota 2 heroes
- Data fetched from OpenDota API
- Cached locally using Hive for faster loading

### Hero details
- Detailed information about each hero
- Win rate, pro picks and pro wins
- Hero image and attributes

### Favorites system
- Add/remove heroes from favorites
- Stored locally using Hive database
- Separate Favourites screen

### Statistics
- Top heroes based on:
    - Win rate
    - Pro picks
    - Pro wins

### Analytics
- Firebase Analytics integration
- Tracks user actions such as:
    - opening heroes list
    - opening hero details
    - refreshing data

### Crash testing
- Firebase Crashlytics integration
- Manual crash button for testing reporting system