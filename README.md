(24 Jun '25) Note: v0.1 available as a preview before submission, any suggestions are hugely appreciated!
# 🎬 Movie Explorer

**Movie Explorer** is an iOS application built using Swift and UIKit that allows users to browse, explore, and manage their favorite movies using [The Movie DB API](https://www.themoviedb.org/documentation/api). The app is built with clean architecture principles and focuses on providing a responsive, modular, and offline-friendly movie browsing experience.

---

## 🚀 Features

### Home Screen
<img src="https://github.com/user-attachments/assets/bcb23498-be50-4507-8d87-aba477471e9b" alt="Home Screen Screenshot" width="200"/>

- Browse a list or grid of movies (includes title, thumbnail, release year).
- Pull-to-refresh to reload movie data.
- Smooth scrollable interface using `UICollectionView`.
- Support for loading, empty, and error UI states.


### Movie Detail Screen 
<img src="https://github.com/user-attachments/assets/dc3b8f22-2f0e-4605-9a86-170b7bec8ee3" alt="Movie Detail Screen" width="200"/>

- Detailed view with:
  - Poster image
  - Movie description / plot
  - Genre
  - Rating
- "Mark as Favourite" feature (locally persisted).

### Favourites Screen 
<img src="https://github.com/user-attachments/assets/cc1aed74-298d-41df-b217-137ff8aeb5ad" alt="Favourites Screen" width="200"/>

- View list of saved favourite movies (offline access supported).
- No API calls — all data loaded from local storage.
---

## 📷 Additional Screenshots
<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/b15b1ce0-f1ca-4657-ba13-9b90d785ae0d" alt="Add to Favourites" width="200"/>
      <br/>
      <strong>➕ Adding a Movie to Favourites</strong>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/2ad18f5c-9663-4e6c-9ddb-948b756898ef" alt="Remove from Favourites" width="200"/>
      <br/>
      <strong>➖ Removing a Movie from Favourites</strong>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/c13bc955-53ea-4479-b7dc-30bcfb127199" alt="Hearted on Home Screen" width="200"/>
      <br/>
      <strong>❤️ Movie Shows as Favourite on Home Screen</strong>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/00d76d43-f990-4811-aae8-947a5d7c272a" alt="Redirect Button Click" width="200"/>
      <br/>
      <strong>🔁 Redirect After Clicking Button</strong>
    </td>
  </tr>
</table>

## 🛠 Tech Stack

- **Language**: Swift 5.9
- **UI Framework**: UIKit with Auto Layout (Both Programmatic and Storyboard)
- **Networking**: URLSession
- **Local Persistence**: Core Data
- **Architecture**: MVVM (Model-View-ViewModel) 
- **Package Management**: Swift Package Manager

---

## 🧱 Architecture

This project follows the **MVVM**, ensuring:
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
- [x] Modular MVVM Swift codebase.

---

## 🌟 Bonus Features

- [ ] Redirection Link to the Movie's official webpage on Safari
- [ ] Dependency Injection ( using Repository design pattern)
- [ ] Reusable UI components
- [ ] Memory management best practices
- [ ] Illustrated Some Unit Tests

---

## 🌐 APIs Used

- [The Movie Database (TMDb) API](https://developers.themoviedb.org/3):
  - Fetching movie lists, details, and images.
  - Used endpoints:
    - `/trending/movie/`
    - `/movie/{movie_id}`

- [TMDb Image Base URL](https://developer.themoviedb.org/docs/image-basics)
  - Images served via: `https://image.tmdb.org/t/p/w500{poster_path}`
  - Supports dynamic sizing (e.g. `w200`, `w500`, etc.)

---
## ⚖️ Tradeoffs & Assumptions

- **Poster image uses `.scaleToFill` contentMode**: Chosen for layout simplicity, though it may distort images on extreme aspect ratios.
- **Core Data for local persistence**: Lightweight and native, but less flexible than alternatives like SQLite for more complex queries.
- For smaller views classes used same class for everything rather than strict MVVM for simplicity.
---

## 🔧 Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/amoghx1/MovieExplorer.git
