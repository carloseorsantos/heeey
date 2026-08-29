export type TickerThemeId =
  | "led_green"
  | "led_amber"
  | "led_rgb"
  | "cyberpunk_neon"
  | "liquid_glass"
  | "pixel_8bit";

export interface TickerThemeOption {
  id: TickerThemeId;
  name: string;
  primaryColor: string;
  secondaryColor: string;
  accentColor: string;
  bgClass: string;
  borderClass: string;
  textClass: string;
}

export const THEMES: Record<TickerThemeId, TickerThemeOption> = {
  led_green: {
    id: "led_green",
    name: "LED Verde",
    primaryColor: "#26ff59",
    secondaryColor: "#0d6622",
    accentColor: "#26ff59",
    bgClass: "bg-[#0b120c] border-[#26ff59]/40",
    borderClass: "border-[#26ff59]/50 shadow-[0_0_15px_rgba(38,255,89,0.3)]",
    textClass: "text-[#26ff59] drop-shadow-[0_0_8px_rgba(38,255,89,0.8)]",
  },
  led_amber: {
    id: "led_amber",
    name: "LED Âmbar",
    primaryColor: "#ffb71a",
    secondaryColor: "#804e00",
    accentColor: "#ffb71a",
    bgClass: "bg-[#140e04] border-[#ffb71a]/40",
    borderClass: "border-[#ffb71a]/50 shadow-[0_0_15px_rgba(255,183,26,0.3)]",
    textClass: "text-[#ffb71a] drop-shadow-[0_0_8px_rgba(255,183,26,0.8)]",
  },
  led_rgb: {
    id: "led_rgb",
    name: "LED RGB",
    primaryColor: "#33d9ff",
    secondaryColor: "#ff3399",
    accentColor: "#33d9ff",
    bgClass: "bg-[#050e14] border-[#33d9ff]/40",
    borderClass: "border-[#33d9ff]/50 shadow-[0_0_15px_rgba(51,217,255,0.3)]",
    textClass: "text-[#33d9ff] drop-shadow-[0_0_8px_rgba(51,217,255,0.8)]",
  },
  cyberpunk_neon: {
    id: "cyberpunk_neon",
    name: "Cyberpunk Neon",
    primaryColor: "#ff1ad6",
    secondaryColor: "#1afff3",
    accentColor: "#ff1ad6",
    bgClass: "bg-[#140417] border-[#ff1ad6]/40",
    borderClass: "border-[#ff1ad6]/60 shadow-[0_0_20px_rgba(255,26,214,0.4)]",
    textClass: "text-[#ff1ad6] drop-shadow-[0_0_10px_rgba(255,26,214,0.9)]",
  },
  liquid_glass: {
    id: "liquid_glass",
    name: "Liquid Glass",
    primaryColor: "#ffffff",
    secondaryColor: "#cccccc",
    accentColor: "#3b82f6",
    bgClass: "bg-white/10 backdrop-blur-md border-white/20",
    borderClass: "border-white/30 shadow-[0_0_20px_rgba(255,255,255,0.15)]",
    textClass: "text-white drop-shadow-[0_0_4px_rgba(255,255,255,0.5)]",
  },
  pixel_8bit: {
    id: "pixel_8bit",
    name: "Pixel Art 8-Bit",
    primaryColor: "#ffe633",
    secondaryColor: "#33bbff",
    accentColor: "#ffe633",
    bgClass: "bg-[#100b21] border-[#ffe633]/40",
    borderClass: "border-[#ffe633]/60 shadow-[0_0_15px_rgba(255,230,51,0.3)]",
    textClass: "text-[#ffe633] drop-shadow-[0_0_8px_rgba(255,230,51,0.8)]",
  },
};

export interface SendMessagePayload {
  handle: string;
  text: string;
  sender?: string;
  emoji?: string;
  theme: TickerThemeId;
  sound?: boolean;
}
