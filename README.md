<p align="center">
  <h1 align="center">✨ Heeey!</h1>
  <p align="center"><strong>Interactive retro marquee ticker for macOS. Friends drop real-time messages and emojis straight to your screen.</strong></p>
  <p align="center">
    <a href="#-english">English 🇺🇸</a> •
    <a href="#-português">Português 🇧🇷</a> •
    <a href="https://heeey.click">heeey.click</a>
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-macOS%2014.0%2B-black?style=flat-square&logo=apple" alt="macOS 14+">
  <img src="https://img.shields.io/badge/Swift-6.0-orange?style=flat-square&logo=swift" alt="Swift 6">
  <img src="https://img.shields.io/badge/Next.js-15-black?style=flat-square&logo=next.js" alt="Next.js 15">
  <img src="https://img.shields.io/badge/License-MIT-blue?style=flat-square" alt="MIT License">
  <img src="https://img.shields.io/badge/Size-422%20KB-success?style=flat-square" alt="Size">
</p>

---

# 🇺🇸 English

## 💡 What is Heeey!?

**Heeey!** is an open-source macOS companion app and web portal designed to connect friends, teammates, and communities with zero friction.

Share your personal link (e.g., `heeey.click/yourname`). Your friends open it in their mobile or desktop browser—without installing any app—and send quick notes, 1-tap emoji bursts, and pick custom LED styles.

Instantly, a floating **Dynamic Island / Retro Marquee HUD** slides down from the top edge of your Mac screen, scrolls the message at 60/120fps with retro glowing LEDs and synthesized chimes, and smoothly glides back up into the notch.

In a meeting or sharing your screen? The **Menu Bar companion** includes a timed **Anti-Embarrassment (Focus Mode)** to mute and hide the ticker with one click!

---

## 🌟 Key Features

- 🏝️ **Top Screen Floating HUD:** Anchored to the top edge / notch. Stays hidden when idle and springs down only on incoming messages.
- 🖱️ **Full Click-Through:** Ignores mouse clicks while displaying so you can keep typing, coding, and clicking windows underneath without interruption.
- 🛡️ **Anti-Embarrassment / Focus Mode:** Timed mute (15m, 30m, 1h, or indefinite) from the Menu Bar for complete privacy in meetings.
- 🎨 **6 Built-in Visual Themes:**
  - 🟢 **LED Matrix Green:** Classic electronic bus/ticker board.
  - 🟠 **LED Matrix Amber:** Industrial vintage marquee.
  - 🔵 **LED Matrix RGB:** Vibrant glowing blue & pink neon.
  - 🟣 **Cyberpunk Neon:** Dual-glow futuristic aesthetic.
  - ⚪ **Liquid Glass:** Native macOS translucent frosted glass (`ultraThinMaterial`).
  - 👾 **Pixel Art 8-Bit:** 90s arcade bitmap typography.
- 📱 **Mobile-First Web Portal (`heeey.click`):** Real-time browser marquee preview, 1-tap quick emoji reactions, and confetti celebration on submit.
- 🔊 **Retro Synthesized Sounds:** Chimes and beeps via macOS system audio.
- 📜 **Menu Bar History:** Review past received messages anytime.

---

## 📥 How to Install & Run on macOS

