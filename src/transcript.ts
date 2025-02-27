type Word = {
  text: string;
  start_time: number;
  end_time: number;
}

type Transcript = {
  speaker: string | null;
  speaker_id: string | null;
  transcription_provider_speaker?: string;
  language: string | null;
  original_transcript_id: number;
  words: Word[];
  is_final: boolean;
}

type TranscriptMessage = {
  bot_id: string;
  transcript: Transcript;
}

export class TranscriptWebSocket {
  private wsUrl: string;
  private ws: WebSocket | null = null;
  private retryInterval: number | null = null;
  private onFinalTranscript: (text: string) => Promise<void>;
  private readonly RECONNECT_RETRY_INTERVAL_MS = 3000;

  constructor(wsUrl: string, onFinalTranscript: (text: string) => Promise<void>) {
    this.wsUrl = wsUrl;
    this.onFinalTranscript = onFinalTranscript;
    this.connectWebSocket();
  }

  private connectWebSocket(): void {
    if (this.ws) return;

    this.ws = new WebSocket(this.wsUrl);

    this.ws.onopen = () => {
      console.log("Connected to WebSocket server");
      if (this.retryInterval) {
        clearInterval(this.retryInterval);
        this.retryInterval = null;
      }
    };

    this.ws.onmessage = async (event: MessageEvent) => {
      const message: TranscriptMessage = JSON.parse(event.data);
      const transcript = message.transcript;

      if (transcript.is_final) {
        const text = transcript.words.map((word) => word.text).join(" ");
        this.onFinalTranscript(text);
      }
    };

    this.ws.onclose = () => {
      console.log("WebSocket closed. Attempting to reconnect...");
      this.ws = null;
      this.attemptReconnect();
    };

    this.ws.onerror = (error: Event) => {
      console.error("WebSocket error:", error);
      this.ws?.close();
    };
  }

  private attemptReconnect(): void {
    if (!this.retryInterval) {
      this.retryInterval = window.setInterval(() => {
        console.log("Attempting to reconnect to WebSocket...");
        this.connectWebSocket();
      }, this.RECONNECT_RETRY_INTERVAL_MS);
    }
  }
}
