from flask import Flask

app = Flask(__name__, static_folder='ClientApp/dist/InitConf', static_url_path="/")

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    return app.send_static_file("index.html")

@app.route('/api/config')
def postConfig(config):
    print(config)

if (__name__ == '__main__'):
    app.run()
    