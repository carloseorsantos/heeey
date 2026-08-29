"use client";

import React from "react";
import { THEMES, TickerThemeId } from "../lib/types";

interface LEDColorPickerProps {
  selectedTheme: TickerThemeId;
  onSelectTheme: (theme: TickerThemeId) => void;
}

export const LEDColorPicker: React.FC<LEDColorPickerProps> = ({
  selectedTheme,
  onSelectTheme,
}) => {
  return (
    <div className="w-full">
      <label className="block text-xs font-medium text-neutral-400 mb-2">
        Estilo do LED / Tema no Mac:
      </label>
      <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
        {Object.values(THEMES).map((theme) => {
          const isSelected = selectedTheme === theme.id;
          return (
            <button
              key={theme.id}
              type="button"
              onClick={() => onSelectTheme(theme.id)}
              className={`flex items-center gap-2.5 px-3 py-2 rounded-xl text-left border text-xs font-medium transition-all ${
                isSelected
                  ? "bg-neutral-800/90 border-white/80 shadow-[0_0_12px_rgba(255,255,255,0.2)] text-white"
                  : "bg-neutral-900/50 border-neutral-800 text-neutral-400 hover:border-neutral-700 hover:text-neutral-200"
              }`}
            >
              <span
                className="w-3 h-3 rounded-full flex-shrink-0 shadow-sm"
                style={{ backgroundColor: theme.primaryColor }}
              />
              <span className="truncate">{theme.name}</span>
            </button>
          );
        })}
      </div>
    </div>
  );
};
