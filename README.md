<p align="center">
  <h1 align="center">✨ Heeey!</h1>
  <p align="center"><strong>Letreiro interativo flutuante no macOS para seus amigos mandarem mensagens e emojis em tempo real.</strong></p>
  <p align="center">
    <a href="#-funcionalidades">Funcionalidades</a> •
    <a href="#-arquitetura">Arquitetura</a> •
    <a href="#-como-rodar-o-app-macos">App macOS</a> •
    <a href="#-portal-web-dos-amigos">Portal Web</a> •
    <a href="#-temas-visuais">Temas</a> •
    <a href="#-licença">Licença</a>
  </p>
</p>

---

## 💡 O que é o Heeey?

**Heeey!** é um app open-source para macOS pensado para aproximar squads, amigos e criadores de forma divertida e sem atrito.

Compartilhe o seu link pessoal (ex: `heeey.click/carlos`). Seus amigos abrem a página no celular ou navegador — sem precisar instalar nada — e enviam recados rápidos, reações com emojis e estilos de LED customizados. 

Instantaneamente, um letreiro animado em estilo **Dynamic Island / HUD Retrô** desliza do topo da sua tela no Mac, rola o texto a 60/120fps com efeitos visuais e sons retrô sintetizados, e recolhe suavemente quando a mensagem termina.

E se você estiver em uma reunião importante ou apresentando a tela? O **Menu Bar Companion** possui o **Modo Anti-Vergonha (Foco)** com pausa temporizada para silenciar o letreiro em 1 clique!

---

## 🌟 Funcionalidades

- 🏝️ **HUD Flutuante Superior:** Ancorado no topo da tela (estilo Dynamic Island). Permanece invisível e desliza para baixo apenas ao receber novidades.
- 🖱️ **Click-Through Total:** A janela não rouba o foco do teclado e permite clicar nos seus apps por baixo sem interromper o trabalho.
- 🛡️ **Modo Foco / Anti-Vergonha:** Pausa de 15m, 30m, 1h ou indefinida acionável pelo Menu Bar para garantir privacidade durante reuniões.
- 🎨 **Coleção de Temas:**
  - 🟢 **LED Matrix Verde:** Estética clássica de painéis eletrônicos e ônibus.
  - 🟠 **LED Matrix Âmbar:** Letreiro industrial retrô.
  - 🔵 **LED Matrix RGB:** Efeito neon luminoso.
  - 🟣 **Cyberpunk Neon:** Efeito dual-glow magenta e ciano.
  - ⚪ **Liquid Glass:** Visual nativo macOS translúcido com `ultraThinMaterial`.
  - 👾 **Pixel Art 8-Bit:** Tipografia bitmap arcade dos anos 90.
- 📱 **Portal Web Mobile-First:** Seus amigos acessam no iPhone/Android com prévia do letreiro em tempo real, botões de reações em 1-toque e confetes na confirmação.
- 🔊 **Chimes & Efeitos Sonoros:** Sons retrô sintetizados via sistema (`NSSound`).
- 📜 **Histórico no Menu Bar:** Acesse as últimas 50 mensagens recebidas quando quiser.

---

## 🏗️ Arquitetura do Projeto

O projeto é estruturado como um monorepo modular:

```
heeey/
├── apps/
│   ├── macos/        # App Nativo macOS (Swift 6 + SwiftUI + AppKit NSPanel)
│   └── web/          # Portal Web dos Amigos (Next.js 15 + Tailwind CSS)
├── .github/
│   └── workflows/    # CI/CD automatizado no GitHub Actions
├── LICENSE           # Licença MIT
└── README.md
```

---

## 💻 Como Rodar o App macOS

### Pré-requisitos
- macOS 14.0+ (Sonoma ou mais recente)
- Xcode 15+ ou Swift 6.0+

### Executando em desenvolvimento
```bash
cd apps/macos

# Executar suíte de testes
swift test

# Compilar e rodar o executável nativo
swift run Heeey
```

---

## 🌐 Portal Web dos Amigos

### Pré-requisitos
- Node.js 18+ ou 20+
- npm, pnpm ou yarn

### Executando localmente
```bash
cd apps/web

# Instalar dependências
npm install

# Rodar servidor de desenvolvimento
npm run dev
```

Abra [http://localhost:3000](http://localhost:3000) no navegador ou acesse `http://localhost:3000/seu-apelido` para testar o envio de mensagens.

---

## 🤝 Como Contribuir

Contribuições são super bem-vindas! Sinta-se livre para:
1. Fazer um Fork do projeto
2. Criar uma branch para sua feature (`git checkout -b feature/novo-tema`)
3. Fazer commit das suas alterações (`git commit -m 'feat: adiciona tema matrix chuva'`)
4. Fazer push para a branch (`git push origin feature/novo-tema`)
5. Abrir um Pull Request

---

## 📄 Licença

Distribuído sob a licença **MIT**. Veja [LICENSE](file:///Users/carlossantos/Documents/opensource/heeey/LICENSE) para mais informações.
