<p align="center">
<img src="https://github.com/VictorZhang2014/toutcas/blob/main/screenshots/app-logo.png" width="170px" />
</p>

# ToutCas
ToutCas takes its name from the French phrase "En tout cas, ça marche toujours".
It is an AI assistant designed with a Burn-After-Use interaction model and, zero remote data persistence, and a secure multi-tenant architecture, ensuring that user data is never stored or retained on remote servers.

[![built-for-macos](https://img.shields.io/badge/Built%20for-macOS-BF0BD9.svg)](https://developer.apple.com/)
[![built-for-windows](https://img.shields.io/badge/Built%20for-Windows-236FFC.svg)](https://developer.microsoft.com/en-us/windows/)
[![built-for-linux](https://img.shields.io/badge/Built%20for-Linux-000000.svg)](https://www.linuxfoundation.org/)
[![GPT-OSS-120B](https://img.shields.io/badge/%F0%9F%A4%96%20Chat-GPTOSS%20120b-2800B3)](https://chat.openai.com)
[![DeepSeek-V3](https://img.shields.io/badge/🤖%20Chat-DeepSeek%20V3-536af5?color=536af5)](https://chat.deepseek.com/)
[![Mistral-7B-v0.2](https://img.shields.io/badge/%F0%9F%98%BA%20Le%20Chat-Mistral7B%20v0.2-EB8721)](https://chat.mistral.ai/chat)


# Features
- ✅ An agentic AI web browser, inspired by [`ChatGPT Atlas`](https://openai.com/index/introducing-chatgpt-atlas/)
- ✅ Burn-After-Use (BAU) mechanism with a non-custodial design, ensuring no persistent storage of user data during AI interactions
- ✅ Cross-platform support: macOS, Windows, and Linux, (iOS and Android versions are under development)
- ✅ Built-in support for multiple LLMs, including [gpt-oss-120b](https://huggingface.co/openai/gpt-oss-120b), [DeepSeek V3.2 Exp](https://huggingface.co/deepseek-ai/DeepSeek-V3.2-Exp), and [Mistral-7B-Instruct-v0.2](https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.2) 
- ✅ Native web page analysis and PDF understanding powered by Retrieval-Augmented Generation (RAG) and embedding-based retrieval
- ✅ Research-inspired design, informed by this dissertation [arXiv:2601.06627](https://arxiv.org/abs/2601.06627)


# Screenshots
![ToutCas Application Screenshot1](https://github.com/VictorZhang2014/toutcas/blob/main/screenshots/Screenshot1.png)
![ToutCas Application Screenshot3](https://github.com/VictorZhang2014/toutcas/blob/main/screenshots/Screenshot3.png)


# Environment
```
[✓] Flutter (Channel stable, macOS 15.6.1 24G90)
    • Flutter version 3.35.1
    • Dart version 3.9.0

[✓] Android toolchain (Android SDK version 35.0.0) 
    • Emulator version 34.1.19.0  
    • Platform android-35, build-tools 35.0.0
    • All Android licenses accepted.

[✓] Xcode (Xcode 26.1.1) 
    • Build 17B100
    • CocoaPods version 1.16.2

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2024.2)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Java version OpenJDK Runtime Environment (build 21.0.3+-79915917-b509.11)

[✓] VS Code (version 1.106.2)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.122.0
```
Python Flask
```
[✓] Python (version 3.9.6)
[✓] Flask (version 3.1.2)
[✓] transformers (version 4.57.3)
[✓] torch (version 2.9.1)
[✓] tokenizers (version 0.22.1)
[✓] scikit-learn (version 1.8.0)
[✓] numpy (version 2.3.5)
```


> [!TIP]
> Use it at your own risk


# Theme of the Thesis
> [!TIP]
> Burn-After-Use for Preventing Data Leakage through a Secure Multi-Tenant Architecture in Enterprise LLM


## Citation
If you use **ToutCas** in your research or academic work, please cite:

```bibtex
@misc{ToutCas2025,
  title        = {ToutCas: An AI Personal Browser with a Burn-After-Use Interaction Model and Non-Custodial Data Handling},
  author       = {Zhang, Victor},
  year         = {2025},
  howpublished = {\url{https://github.com/VictorZhang2014/toutcas}},
  note         = {arXiv:2601.06627}
}
```
