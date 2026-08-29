import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({
    status: "ok",
    service: "heeey-realtime-api",
    timestamp: new Date().toISOString(),
  });
}
