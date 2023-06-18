from . import app, request, jsonify
from . import helper
import requests
import socket
import csv
import traceback
import json

@app.route('/', methods = ['POST', 'GET'])
def hello_world():
   return "Hello Harjot Pipeline is working"


@app.route('/store-file', methods = ['POST'])
def store_file():
   if request.method == 'POST':
      try:
         fileName = request.json['file']
         if fileName in [None, "", "null"]:
            return jsonify({"error": "Invalid JSON input.",
                     "file": None})
         data_lines = request.json['data'].split('\n')
      except KeyError as e:
         return jsonify({"error": "Invalid JSON input.",
                        "file": None})
      try:
         with open(app.config['DATA_DIR']+fileName, mode='w', newline="") as file:
            writer = csv.writer(file)
            for line in data_lines:
               writer.writerow(line.replace(" ","").split(','))
         return jsonify({ "file": fileName,
            "message": "Success."})
      except Exception as e:
         return jsonify({
         "file": fileName,
         "error": "Error while storing the file to the storage."
         })

@app.route('/calculate', methods = ['POST', 'GET'])
def calculate():
   try:
      if request.method == 'POST':
         fileName = request.json['file']
         product = request.json['product']
         response = {"file":fileName}
         response = helper.validateRequest(fileName, response)
         if "error" in response.keys():
            resp = jsonify(response)
            return resp
         else:
            app2Url = app.config['APP2_URL']
            response = requests.post(app2Url, json={
                        "file":fileName,
                        "product":product})
            if response.status_code == 200:
               return jsonify(response.json())
         return jsonify(response)
   except KeyError as e:
         return jsonify({"error": "Invalid JSON input.",
                        "file": None})
      

