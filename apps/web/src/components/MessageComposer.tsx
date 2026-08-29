"use client";

import React, { useState } from "react";
import confetti from "canvas-confetti";
import { TickerThemeId } from "../lib/types";
import { sendMessageToTicker } from "../lib/realtime";
import { QuickReactionsBar } from "./QuickReactionsBar";
import { LEDColorPicker } from "./LEDColorPicker";
import { LivePreviewTicker } from "./LivePreviewTicker";
import { Send, Sparkles, CheckCircle2, AlertCircle } from "lucide-react";

interface MessageComposerProps {
  targetHandle: string;
}

export const MessageComposer: React.FC<MessageComposerProps> = ({ targetHandle }) => {
  const [text, setText] = useState("");
  const [sender, setSender] = useState("");
  const [emoji, setEmoji] = useState("🚀");
  const [theme, setTheme] = useState<TickerThemeId>("led_green");
  const [playSound, setPlaySound] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [statusMessage, setStatusMessage] = useState<{ type: "success" | "error"; text: string } | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!text.trim() && !emoji.trim()) return;

    setIsSubmitting(true);
    setStatusMessage(null);

    const res = await sendMessageToTicker({
      handle: targetHandle,
      text: text.trim() || "(sem texto)",
      sender: sender.trim() || undefined,
      emoji: emoji.trim() || undefined,
      theme,
      sound: playSound,
    });

    setIsSubmitting(false);

    if (res.success) {
      setStatusMessage({ type: "success", text: "Enviado direto para o topo da tela do Mac! ✨" });
      setText("");

      // Confetti burst
      try {
        confetti({
          particleCount: 50,
          spread: 60,
          origin: { y: 0.8 },
        });
      } catch (_) {}
    } else {
      setStatusMessage({ type: "error", text: res.message });
    }
  };

  return (
    <div className="w-full max-w-lg mx-auto bg-neutral-950/80 backdrop-blur-xl border border-neutral-800/80 rounded-3xl p-6 sm:p-8 shadow-2xl">
      {/* Target User Banner */}
      <div className="flex items-center justify-between pb-5 border-b border-neutral-800/60 mb-5">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-green-500/20 to-cyan-500/20 border border-green-500/40 flex items-center justify-center text-lg shadow-[0_0_15px_rgba(38,255,89,0.2)]">
            💬
          </div>
          <div>
            <h2 className="font-bold text-white text-base sm:text-lg flex items-center gap-2">
              Enviar para <span className="text-green-400">@{targetHandle}</span>
            </h2>
            <p className="text-xs text-neutral-400">Aparecerá instantaneamente no letreiro flutuante</p>
          </div>
        </div>
        <div className="hidden sm:flex items-center gap-1 text-[11px] font-mono px-2.5 py-1 rounded-full bg-neutral-900 border border-neutral-800 text-neutral-400">
          <span className="w-1.5 h-1.5 rounded-full bg-green-400 animate-ping" />
          Online
        </div>
      </div>

      {/* Live Preview Ticker */}
      <LivePreviewTicker text={text} sender={sender} emoji={emoji} theme={theme} />

      <form onSubmit={handleSubmit} className="space-y-5 mt-4">
        {/* Sender Name */}
        <div>
          <label className="block text-xs font-medium text-neutral-400 mb-1.5">
            Seu Nome ou Apelido (Opcional):
          </label>
          <input
            type="text"
            value={sender}
            onChange={(e) => setSender(e.target.value)}
            placeholder="Ex: Pedro, Ana, Seu Squad..."
            maxLength={30}
            className="w-full px-4 py-2.5 rounded-xl bg-neutral-900/80 border border-neutral-800 text-white placeholder-neutral-500 text-sm focus:outline-none focus:border-green-500/80 focus:ring-1 focus:ring-green-500/50 transition-all"
          />
        </div>

        {/* Message Content */}
        <div>
          <div className="flex items-center justify-between mb-1.5">
            <label className="text-xs font-medium text-neutral-400">
              Sua Mensagem:
            </label>
            <span className="text-[11px] text-neutral-500">{text.length}/100</span>
          </div>
          <textarea
            value={text}
            onChange={(e) => setText(e.target.value)}
            placeholder="eae, bora almoçar? ou aquele PR tá aprovado!"
            maxLength={100}
            rows={3}
            required
            className="w-full px-4 py-3 rounded-xl bg-neutral-900/80 border border-neutral-800 text-white placeholder-neutral-500 text-sm focus:outline-none focus:border-green-500/80 focus:ring-1 focus:ring-green-500/50 transition-all resize-none"
          />
        </div>

        {/* Quick Reactions */}
        <QuickReactionsBar selectedEmoji={emoji} onSelectEmoji={setEmoji} />

        {/* Theme Picker */}
        <LEDColorPicker selectedTheme={theme} onSelectTheme={setTheme} />

        {/* Sound Option */}
        <div className="flex items-center gap-2 pt-1">
          <input
            type="checkbox"
            id="sound-check"
            checked={playSound}
            onChange={(e) => setPlaySound(e.target.checked)}
            className="w-4 h-4 rounded bg-neutral-900 border-neutral-700 text-green-500 focus:ring-green-500/40"
          />
          <label htmlFor="sound-check" className="text-xs text-neutral-400 cursor-pointer">
            Tocar sino/chime retrô no Mac ao chegar
          </label>
        </div>

        {/* Status Message */}
        {statusMessage && (
          <div
            className={`flex items-center gap-2 p-3 rounded-xl text-xs font-medium ${
              statusMessage.type === "success"
                ? "bg-green-500/10 border border-green-500/30 text-green-400"
                : "bg-red-500/10 border border-red-500/30 text-red-400"
            }`}
          >
            {statusMessage.type === "success" ? (
              <CheckCircle2 className="w-4 h-4 flex-shrink-0" />
            ) : (
              <AlertCircle className="w-4 h-4 flex-shrink-0" />
            )}
            <span>{statusMessage.text}</span>
          </div>
        )}

        {/* Send Button */}
        <button
          type="submit"
          disabled={isSubmitting || (!text.trim() && !emoji.trim())}
          className="w-full flex items-center justify-center gap-2 py-3.5 px-6 rounded-2xl bg-gradient-to-r from-green-500 to-emerald-600 hover:from-green-400 hover:to-emerald-500 text-black font-bold text-sm shadow-[0_0_20px_rgba(38,255,89,0.3)] active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none transition-all cursor-pointer"
        >
          {isSubmitting ? (
            <>
              <Sparkles className="w-4 h-4 animate-spin" />
              <span>Transmitindo para o Mac...</span>
            </>
          ) : (
            <>
              <Send className="w-4 h-4" />
              <span>Mandar no Letreiro Agora ⚡</span>
            </>
          )}
        </button>
      </form>
    </div>
  );
};
