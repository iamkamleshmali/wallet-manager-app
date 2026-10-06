# Wallet Manager — Showcase Landing Page

A high-converting, modern showcase landing page for **Wallet Manager** (inspired by Realbyte Money Manager). Built with **Next.js (App Router)**, **Tailwind CSS**, **Lucide React**, and **Framer Motion**, optimized for 1-click deployment on **Vercel** with dynamic GitHub Releases APK integration.

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fiamkamleshmali%2Fwallet-manager-website)

---

## 🚀 Key Highlights & Features

- **Live GitHub Releases API Hook:** Automatically queries `https://api.github.com/repos/iamkamleshmali/wallet-manager-km/releases/latest` to extract the latest release tag (e.g. `v1.2.0`), asset size (`24.6 MB`), and direct APK download URL with graceful fallback.
- **Realbyte Design System:** Coral Red (`#FF5E57`) to Warm Orange (`#FF7A45`) hero gradient matching the classic Money Manager palette with crisp typography and subtle micro-animations.
- **Dark Mode Support:** Smooth light/dark theme switcher with `localStorage` persistence and system preference detection.
- **Interactive Phone Mockups:** 4 interactive views switching between:
  1. **Daily Ledger (`Trans`):** Income vs Expense breakdown, category icons, payment accounts, and receipt photo indicator.
  2. **Pie Chart Analytics (`Stats`):** Donut expense breakdown with percentage progress bars and category rankings.
  3. **Accounts Balance Sheet (`Accounts`):** Double-entry accounting tracking Assets (Cash, Bank UPI, Investments) vs Liabilities (Credit Cards).
  4. **Settings & CalcBox (`CalcBox`):** Built-in math keypad for instant calculations when splitting or logging expenses.
- **In-Mockup Theme Switcher:** Test how the mobile app looks in both Light and Dark modes directly on the page.
- **Google Drive AppData Sync Section:** Visual architecture explaining how local SQLite databases are encrypted and backed up directly to user's isolated Google Drive storage (`drive.appdata` scope) without third-party servers.
- **Security & Privacy Focus:** Highlights 4-digit passcode, biometric locks (Fingerprint / Face Unlock), zero bank SMS scraping, and zero ads.
- **Step-by-Step Android Installation Guide:** Clear walkthrough for downloading the APK and allowing "Install Unknown Apps" on Android.
- **Help Center / FAQ Accordion:** Interactive FAQ addressing APK installation, database preservation during updates, Google Drive restore, and open-source transparency.
- **Celebratory Confetti:** Triggers festive confetti effects upon clicking the primary download CTA.
- **Mobile Sticky Download Bar:** Ensures mobile users always have a 1-tap direct APK download button.

---

## 🛠️ Tech Stack

- **Framework:** Next.js 16 (App Router)
- **Styling:** Tailwind CSS with custom Realbyte color tokens & dark mode
- **Icons:** Lucide React & custom SVGs
- **Animations & FX:** Canvas Confetti & CSS keyframe transforms
- **API Integration:** SWR-pattern client hook for GitHub Releases API

---

## 📦 Project Structure

```
├── app/
│   ├── globals.css           # Tailwind base, utilities & glassmorphic styles
│   ├── layout.tsx            # SEO metadata, OpenGraph, Viewport & typography
│   └── page.tsx              # Assembled landing page
├── components/
│   ├── Navbar.tsx            # Sticky header with dark mode toggle & download CTA
│   ├── Hero.tsx              # Hero section with coral gradient & 3D mobile mockup
│   ├── FeatureGrid.tsx       # 6 core feature cards inspired by Realbyte Money Manager
│   ├── InteractiveShowcase.tsx # Tabbed smartphone preview with Light/Dark toggle
│   ├── GoogleDriveSyncSection.tsx # Architecture diagram for private Drive backup
│   ├── SecuritySection.tsx   # Biometrics, zero SMS reading & privacy pillars
│   ├── InstallationGuide.tsx # 3-step APK installation guide
│   ├── FaqSection.tsx        # Accordion FAQ
│   ├── Footer.tsx            # Footer with links, GitHub info & legal modals
│   ├── PrivacyModal.tsx      # Privacy policy modal dialog
│   ├── MobileStickyDownload.tsx # Sticky bottom APK download bar for mobile devices
│   └── icons/
│       └── GithubIcon.tsx    # Standalone GitHub SVG logo
├── hooks/
│   └── useGitHubRelease.ts   # Live GitHub releases hook with fallback handling
├── lib/
│   └── confetti.ts           # Confetti animation trigger
├── public/                   # Static assets
├── tailwind.config.js        # Theme color extension & custom animations
└── package.json
```

---

## 💻 Local Development

1. Install dependencies:
   ```bash
   npm install --legacy-peer-deps
   ```

2. Start the development server:
   ```bash
   npm run dev
   ```

3. Open [http://localhost:3000](http://localhost:3000) in your browser.

---

## 🚢 Deploying to Vercel (1-Click)

1. Push this repository to GitHub.
2. Go to [vercel.com/new](https://vercel.com/new) and import the repository.
3. Keep default settings (Framework: Next.js) and click **Deploy**.
4. Your landing page is live with global CDN delivery and automatic SSL!
