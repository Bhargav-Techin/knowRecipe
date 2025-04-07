# 🧑‍🍳 RecipeDekho — Cross-Platform Recipe Manager

RecipeDekho is a personal recipe management app built with **Flutter (mobile)** and **Angular (web)** on the frontend, and powered by a **Spring Boot + MySQL** backend. It allows users to create, edit, delete, and view their favorite recipes from anywhere!

## 🌐 Live Demo
- **Web App:** [https://recipie-dekho-latest.onrender.com/landing-page]
- **APK Download:** [https://drive.google.com/file/d/1z4F6DLgnRnpOXO4P9JcggM6Id7KWkfuq/view]

---

## 🚀 Features

- ✨ Cross-platform support: Web & Mobile (Android)
- 🔐 Secure user authentication with JWT
- 📋 Add, edit, and delete recipes
- 🧾 Recipe details include title, ingredients, steps, and category
- 🌄 Recipe image via URL (file upload coming soon!)
- 🗃️ Responsive UI built with Angular and Flutter
- 🧠 AI-powered recipe assistant (Coming Soon!)

---

## ⚙️ Tech Stack

### Frontend
- **Mobile:** Flutter
- **Web:** Angular

### Backend
- **Framework:** Spring Boot
- **Database:** MySQL
- **Auth:** JWT-based

---

## 🧪 Known Limitations

- Not yet scalable for production (MVP phase)
- Image URL and description fields have character limits
- Image uploads are not yet supported (only URLs)
- AI Assistant is under development

---

## 📦 Installation

### Prerequisites
- Flutter SDK
- Node.js & Angular CLI
- Java 17+
- MySQL

### Backend (Spring Boot)
```bash
cd backend
./mvnw spring-boot:run
