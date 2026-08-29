import { SendMessagePayload } from "./types";

export async function sendMessageToTicker(payload: SendMessagePayload): Promise<{ success: boolean; message: string }> {
  try {
    const response = await fetch("/api/send", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(errorData.error || `Erro HTTP ${response.status}`);
    }

    return {
      success: true,
      message: "Mensagem enviada com sucesso para o letreiro!",
    };
  } catch (error: any) {
    console.error("Erro ao enviar mensagem:", error);
    return {
      success: false,
      message: error.message || "Não foi possível enviar a mensagem. Verifique a conexão.",
    };
  }
}
