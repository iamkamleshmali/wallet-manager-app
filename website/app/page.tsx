import Navbar from "@/components/Navbar";
import Hero from "@/components/Hero";
import FeatureGrid from "@/components/FeatureGrid";
import InteractiveShowcase from "@/components/InteractiveShowcase";
import GoogleDriveSyncSection from "@/components/GoogleDriveSyncSection";
import SecuritySection from "@/components/SecuritySection";
import InstallationGuide from "@/components/InstallationGuide";
import FaqSection from "@/components/FaqSection";
import Footer from "@/components/Footer";
import MobileStickyDownload from "@/components/MobileStickyDownload";

export default function Home() {
  return (
    <div className="flex min-h-screen flex-col bg-[#FAFAFC] dark:bg-[#0B0F17] text-slate-800 dark:text-slate-100 selection:bg-coral-500 selection:text-white">
      {/* Navigation Header */}
      <Navbar />

      {/* Main Page Content */}
      <main className="flex-1">
        {/* Hero Section with Coral Gradient & Realistic Mobile Mockups */}
        <Hero />

        {/* Core Features Grid (Daily summaries, Photo Save, Search, Charts, Double-Entry, Auto-Update) */}
        <FeatureGrid />

        {/* Interactive Screenshot Showcase (Tabs & Light/Dark Preview) */}
        <InteractiveShowcase />

        {/* Encrypted Google Drive AppData Sync Architecture */}
        <GoogleDriveSyncSection />

        {/* Security & Biometrics Section */}
        <SecuritySection />

        {/* Step-by-Step Android APK Installation Guide */}
        <InstallationGuide />

        {/* Help Center / FAQ Accordion */}
        <FaqSection />
      </main>

      {/* Footer with Links, Release Badges, and Privacy Modal */}
      <Footer />

      {/* Mobile Sticky Quick-Download Bar */}
      <MobileStickyDownload />
    </div>
  );
}
