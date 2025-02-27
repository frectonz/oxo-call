import elmPlugin from "vite-plugin-elm";
import tailwindcss from "@tailwindcss/vite";

export default {
  plugins: [elmPlugin(), tailwindcss()],
};
