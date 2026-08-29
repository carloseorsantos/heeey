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

    const cleanHandle = handle.toLowerCase().trim().replace(/[^a-z0-9_-]/g, "");
    const payload = {
      id: crypto.randomUUID(),
      handle: cleanHandle,
      text: (text || "").slice(0, 120),
      sender: sender ? sender.slice(0, 30) : undefined,
      emoji: emoji ? emoji.slice(0, 8) : undefined,
      theme: theme || "led_green",
      sound: sound ?? true,
      timestamp: new Date().toISOString(),
    };

    // Support server-side Supabase environment variables (no NEXT_PUBLIC_ prefix needed)
    const supabaseUrl = process.env.SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL;
    const supabaseKey = process.env.SUPABASE_KEY || process.env.SUPABASE_ANON_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

    if (supabaseUrl && supabaseKey) {
      try {
        const broadcastEndpoint = `${supabaseUrl.replace(/\/+$/, "")}/realtime/v1/api/broadcast`;
        const res = await fetch(broadcastEndpoint, {
          method: "POST",
          headers: {
            apikey: supabaseKey,
            Authorization: `Bearer ${supabaseKey}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            messages: [
              {
                topic: `heeey:${cleanHandle}`,
                event: "ticker_message",
                payload: payload,
              },
            ],
          }),
        });

        if (!res.ok) {
          console.warn("Supabase broadcast returned status:", res.status);
        }
      } catch (broadcastErr) {
        console.error("Supabase broadcast error:", broadcastErr);
      }
    }

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
