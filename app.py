from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "CiCd pipeline created successfully"

@app.route("/hello")
def hello():
    return "Hey, it is deployed succesfully"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
    
    
   