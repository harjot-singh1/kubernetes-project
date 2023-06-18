
import os
import csv
from . import app
import traceback

def parseRequest(fileName, product, response):
	# filePart = fileName.split('.')[0]
	filePath = app.config['DATA_DIR']+"/"+fileName
	
	# if not os.path.exists(filePath):
	# 	response["error"] = "Input file not in CSV format."
	# else:
	total = calculateTotal(filePath, product)
	if total == None:
		response["error"] = "Input file not in CSV format."
	else:
		response["sum"] = str(total)
	return response



def calculateTotal(filePath, product):
	try:
		total = 0

		with open(filePath, 'r') as file:

			reader  = csv.reader(file)
			header = next(reader, None)
			header[0] = header[0].lstrip('\ufeff')
			productCol = header.index('product')
			amountCol = header.index('amount')

			for row in reader:
				if row[productCol] == product:
					total += int(row[amountCol])
		return total
	except Exception as e:
		print(traceback.format_exc())
		return None
	
    
