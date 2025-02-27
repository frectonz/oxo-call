import { ArkErrors, type } from "arktype";
import { GoogleGenerativeAI, SchemaType } from "@google/generative-ai";

const genAI = new GoogleGenerativeAI(import.meta.env.VITE_GEMINI_KEY);
const model = genAI.getGenerativeModel({
  model: "gemini-1.5-pro",
  generationConfig: {
    responseMimeType: "application/json",
    responseSchema: {
      description: "Tic Tac Toe Move Parser",
      type: SchemaType.STRING,
      enum: [
        "TOP_LEFT",
        "TOP_MIDDLE",
        "TOP_RIGHT",
        "MODDLE_LEFT",
        "MIDDLE_MIDDLE",
        "MIDDLE_RIGHT",
        "BOTTOM_LEFT",
        "BOTTOM_MIDDLE",
        "BOTTOM_RIGHT",
        "NULL",
      ],
    },
  },
});

const move = type(
  "'TOP_LEFT' | 'TOP_MIDDLE' | 'TOP_RIGHT' | 'MIDDLE_LEFT' | 'MIDDLE_MIDDLE' | 'MIDDLE_RIGHT' | 'BOTTOM_LEFT' | 'BOTTOM_MIDDLE' | 'BOTTOM_RIGHT'",
);

type Move = typeof move.infer;

const keys: Record<Move, number> = {
  TOP_LEFT: 0,
  TOP_MIDDLE: 1,
  TOP_RIGHT: 2,
  MIDDLE_LEFT: 3,
  MIDDLE_MIDDLE: 4,
  MIDDLE_RIGHT: 5,
  BOTTOM_LEFT: 6,
  BOTTOM_MIDDLE: 7,
  BOTTOM_RIGHT: 8,
};

export async function parseMove(transcript: string) {
  const result = await model.generateContent(
    `Parse out the tic tac toe move the following text implies return a null if you can't find a move: ${transcript}`,
  );
  const text = result.response.text();
  const m = move(text);

  if (m instanceof ArkErrors) {
    return null;
  }

  return keys[m];
}
