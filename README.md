# 🌿 Daily Reframe

A minimal, calming Flutter mental wellness app that helps users reframe negative thoughts using Google Gemini AI.

---

## ✨ Features

- **Dump Screen** — Write out a negative thought, optionally tag your mood
- **Reframe Screen** — Get 3 AI-generated reframes: Logical 🧠, Compassionate 💛, Growth 🚀
- **Bookmark** — Save your favorite reframes locally with `shared_preferences`
- Smooth fade + slide animations via `flutter_animate`
- Calm lavender-to-white gradient UI with Nunito + Playfair Display fonts

---

## 🚀 Setup Instructions

### 1. Clone / Copy the project

```bash
cd daily_reframe
flutter pub get
```

### 2. Add your `.env` file

Create a `.env` file in the **root** of the project (same level as `pubspec.yaml`):

```
GEMINI_API_KEY=your_gemini_api_key_here
```

> ⚠️ The `.env` file is listed in `.gitignore` — never commit your API key!

### 3. Run the app

```bash
flutter run
```

---

## 📁 Folder Structure

```
lib/
├── main.dart                  # App entry point, loads .env
├── screens/
│   ├── dump_screen.dart       # Screen 1: write your thought
│   └── reframe_screen.dart    # Screen 2: view AI reframes
├── services/
│   └── ai_service.dart        # Gemini API integration
├── widgets/
│   └── reframe_card.dart      # Animated reframe card with bookmark
└── models/
    └── reframe_model.dart     # Data model for AI response
```

---

## 📦 Dependencies

| Package | Use |
|---|---|
| `google_generative_ai` | Gemini 1.5 Flash API |
| `flutter_dotenv` | Secure API key management |
| `shared_preferences` | Save bookmarked reframes |
| `google_fonts` | Nunito + Playfair Display |
| `flutter_animate` | Card fade/slide animations |
| `http` | (Available if needed) |

---

## 🎨 Design

- **Primary color:** `#7C5CBF` (soft purple)
- **Background:** Gradient `#F3EFFF → #FFFFFF`
- **Fonts:** Playfair Display (headings) + Nunito (body)
- **Cards:** White, 20px border radius, soft purple shadow

---

## 🛠 Troubleshooting

**"API key not found"** → Make sure `.env` exists in project root and is listed under `assets:` in `pubspec.yaml`.

**Build fails** → Run `flutter clean && flutter pub get`

**Fonts not loading** → Requires internet on first run to download Google Fonts.