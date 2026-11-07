# Research: Voice generation (TTS) for Chip Heist

Researched 2026-11-07. This answers the story-bible open question
"Voice pipeline: which TTS tool". **Nothing here is decided yet.** The user
picks from these options.

**What we need** (from `story-bible.md`)
- Every line is voiced in a **cheerful AI-assistant voice**.
- Four different Scam personalities: Paranoid, Lowercase, Hype, Calm Podcast.
- Also The Admin, Mom, the Cat, the Robotaxi, the news anchor, the podcast
  host and the ClosedAI AI.
- The Admin's voice **glitches into a distorted voice** when he wakes.
- Lines are rendered offline as audio files and uploaded to Roblox, so the
  license must allow commercial use (paid game passes are possible later).

---

## Shortlist (commercial use allowed)

| Repo | License | Voices / control | Runs on a Mac? | Fit for us |
|---|---|---|---|---|
| **[hexgrad/kokoro](https://github.com/hexgrad/kokoro)** (Kokoro-82M) | Apache-2.0 weights ([model card](https://huggingface.co/hexgrad/Kokoro-82M)) | 54 preset voices, 8 languages. No cloning, little emotion control | Yes. Tiny (82M) and runs on CPU. Apple Silicon ports: [mlx-audio](https://github.com/Blaizzy/mlx-audio), [kokoro-mlx](https://github.com/gabrimatic/kokoro-mlx) | **Best match for the "AI assistant" sound.** It's clean, upbeat and very consistent. Personalities have to come from the writing and speed, not the acting |
| **[QwenLM/Qwen3-TTS](https://github.com/QwenLM/Qwen3-TTS)** | Apache-2.0 | **VoiceDesign**: make a voice from a text description (e.g. "nervous young man, talks fast"). Natural-language emotion and style instructions. Cloning from about 3 s of audio | Examples target an NVIDIA GPU (CUDA). Mac support is unconfirmed, so test it first | **Best for 4 distinct Scam personalities and The Admin's two modes.** Heavier (0.6B / 1.7B) |
| **[resemble-ai/chatterbox](https://github.com/resemble-ai/chatterbox)** | MIT | Emotion-exaggeration slider, tags like `[laugh]` and `[cough]`, cloning from about 10 s of audio. Nano model (110M) runs on CPU | Multilingual model supports MPS (Apple GPU), and Nano runs on CPU | Very expressive. **But it was retired in Aug 2026 and is no longer maintained.** Every file carries an invisible watermark |
| **[OHF-Voice/piper1-gpl](https://github.com/OHF-Voice/piper1-gpl)** (Piper) | **GPL-3.0** (the old [rhasspy/piper](https://github.com/rhasspy/piper) was MIT and is now archived) | Fast, more robotic preset voices | Yes, very light | Good only for a deliberately robotic voice (e.g. the Robotaxi). We'd only use it as an offline tool, but GPL is worth noting |

### Ruled out (non-commercial licenses)
- **F5-TTS**: weights are CC-BY-NC-4.0.
- **Coqui XTTS-v2**: Coqui Public Model License (non-commercial).
- **Fish Audio S2 Pro**: research license, non-commercial.
- **Mistral Voxtral TTS**: CC BY-NC 4.0.

These licenses come partly from secondary blogs. Re-check each repo's
LICENSE file before shipping.

---

## Possible setups (for the user to pick)
1. **Kokoro only.** The cheapest and simplest. Give each character a
   different preset voice and speed. Gets the "every character sounds like
   an AI assistant" joke perfectly, but the acting is less varied.
2. **Qwen3-TTS only.** Design one voice per character from a description
   and direct the emotion per line. The best acting, but it needs an NVIDIA
   GPU (a cloud GPU or another PC) unless it turns out to run on a Mac.
3. **Mix.** Kokoro for the peppy baseline (Mom, Robotaxi, anchor, ClosedAI
   AI, calm Admin), and Qwen3-TTS or Chatterbox for lines that need acting
   (the Scams, Admin waking up).

## The Admin's glitch voice
Two ways, independent of which TTS we pick:
- **In Roblox, live.** Play the same peppy file through Roblox sound
  effects (e.g. `DistortionSoundEffect`, `PitchShiftSoundEffect`) and
  switch them on when he wakes. No extra uploads, and the glitch can ramp
  up gradually.
- **Offline.** Bake the glitch into separate files with `ffmpeg`/`sox`
  (bitcrush, pitch down, stutter). More control, but double the files.

## Roblox audio limits ([Creator Hub docs](https://create.roblox.com/docs/audio/assets))
- Formats: `.mp3`, `.ogg`, `.wav`, `.flac`. Under 20 MB, under 7 minutes,
  48 kHz or lower.
- Quota: **2,000 free audio uploads per 30 days with an ID-verified
  account**, 100 without. Our script is a few hundred lines, so it fits.
- Every upload is moderated. Heavily distorted audio has been flagged
  before ([DevForum](https://devforum.roblox.com/t/constant-bans-for-uploading-distorted-audio/2088697)),
  which is another reason to do the glitch in-engine.

## Guardrail
- **Don't clone Sam Altman's real voice** (or anyone's) without their
  consent. That's impersonation under Roblox rules and the riskiest
  possible move for this parody. Use designed or preset voices only.

## Sources
- Kokoro: https://huggingface.co/hexgrad/Kokoro-82M, https://github.com/hexgrad/kokoro
- Qwen3-TTS: https://github.com/QwenLM/Qwen3-TTS
- Chatterbox: https://github.com/resemble-ai/chatterbox
- Piper: https://github.com/rhasspy/piper, https://github.com/OHF-Voice/piper1-gpl
- Apple Silicon ports: https://github.com/Blaizzy/mlx-audio, https://github.com/gabrimatic/kokoro-mlx
- Comparisons (secondary): https://www.bentoml.com/blog/exploring-the-world-of-open-source-text-to-speech-models,
  https://localaimaster.com/blog/best-local-tts-models,
  https://blog.bymar.co/posts/open-source-voice-cloning-alternatives-elevenlabs-2026/
- Roblox audio: https://create.roblox.com/docs/audio/assets
