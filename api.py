from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# DeepSeek model API ayarları
API_URL = "http://127.0.0.1:1234/v1/chat/completions"
MODEL_NAME = "deepseek/deepseek-r1-0528-qwen3-8b"

@app.route("/summarize", methods=["POST"])
def summarize():
    text = request.json.get("text", "").strip()
    if not text:
        return jsonify({"summary": ""})

    payload = {
        "model": MODEL_NAME,
        "messages": [
            {
                "role": "system",
                "content": (
                    "You are a text summarization model. "
                    "Only produce a short, clear, meaningful summary in Turkish in 3-5 sentences. "
                    "Do not include internal thoughts, explanations, analyses, or any ‘think’ sections. "
                    "Only output the summary text."
                )
            },
            {"role": "user", "content": text}
        ],
        "temperature": 0.0,
        "stream": False
    }

    try:
        response = requests.post(API_URL, json=payload, headers={"Content-Type": "application/json"})
        result = response.json()

        if "choices" in result and len(result["choices"]) > 0:
            raw_summary = result["choices"][0]["message"]["content"]

            # <think> kısmını temizle
            if "<think>" in raw_summary:
                parts = raw_summary.split("</think>")
                summary = parts[-1].strip()
            else:
                summary = raw_summary.strip()
        else:
            summary = ""

    except Exception as e:
        print("Hata:", e)
        summary = ""

    return jsonify({"summary": summary})


if __name__ == "__main__":
    # Flutter emulatoru erişebilsin diye host 0.0.0.0
    app.run(host="0.0.0.0", port=5000)

