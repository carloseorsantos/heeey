import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "var(--background)",
        foreground: "var(--foreground)",
        neon: {
          green: "#26ff59",
          amber: "#ffb71a",
          pink: "#ff1ad6",
          cyan: "#1afff3",
          yellow: "#ffe633",
        },
      },
      fontFamily: {
        mono: ["ui-monospace", "SFMono-Regular", "Menlo", "Monaco", "Consolas", "monospace"],
      },
      animation: {
        "marquee-fast": "marquee 8s linear infinite",
        "marquee-normal": "marquee 12s linear infinite",
        "marquee-slow": "marquee 18s linear infinite",
        "pulse-glow": "pulseGlow 2s ease-in-out infinite",
      },
      keyframes: {
        marquee: {
          "0%": { transform: "translateX(100%)" },
          "100%": { transform: "translateX(-100%)" },
        },
        pulseGlow: {
          "0%, 100%": { opacity: "1", filter: "drop-shadow(0 0 8px rgba(38,255,89,0.8))" },
          "50%": { opacity: "0.8", filter: "drop-shadow(0 0 2px rgba(38,255,89,0.3))" },
        },
      },
    },
  },
  plugins: [],
};
export default config;
