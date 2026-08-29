"use client";

import React from "react";
import { THEMES, TickerThemeId } from "../lib/types";

interface LivePreviewTickerProps {
  text: string;
  sender: string;
  emoji: string;
  theme: TickerThemeId;
}

export const LivePreviewTicker: React.FC<LivePreviewTickerProps> = ({
  text,
  sender,
  emoji,
  theme,
}) => {
  const currentTheme = THEMES[theme] || THEMES.led_green;
  const displayText = text.trim() || "Digite sua mensagem para aparecer no Mac...";
  const displaySender = sender.trim() ? `[${sender.trim()}]: ` : "";
  const displayEmoji = emoji.trim() ? `${emoji.trim()} ` : "";
  const fullHeadline = `${displayEmoji}${displaySender}${displayText}`;

  return (
    <div className="w-full max-w-lg mx-auto my-4">
      <div className="flex items-center justify-between text-xs text-neutral-400 mb-1.5 px-2">
        <span className="flex items-center gap-1.5">
          <span className="inline-block w-2 h-2 rounded-full bg-green-500 animate-pulse" />
          Prévia em Tempo Real (Top HUD Mac)
        </span>
        <span className="font-mono text-[10px] uppercase">{currentTheme.name}</span>
      </div>

      {/* Dynamic Island Style Capsule */}
      <div
        className={`relative overflow-hidden rounded-full py-2.5 px-5 border transition-all duration-300 ${currentTheme.bgClass} ${currentTheme.borderClass}`}
      >
        {/* Background Dot Matrix Pattern for LED themes */}
        {theme.startsWith("led_") && (
          <div
            className="absolute inset-0 opacity-15 pointer-events-none"
            style={{
              backgroundImage:
                "radial-gradient(circle, #ffffff 1px, transparent 1px)",
              backgroundSize: "6px 6px",
            }}
          />
        )}

        <div className="relative flex items-center overflow-hidden whitespace-nowrap">
          <div className="animate-marquee-normal inline-flex items-center gap-3">
            <span
              className={`font-mono text-sm sm:text-base font-bold tracking-wider ${currentTheme.textClass}`}
            >
              {fullHeadline}
            </span>
          </div>
        </div>
      </div>
    </div>
  );
};
