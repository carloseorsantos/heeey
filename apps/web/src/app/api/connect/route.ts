import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const rawHandle = searchParams.get("handle") || "carlos";
  const handle = rawHandle.toLowerCase().trim().replace(/[^a-z0-9_-]/g, "");

  const supabaseUrl = process.env.SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL;
  const supabaseKey = process.env.SUPABASE_KEY || process.env.SUPABASE_ANON_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (supabaseUrl && supabaseKey) {
    // Transform https://xxx.supabase.co to wss://xxx.supabase.co/realtime/v1/websocket
    const wsHost = supabaseUrl.replace(/^http:\/\//, "ws://").replace(/^https:\/\//, "wss://").replace(/\/+$/, "");
    const wsUrl = `${wsHost}/realtime/v1/websocket?apikey=${encodeURIComponent(supabaseKey)}&vsn=1.0.0`;

    return NextResponse.json({
      success: true,
      mode: "supabase_realtime",
      wsUrl: wsUrl,
      topic: `realtime:heeey:${handle}`,
      handle: handle,
    });
  }

  // Fallback to custom domain direct WebSocket server
  return NextResponse.json({
    success: true,
    mode: "direct_websocket",
    wsUrl: `wss://heeey.click/ws?handle=${handle}`,
    topic: `heeey:${handle}`,
    handle: handle,
  });
}
