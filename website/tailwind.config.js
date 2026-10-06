/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'class',
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        coral: {
          50: '#FFF2F1',
          100: '#FFE1DF',
          200: '#FFC4C0',
          300: '#FF9E97',
          400: '#FF756C',
          500: '#FF5E57', // Primary Realbyte Coral Red
          600: '#EE3E37',
          700: '#CA241D',
          800: '#A4211B',
          900: '#86221D',
        },
        warmOrange: {
          50: '#FFF5F0',
          100: '#FFE7DB',
          200: '#FFCEB8',
          300: '#FFAF8C',
          400: '#FF9163',
          500: '#FF7A45', // Primary Realbyte Warm Orange
          600: '#F05719',
          700: '#C73F0A',
          800: '#9E340E',
          900: '#802E11',
        },
        surface: {
          light: '#FAFAFC',
          dark: '#0B0F17',
          card: '#111827',
          cardLight: '#FFFFFF',
        }
      },
      fontFamily: {
        sans: ['var(--font-geist-sans)', 'system-ui', 'sans-serif'],
        mono: ['var(--font-geist-mono)', 'monospace'],
      },
      boxShadow: {
        'glow-coral': '0 10px 25px -5px rgba(255, 94, 87, 0.35)',
        'glow-orange': '0 10px 25px -5px rgba(255, 122, 69, 0.35)',
        'phone': '0 25px 60px -15px rgba(0, 0, 0, 0.25), 0 0 0 1px rgba(0, 0, 0, 0.06)',
        'phone-dark': '0 25px 60px -15px rgba(0, 0, 0, 0.6), 0 0 0 1px rgba(255, 255, 255, 0.1)',
      },
      animation: {
        'float-slow': 'float 6s ease-in-out infinite',
        'float-reverse': 'floatRev 7s ease-in-out infinite',
        'pulse-subtle': 'pulseSubtle 3s ease-in-out infinite',
      },
      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-12px)' },
        },
        floatRev: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(10px)' },
        },
        pulseSubtle: {
          '0%, 100%': { opacity: '1' },
          '50%': { opacity: '0.8' },
        }
      }
    },
  },
  plugins: [],
};
