import "./style.css";
import { Elm } from "./Main.elm";
import { parseMove } from "./parseMove";
import { launchConfetti } from "./confetti";
import { TranscriptWebSocket } from "./transcript";

const app = Elm.Main.init({
  node: document.getElementById("app")!,
});

app.ports.launchConfetti.subscribe(() => {
  launchConfetti();
});

new TranscriptWebSocket("wss://meeting-data.bot.recall.ai/api/v1/transcript", async (text) => {
  const move = await parseMove(text);
  if (move) {
    app.ports.receiveMove.send(move);
  }
})
