from flask import Flask, render_template, request, send_file
from rembg import remove
from PIL import Image
import io

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        if "image" not in request.files:
            return "No file uploaded", 400

        file = request.files["image"]
        img = Image.open(file.stream).convert("RGBA")
        result = remove(img)

        # Save to in-memory file
        img_io = io.BytesIO()
        result.save(img_io, "PNG")
        img_io.seek(0)
        return send_file(img_io, mimetype="image/png", download_name="output.png")

    return render_template("index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
