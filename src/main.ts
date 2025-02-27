import "./style.css";

import { Elm } from "./Main.elm";
import confetti from "canvas-confetti";

const app = Elm.Main.init({
  node: document.getElementById("app")!,
});

app.ports.launchConfetti.subscribe(() => {
  launchConfetti();
});

function randomInRange(min: number, max: number) {
  return Math.random() * (max - min) + min;
}

function launchConfetti() {
  const duration = 10 * 1000;
  const animationEnd = Date.now() + duration;
  const defaults = {
    startVelocity: 30,
    spread: 360,
    ticks: 60,
    zIndex: 0,
  };

  const interval = setInterval(function () {
    const timeLeft = animationEnd - Date.now();

    if (timeLeft <= 0) {
      return clearInterval(interval);
    }

    var particleCount = 100 * (timeLeft / duration);

    confetti({
      ...defaults,
      particleCount,
      origin: { x: randomInRange(0.1, 0.3), y: Math.random() - 0.2 },
    });

    confetti({
      ...defaults,
      particleCount,
      origin: { x: randomInRange(0.7, 0.9), y: Math.random() - 0.2 },
    });
  }, 250);
}
