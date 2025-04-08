from flask import Flask
from datetime import datetime

app = Flask(__name__)

@app.route("/")
def home():
    return "CiCd pipeline created successfully"

@app.route("/hello")
def hello():
    return "Hey, it is deployed succesfully"

@app.route("/money")
def money():
    return "Hey, it will billionaire$$$$"

@app.route("/time")
def time():
    now = datetime.now()
    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    return f"Current server time is: {current_time}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
