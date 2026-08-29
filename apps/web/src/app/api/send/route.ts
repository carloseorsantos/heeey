import { NextRequest, NextResponse } from "next/server";

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { handle, text, sender, emoji, theme, sound } = body;

    if (!handle || typeof handle !== "string") {
      return NextResponse.json(
        { error: "O apelido (handle) de destino é obrigatório." },
        { status: 400 }
      );
    }

    if (!text && !emoji) {
      return NextResponse.json(
        { error: "A mensagem ou emoji não pode estar vazio." },
        { status: 400 }
      );
    }

    const payload = {
      id: crypto.randomUUID(),
      handle: handle.toLowerCase(),
      text: (text || "").slice(0, 120),
      sender: sender ? sender.slice(0, 30) : undefined,
      emoji: emoji ? emoji.slice(0, 8) : undefined,
      theme: theme || "led_green",
      sound: sound ?? true,
      timestamp: new Date().toISOString(),
    };

    // If Supabase or an external WebSocket broker URL is configured in process.env, broadcast it here.
    // e.g. await broadcastToRealtimeChannel(payload);

    return NextResponse.json({
      success: true,
      message: "Mensagem transmitida com sucesso!",
      data: payload,
    });
  } catch (error: any) {
    console.error("API /api/send Error:", error);
    return NextResponse.json(
      { error: "Erro interno no servidor ao processar a mensagem." },
      { status: 500 }
    );
  }
}
