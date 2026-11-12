from flask import Flask, request, redirect
from markupsafe import escape
import pymysql
import os
import time

app = Flask(__name__)

DB_CONFIG = {
    "host": os.environ.get("DB_HOST", "db"),
    "user": os.environ.get("DB_USER", "wordpress"),
    "password": os.environ.get("DB_PASSWORD", "wordpress"),
    "database": os.environ.get("DB_NAME", "hallo"),
}


def get_connection():
    return pymysql.connect(**DB_CONFIG)


def init_db():
    for versuch in range(1, 31):
        try:
            conn = get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    CREATE TABLE IF NOT EXISTS eintraege (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        text VARCHAR(255) NOT NULL,
                        erstellt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                    )
                """)
            conn.commit()
            conn.close()
            print("Datenbank bereit", flush=True)
            return
        except Exception as fehler:
            print(f"Warte auf Datenbank ({versuch}/30): {fehler}", flush=True)
            time.sleep(2)
    raise RuntimeError("Datenbank nicht erreichbar")


@app.route("/")
def index():
    conn = get_connection()
    with conn.cursor() as cur:
        cur.execute("SELECT id, text, erstellt FROM eintraege ORDER BY id DESC")
        zeilen = cur.fetchall()
    conn.close()

    if zeilen:
        liste = "".join(
            f"<li>{escape(z[1])} <small>({z[2]})</small></li>" for z in zeilen
        )
    else:
        liste = "<li><em>Noch nichts gespeichert</em></li>"

    return f"""<!doctype html>
<html lang="de">
<head><meta charset="utf-8"><title>Hallo Welt</title></head>
<body>
  <h1>Hallo Welt!</h1>
  <form method="post" action="/speichern">
    <input name="text" placeholder="Text eingeben" required>
    <button type="submit">Speichern</button>
  </form>
  <ul>{liste}</ul>
</body>
</html>"""


@app.route("/speichern", methods=["POST"])
def speichern():
    text = request.form["text"]
    conn = get_connection()
    with conn.cursor() as cur:
        cur.execute("INSERT INTO eintraege (text) VALUES (%s)", (text,))
    conn.commit()
    conn.close()
    return redirect("/")


init_db()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
