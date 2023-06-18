from . import app, request, jsonify
from . import helper

@app.route('/', methods = ['POST', 'GET'])
def parse():
   if request.method == 'POST':
      fileName = request.json['file']
      product = request.json['product']
      response = {"file":fileName}
      response = helper.parseRequest(fileName, product, response)
      return jsonify(response)


