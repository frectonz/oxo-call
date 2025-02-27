/// <reference types="vite/client" />

declare module "*.elm" {
  export const Elm: ElmInstance<{
    launchConfetti: PortFromElm<{}>;
    receiveMove: PortToElm<number>;
  }>;
}
