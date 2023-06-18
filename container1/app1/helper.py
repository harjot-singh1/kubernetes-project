
import os
from . import app
import traceback

def validateRequest(fileName, response):
	try:
		if fileName in [None, "", "null"]:
			response['file'] = None
			response["error"] = "Invalid JSON input."
			return response
		
		filePath = app.config['DATA_DIR']+"/"+fileName
		if not os.path.exists(filePath):
			response["error"] = "File not found."
		return response
	except Exception as e:
		print(traceback.format_exc())
		return {"error": str(e),
	  			"file":None}

    
