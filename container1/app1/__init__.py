from flask import Flask, request, jsonify

app = Flask(__name__)
app.config.from_pyfile('../config.cfg')

from . import views