"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import { MessageSquare, ArrowRight, Monitor, Sparkles, Shield, Wifi } from "lucide-react";
import { LivePreviewTicker } from "../components/LivePreviewTicker";

export default function HomePage() {
  const [handle, setHandle] = useState("");
  const router = useRouter();

  const handleJoin = (e: React.FormEvent) => {
    e.preventDefault();
    const cleanHandle = handle.trim().toLowerCase().replace(/[^a-z0-9_-]/g, "");
    if (cleanHandle) {
      router.push(`/${cleanHandle}`);
    }
  };

  return (
    <div className="w-full max-w-2xl mx-auto text-center space-y-8 py-8">
      {/* Badge */}
      <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-green-500/10 border border-green-500/30 text-green-400 text-xs font-medium shadow-[0_0_15px_rgba(38,255,89,0.15)]">
        <Sparkles className="w-3.5 h-3.5" />
        <span>Open Source Mac Ticker & Dynamic HUD</span>
      </div>

      {/* Hero Title */}
      <div className="space-y-3">
        <h1 className="text-4xl sm:text-6xl font-extrabold tracking-tight text-white">
          Mande um recado no letreiro do Mac do seu amigo!
        </h1>
        <p className="text-neutral-400 text-sm sm:text-base max-w-lg mx-auto">
          Um letreiro retrô em estilo Dynamic Island flutuando no topo da tela do Mac. Seus amigos mandam texto e emojis em tempo real.
        </p>
      </div>

      {/* Hero Demo Live Preview */}
      <LivePreviewTicker
        text="bora codar aquele app novo hoje? ☕"
        sender="Ana"
        emoji="🚀"
        theme="led_green"
      />

      {/* Actions: Search Handle or Download Mac App */}
      <div className="space-y-4 max-w-md mx-auto">
        <div className="bg-neutral-900/80 border border-neutral-800 p-2 rounded-2xl shadow-xl backdrop-blur-md">
          <form onSubmit={handleJoin} className="flex items-center gap-2">
            <div className="relative flex-grow flex items-center pl-3">
              <span className="text-neutral-500 font-mono text-sm">heeey.click/</span>
              <input
                type="text"
                value={handle}
                onChange={(e) => setHandle(e.target.value)}
                placeholder="seu-amigo"
                className="w-full pl-1 pr-3 py-2 bg-transparent text-white placeholder-neutral-600 text-sm font-medium focus:outline-none"
                required
              />
            </div>
            <button
              type="submit"
              className="flex items-center gap-1.5 bg-green-500 hover:bg-green-400 text-black px-4 py-2.5 rounded-xl font-bold text-xs transition-all shadow-[0_0_12px_rgba(38,255,89,0.3)] active:scale-95 cursor-pointer"
            >
              <span>Acessar</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </button>
          </form>
        </div>

        {/* Mac App Download Button */}
        <div className="pt-2">
          <a
            href="/downloads/Heeey-Installer.dmg"
            download
            className="inline-flex items-center justify-center gap-2 w-full py-3 px-5 rounded-2xl bg-neutral-900 hover:bg-neutral-800 border border-neutral-700/80 hover:border-neutral-600 text-white font-semibold text-xs transition-all shadow-lg active:scale-98"
          >
            <Monitor className="w-4 h-4 text-green-400" />
            <span>Baixar App para Mac (Installer .DMG)</span>
            <span className="text-[10px] text-neutral-400 font-mono bg-neutral-800 px-2 py-0.5 rounded-full border border-neutral-700">422 KB</span>
          </a>
        </div>
      </div>

      {/* Feature Pillars */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 pt-6 text-left">
        <div className="p-4 rounded-2xl bg-neutral-900/40 border border-neutral-800/60 space-y-2">
          <Monitor className="w-5 h-5 text-green-400" />
          <h3 className="text-sm font-bold text-white">HUD Flutuante</h3>
          <p className="text-xs text-neutral-400">
            Desliza do topo da tela como Dynamic Island e auto-oculta sem atrapalhar o fluxo de trabalho.
          </p>
        </div>

        <div className="p-4 rounded-2xl bg-neutral-900/40 border border-neutral-800/60 space-y-2">
          <Shield className="w-5 h-5 text-yellow-400" />
          <h3 className="text-sm font-bold text-white">Modo Anti-Vergonha</h3>
          <p className="text-xs text-neutral-400">
            Pausa temporizada no Menu Bar para silenciar o letreiro com segurança durante reuniões.
          </p>
        </div>

        <div className="p-4 rounded-2xl bg-neutral-900/40 border border-neutral-800/60 space-y-2">
          <Wifi className="w-5 h-5 text-cyan-400" />
          <h3 className="text-sm font-bold text-white">Sync em Tempo Real</h3>
          <p className="text-xs text-neutral-400">
            Seus amigos abrem o link no iPhone ou Android e mandam recados instantaneamente sem instalar nada.
          </p>
        </div>
      </div>
    </div>
  );
}
