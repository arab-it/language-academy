require("dotenv").config();

const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.json({
    ok: true,
    service: "arab.it AI Tutor",
    mode: "smart-demo",
  });
});

app.post("/api/tutor", async (req, res) => {
  try {
    const {
      message,
      language = "English",
      level = "Beginner",
    } = req.body;

    if (!message || !message.trim()) {
      return res.status(400).json({
        success: false,
        error: "Message is required.",
      });
    }

    const text = message.trim();
    const lower = text.toLowerCase();

    let reply;

    // =========================
    // ENGLISH
    // =========================

    if (language === "English") {

      // =========================
      // SMART ENGLISH GRAMMAR
      // =========================

      if (/^she go\b/i.test(text)) {
        const corrected = text.replace(/^she go\b/i, "She goes");

        reply =
          `Correction:\n\n` +
          `"${corrected}"\n\n` +
          `Explanation: With "she", use "goes", not "go".\n\n` +
          `Example: "She goes to school every day."`;

      } else if (/^he go\b/i.test(text)) {
        const corrected = text.replace(/^he go\b/i, "He goes");

        reply =
          `Correction:\n\n` +
          `"${corrected}"\n\n` +
          `Explanation: With "he", use "goes", not "go".\n\n` +
          `Example: "He goes to school every day."`;

      } else if (/^i am learn\b/i.test(text)) {
        const corrected = text.replace(/^i am learn\b/i, "I am learning");

        reply =
          `Correction:\n\n` +
          `"${corrected}"\n\n` +
          `Explanation: After "am", use the -ing form of the verb.\n\n` +
          `Learn → learning\n\n` +
          `Example: "I am learning English."`;

      } else if (/^he have\b/i.test(text)) {
        const corrected = text.replace(/^he have\b/i, "He has");

        reply =
          `Correction:\n\n` +
          `"${corrected}"\n\n` +
          `Explanation: With "he", use "has", not "have".\n\n` +
          `Example: "He has a car."`;

      } else if (
        lower.includes("i goes") ||
        lower.includes("he go") ||
        lower.includes("she go")
      ) {
      if (
        lower.includes("i goes") ||
        lower.includes("he go") ||
        lower.includes("she go")
      ) {
        const corrected = text
          .replace(/i goes/gi, "I go")
          .replace(/he go/gi, "he goes")
          .replace(/she go/gi, "she goes");

        reply =
          `Correction:\n\n` +
          `"${corrected}"\n\n` +
          `Explanation: With "I", use "go", not "goes". ` +
          `"Goes" is normally used with he, she, or it.\n\n` +
          `Example: "I go to school every day."`;

      } else if (
        lower.includes("vocabulary") ||
        lower.includes("words")
      ) {
        reply =
          `Let's learn 5 useful English words:\n\n` +
          `1. Learn — to gain knowledge\n` +
          `2. Practice — to train a skill\n` +
          `3. Improve — to become better\n` +
          `4. Speak — to talk in a language\n` +
          `5. Understand — to know the meaning\n\n` +
          `Try making one sentence with "practice".`;

      } else if (
        lower.includes("conversation") ||
        lower.includes("talk")
      ) {
        reply =
          `Let's practice a conversation.\n\n` +
          `Tutor: Hello! How are you today?\n` +
          `Student: I'm good, thank you.\n` +
          `Tutor: What did you do today?\n\n` +
          `Your turn: answer the question in English.`;

      } else if (
        lower.includes("grammar") ||
        lower.includes("correct")
      ) {
        reply =
          `Let's practice grammar at ${level} level.\n\n` +
          `Write one English sentence and I will help you correct it.\n\n` +
          `Example: "I am learning English every day."`;

      } else if (
        lower.includes("hello") ||
        lower.includes("hi")
      ) {
        reply =
          `Hello! 👋\n\n` +
          `I'm your ARAB.IT English Tutor.\n\n` +
          `We can practice vocabulary, grammar, conversation, ` +
          `or sentence correction.\n\n` +
          `What would you like to practice?`;

      } else {
        reply =
          `Great! Let's practice English at ${level} level.\n\n` +
          `You wrote:\n"${text}"\n\n` +
          `Try writing another sentence in English. ` +
          `I can help you with vocabulary, grammar, or conversation.`;
      }

    // =========================
    // ITALIAN
    // =========================

    } else if (language === "Italian") {
      if (
        lower.includes("ciao") ||
        lower.includes("buongiorno")
      ) {
        reply =
          `Ciao! 👋\n\n` +
          `Sono il tuo tutor di italiano ARAB.IT.\n\n` +
          `Possiamo praticare vocabolario, grammatica o conversazione.\n\n` +
          `Cosa vuoi imparare oggi?`;

      } else if (
        lower.includes("vocabolario") ||
        lower.includes("parole")
      ) {
        reply =
          `Impariamo 5 parole italiane:\n\n` +
          `1. Imparare — to learn\n` +
          `2. Parlare — to speak\n` +
          `3. Scrivere — to write\n` +
          `4. Leggere — to read\n` +
          `5. Capire — to understand\n\n` +
          `Prova a creare una frase con "imparare".`;

      } else if (
        lower.includes("grammatica") ||
        lower.includes("correggi")
      ) {
        reply =
          `Certo! Scrivi una frase in italiano e ti aiuterò a correggerla.\n\n` +
          `Livello: ${level}\n\n` +
          `Esempio: "Studio italiano ogni giorno."`;

      } else {
        reply =
          `Ottimo! Pratichiamo l'italiano a livello ${level}.\n\n` +
          `Hai scritto:\n"${text}"\n\n` +
          `Prova a scrivere un'altra frase in italiano.`;
      }

    // =========================
    // ARABIC
    // =========================

    } else if (language === "Arabic") {
      if (
        lower.includes("مرحبا") ||
        lower.includes("السلام")
      ) {
        reply =
          `مرحباً! 👋\n\n` +
          `أنا مدرسك للغة العربية في ARAB.IT.\n\n` +
          `يمكننا ممارسة المفردات أو القواعد أو المحادثة.\n\n` +
          `ماذا تريد أن تتعلم اليوم؟`;

      } else if (
        lower.includes("كلمات") ||
        lower.includes("مفردات")
      ) {
        reply =
          `لنتعلم خمس كلمات عربية:\n\n` +
          `1. كتاب\n` +
          `2. مدرسة\n` +
          `3. بيت\n` +
          `4. تعلم\n` +
          `5. تحدث\n\n` +
          `حاول كتابة جملة باستخدام كلمة "تعلم".`;

      } else if (
        lower.includes("قواعد") ||
        lower.includes("صحح")
      ) {
        reply =
          `بالتأكيد! اكتب جملة باللغة العربية وسأساعدك في تصحيحها.\n\n` +
          `المستوى: ${level}`;

      } else {
        reply =
          `ممتاز! لنتدرّب على العربية بمستوى ${level}.\n\n` +
          `لقد كتبت:\n"${text}"\n\n` +
          `حاول كتابة جملة أخرى باللغة العربية.`;
      }

    } else {
      reply =
        `Let's practice ${language} at ${level} level.\n\n` +
        `You wrote:\n"${text}"`;
    }

    res.json({
      success: true,
      reply,
      mode: "smart-demo",
    });

  } catch (error) {
    console.error("AI Tutor error:", error);

    res.status(500).json({
      success: false,
      error: "AI Tutor request failed.",
    });
  }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`arab.it AI Tutor running on http://localhost:${PORT}`);
  console.log("AI Tutor mode: SMART DEMO");
});

