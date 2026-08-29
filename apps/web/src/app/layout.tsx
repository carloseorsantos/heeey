import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Heeey! — Letreiro Interativo no Mac para seus Amigos",
  description: "Mande mensagens e emojis direto para o letreiro retro no topo da tela do Mac dos seus amigos em tempo real!",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="pt-BR" className="dark">
      <body className="antialiased bg-[#08080c] text-white flex flex-col min-h-screen selection:bg-green-500 selection:text-black">
        <div className="fixed inset-0 scanlines z-50 pointer-events-none opacity-40" />
        
        {/* Subtle grid background */}
        <div 
          className="fixed inset-0 pointer-events-none opacity-20"
          style={{
            backgroundImage: "radial-gradient(circle at 1px 1px, #333 1px, transparent 0)",
            backgroundSize: "24px 24px"
          }}
        />

        <main className="relative z-10 flex-grow flex flex-col items-center justify-center p-4 sm:p-6">
          {children}
        </main>

        <footer className="relative z-10 py-6 text-center text-xs text-neutral-500 border-t border-neutral-900">
          <p>
            <span className="text-green-400 font-semibold">Heeey!</span> — Projeto Open Source para macOS & Web.
          </p>
        </footer>
      </body>
    </html>
  );
}
