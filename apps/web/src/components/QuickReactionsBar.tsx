"use client";

import React from "react";

const QUICK_EMOJIS = [
  { emoji: "☕", label: "Café" },
  { emoji: "🚀", label: "Foguete" },
  { emoji: "🔥", label: "Fogo" },
  { emoji: "❤️", label: "Coração" },
  { emoji: "🎉", label: "Festa" },
  { emoji: "👾", label: "Alien" },
  { emoji: "🤡", label: "Palhaço" },
  { emoji: "🍕", label: "Pizza" },
  { emoji: "👀", label: "Olhos" },
  { emoji: "⚡", label: "Raio" },
];

interface QuickReactionsBarProps {
  selectedEmoji: string;
  onSelectEmoji: (emoji: string) => void;
}

export const QuickReactionsBar: React.FC<QuickReactionsBarProps> = ({
  selectedEmoji,
  onSelectEmoji,
}) => {
  return (
    <div className="w-full">
      <label className="block text-xs font-medium text-neutral-400 mb-2">
        Reação Rápida em 1-Toque:
      </label>
      <div className="flex flex-wrap gap-2">
        {QUICK_EMOJIS.map((item) => {
          const isSelected = selectedEmoji === item.emoji;
          return (
            <button
              key={item.emoji}
              type="button"
              onClick={() => onSelectEmoji(isSelected ? "" : item.emoji)}
              className={`text-xl p-2 rounded-xl border transition-all transform active:scale-90 ${
                isSelected
                  ? "bg-white/20 border-white shadow-[0_0_10px_rgba(255,255,255,0.4)] scale-110"
                  : "bg-neutral-900/60 border-neutral-800 hover:border-neutral-700 hover:bg-neutral-800/80"
              }`}
              title={item.label}
            >
              {item.emoji}
            </button>
          );
        })}
      </div>
    </div>
  );
};
