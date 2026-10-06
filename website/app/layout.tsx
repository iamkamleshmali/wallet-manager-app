import type { Metadata, Viewport } from "next";
import "./globals.css";

export const viewport: Viewport = {
  themeColor: "#FF5E57",
  width: "device-width",
  initialScale: 1,
};

export const metadata: Metadata = {
  title: "Wallet Manager — Offline-First Personal Finance & Expense Tracker",
  description: "Double-entry bookkeeping, visual charts, receipt photo storage, and encrypted Google Drive auto-sync. Completely offline-first, no ads, no bank SMS scraping. 100% private Android app.",
  keywords: [
    "Wallet Manager",
    "Money Manager",
    "Expense Tracker",
    "Personal Finance",
    "Offline Budget App",
    "Double Entry Bookkeeping",
    "Android APK Download",
    "Google Drive Sync Expense",
  ],
  authors: [{ name: "Kamlesh Mali" }],
  openGraph: {
    title: "Wallet Manager — The Easiest Way to Manage Personal Finances",
    description: "Offline-first, 100% private expense tracker with double-entry ledger, receipt storage, and encrypted Google Drive sync.",
    type: "website",
    url: "https://walletmanager.app",
    siteName: "Wallet Manager",
  },
  twitter: {
    card: "summary_large_image",
    title: "Wallet Manager — Offline-First Expense Tracker",
    description: "Manage transactions, visual charts, and encrypted Google Drive auto-sync with zero tracking.",
  },
  icons: {
    icon: "/favicon.ico",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="scroll-smooth" suppressHydrationWarning>
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link
          href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className="min-h-screen bg-[#FAFAFC] text-slate-800 dark:bg-[#0B0F17] dark:text-slate-100 font-sans antialiased selection:bg-coral-500 selection:text-white">
        {children}
      </body>
    </html>
  );
}