### 1. Download the Installer
Download the latest **`Heeey-Installer.dmg`** directly from [heeey.click](https://heeey.click) or from the [Releases](https://github.com/carloseorsantos/heeey/releases) page.

1. Open `Heeey-Installer.dmg`.
2. Drag **Heeey** into your **Applications** folder.
3. Open `Heeey.app`.

---

### ⚠️ How to bypass macOS "Apple could not verify Heeey" notice:

Because Heeey! is an independent open-source project without a paid Apple Developer certificate, macOS Gatekeeper may show a notice on first launch:

> *"Apple could not verify 'Heeey' is free of malware..."*

**To open it safely (you only need to do this once):**

#### Method 1: Right-Click (Easiest)
1. Go to your **Applications** folder.
2. **Right-click (or Control + Click)** on **Heeey.app**.
3. Click **Open** from the context menu.
4. In the dialog that appears, click the **Open** button.

#### Method 2: System Settings
1. Go to **System Settings > Privacy & Security**.
2. Scroll down to the **Security** section.
3. Click **"Open Anyway"** next to *Heeey.app*.

#### Method 3: Terminal (One-liner)
```bash
xattr -cr /Applications/Heeey.app
```

---

## 🛠️ Developer Setup & Monorepo Structure

```
heeey/
├── apps/
│   ├── macos/        # Native macOS App (Swift 6 + SwiftUI + AppKit)
│   └── web/          # Web Portal at heeey.click (Next.js 15 + Tailwind CSS)
├── scripts/
│   └── build-dmg.sh  # Automated DMG installer generator
├── dist/             # Generated installer artifacts (.dmg, .app, .zip)
└── vercel.json       # Vercel monorepo deployment configuration
```

### Running the Mac App from source
```bash
cd apps/macos
swift test       # Run unit tests
swift run Heeey  # Launch in dev mode
```

### Generating the `.dmg` installer
```bash
./scripts/build-dmg.sh
```

### Running the Web Portal locally
```bash
cd apps/web
npm install
npm run dev:ws   # Launches web portal at http://localhost:3000 + WebSocket server
```

---

<br>

# 🇧🇷 Português

## 💡 O que é o Heeey!?

O **Heeey!** é um aplicativo open-source para macOS com portal web integrado feito para aproximar amigos e equipes de trabalho de forma leve, divertida e sem atrito.

Compartilhe seu link pessoal (ex: `heeey.click/carlos`). Seus amigos abrem no celular ou navegador—sem precisar instalar nada—e enviam recados rápidos, reações com emojis em 1-toque e escolhem o estilo de cor do LED.

Na mesma hora, um letreiro animado em estilo **Dynamic Island / HUD Retrô** desliza do topo da sua tela no Mac, rola o texto a 60/120fps com efeitos visuais de LED e chimes retrô, e sobe de volta suavemente para o notch.

Está em reunião ou apresentando a tela? O **Menu Bar companion** possui o **Modo Anti-Vergonha (Foco)** para silenciar e ocultar o letreiro com 1 clique!

---

## 📥 Como Instalar no Mac

### 1. Baixar o Instalador
Baixe o instalador **`Heeey-Installer.dmg`** direto no site [heeey.click](https://heeey.click) ou na aba de [Releases](https://github.com/carloseorsantos/heeey/releases).

1. Abra o arquivo `Heeey-Installer.dmg`.
2. Arraste o ícone do **Heeey** para a pasta **Aplicativos** (`/Applications`).
3. Abra o aplicativo.

---

### ⚠️ Como resolver o aviso do macOS "Apple could not verify Heeey":

Como o Heeey! é um software livre independente, o Gatekeeper do macOS pode exibir um aviso na primeira vez que você abrir:

> *"Apple could not verify 'Heeey' is free of malware..."*

**Para liberar a execução (só precisa fazer uma única vez):**

#### Método 1: Botão Direito (Mais Rápido)
1. Abra sua pasta de **Aplicativos**.
2. Clique com o **botão direito (ou segure `Control` + clique)** no **Heeey.app**.
3. Selecione **"Abrir" (Open)**.
4. Na janela de confirmação, clique no botão **"Abrir"**.

#### Método 2: Ajustes do Sistema
1. Vá em **Ajustes do Sistema > Privacidade e Segurança**.
2. Role até a seção **Segurança**.
3. Clique em **"Abrir Mesmo Assim"** (Open Anyway) ao lado do Heeey.

#### Método 3: Via Terminal
```bash
xattr -cr /Applications/Heeey.app
```

---

## 🤝 Como Contribuir

Contribuições são super bem-vindas!
1. Faça um Fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/novo-tema`)
3. Faça commit das mudanças (`git commit -m 'feat: adiciona tema matrix chuva'`)
4. Envie para a branch (`git push origin feature/novo-tema`)
5. Abra um Pull Request

---

## 📄 Licença

Distribuído sob a licença **MIT**. Veja [LICENSE](file:///Users/carlossantos/Documents/opensource/heeey/LICENSE) para mais detalhes.
