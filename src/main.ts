import "./style.css";
import { Elm } from "./Main.elm";
import { launchConfetti } from "./confetti";

const app = Elm.Main.init({
  node: document.getElementById("app")!,
});

app.ports.launchConfetti.subscribe(() => {
  launchConfetti();
});
