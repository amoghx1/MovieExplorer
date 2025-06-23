# 🎬 Movie Explorer

**Movie Explorer** is an iOS application built using Swift and UIKit that allows users to browse, explore, and manage their favorite movies using [The Movie DB API](https://www.themoviedb.org/documentation/api). The app is built with clean architecture principles and focuses on providing a responsive, modular, and offline-friendly movie browsing experience.

---

## 🚀 Features

### Home Screen
- Browse a list or grid of movies (includes title, thumbnail, release year).
- Pull-to-refresh to reload movie data.
- Smooth scrollable interface using `UICollectionView`.
- Support for loading, empty, and error UI states.

### Movie Detail Screen
- Detailed view with:
  - Poster image
  - Movie description / plot
  - Genre
  - Rating
- "Mark as Favourite" feature (locally persisted).

### Favourites Screen
- View list of saved favourite movies (offline access supported).
- No API calls — all data loaded from local storage.

---

## 🛠 Tech Stack

- **Language**: Swift (latest stable version)
- **UI Framework**: UIKit with Auto Layout (Programmatic or Storyboard)
- **Networking**: URLSession
- **Local Persistence**: Core Data
- **Architecture**: MVVM (Model-View-ViewModel) or Clean Swift (VIP)
- **Package Management**: Swift Package Manager

---

## 🧱 Architecture

This project follows the **MVVM / Clean Swift architecture**, ensuring:
- Clear separation of concerns (UI, Business Logic, Networking, Data).
- Modular, testable, and reusable components.
- Clean folder and file organization.

---

## ✅ Requirements Fulfilled

- [x] Home Screen with movie listing and pull-to-refresh.
- [x] Movie Detail Screen with rich movie data and favourite marking.
- [x] Favourites Screen with locally persisted movies.
- [x] URLSession integration with proper error handling.
- [x] Codable for parsing API responses.
- [x] Core Data for offline caching and favourite movie storage.
- [x] Modular and clean MVVM/Clean Swift codebase.

---

## 🌟 Bonus Features

- [ ] Dependency Injection (e.g., for ViewModel & networking layer)
- [ ] Offline support for previously fetched data
- [ ] Reusable UI components
- [ ] Memory management best practices
- [ ] Basic Unit Tests (ViewModel / Services)

---

## 📷 Screenshots

<!-- Add your screenshots here -->
<!-- Example:
<img src="screenshots/home.png" width="200"/> <img src="screenshots/detail.png" width="200"/> 
-->

---

## 🔧 Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/movie-explorer.git
