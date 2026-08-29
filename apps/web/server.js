const { createServer } = require("http");
const { parse } = require("url");
const next = require("next");
const { WebSocketServer } = require("ws");

const dev = process.env.NODE_ENV !== "production";
const hostname = "localhost";
const port = parseInt(process.env.PORT || "3000", 10);

const app = next({ dev, hostname, port });
const handle = app.getRequestHandler();

app.prepare().then(() => {
  const server = createServer(async (req, res) => {
    try {
      const parsedUrl = parse(req.url, true);

      // Handle REST broadcast directly to connected WebSocket clients
      if (req.method === "POST" && parsedUrl.pathname === "/api/send") {
        let body = "";
        req.on("data", (chunk) => {
          body += chunk.toString();
        });
        req.on("end", () => {
          try {
            const data = JSON.parse(body);
            const targetHandle = (data.handle || "").toLowerCase();

            // Broadcast to connected WebSocket clients for this handle
            let clientCount = 0;
            wss.clients.forEach((client) => {
              if (client.readyState === 1 && (!client.userHandle || client.userHandle === targetHandle)) {
                client.send(JSON.stringify(data));
                clientCount++;
              }
            });

            res.writeHead(200, { "Content-Type": "application/json" });
            res.end(
              JSON.stringify({
                success: true,
                message: `Mensagem transmitida para ${clientCount} letreiro(s) ativo(s)!`,
                data,
              })
            );
          } catch (err) {
            res.writeHead(400, { "Content-Type": "application/json" });
            res.end(JSON.stringify({ error: "Payload JSON inválido" }));
          }
        });
        return;
      }

      await handle(req, res, parsedUrl);
    } catch (err) {
      console.error("Error occurred handling", req.url, err);
      res.statusCode = 500;
      res.end("internal server error");
    }
  });

  // Setup WebSocket Server for Realtime sync
  const wss = new WebSocketServer({ noServer: true });

  server.on("upgrade", (req, socket, head) => {
    const { pathname, query } = parse(req.url, true);

    if (pathname === "/ws" || pathname === "/api/ws") {
      wss.handleUpgrade(req, socket, head, (ws) => {
        ws.userHandle = (query.handle || "").toLowerCase();
        wss.emit("connection", ws, req);
      });
    } else {
      socket.destroy();
    }
  });

  wss.on("connection", (ws) => {
    console.log(`🟢 Mac conectado no canal @${ws.userHandle || "todos"}`);

    ws.on("close", () => {
      console.log(`🔴 Mac desconectado do canal @${ws.userHandle || "todos"}`);
    });
  });

  server.listen(port, () => {
    console.log(`\n🚀 Heeey! Server rodando em http://${hostname}:${port}`);
    console.log(`📡 WebSocket Realtime pronto em ws://${hostname}:${port}/ws\n`);
  });
});
