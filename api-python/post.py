import pyodbc
import json
import requestsloca
conn = pyodbc.connect(‘Driver={SQL Server};’
 ‘Server=localhost; ’ # can be your sever-name or localhost
 ‘Database=Dummy_operations;’
 ‘Trusted_Connection=no;’ 
 ‘uid=userid;’ # it can be “.” , “sa” or userid
 ‘pwd=password;’
 )
cursor = conn.cursor()
query=cursor.execute(‘SELECT * FROM Dummy_operations.dbo.Ops_alerts’)
payload = [dict(zip([column[0] for column in cursor.description], row))
 for row in cursor.fetchall()]
for i in range(0,len(payload)):
 r=requests.post(‘https://reqres.in/api/users',json=payload[i])
 print(‘Status Code:’, r.status_code)
 print(payload[i])
 r.json()
 ========================================================
 # importing the requests library
import requests

# api-endpoint
URL = "http://maps.googleapis.com/maps/api/geocode/json"

# location given here
location = "delhi technological university"

# defining a params dict for the parameters to be sent to the API
PARAMS = {'address':location}

# sending get request and saving the response as response object
r = requests.get(url = URL, params = PARAMS)

# extracting data in json format
data = r.json()


# extracting latitude, longitude and formatted address
# of the first matching location
latitude = data['results'][0]['geometry']['location']['lat']
longitude = data['results'][0]['geometry']['location']['lng']
formatted_address = data['results'][0]['formatted_address']

# printing the output
print("Latitude:%s\nLongitude:%s\nFormatted Address:%s"
	%(latitude, longitude,formatted_address))
========================================================================
# using flask_restful 
from flask import Flask, jsonify, request 
from flask_restful import Resource, Api 

# creating the flask app 
app = Flask(__name__) 
# creating an API object 
api = Api(app) 

# making a class for a particular resource 
# the get, post methods correspond to get and post requests 
# they are automatically mapped by flask_restful. 
# other methods include put, delete, etc. 
class Hello(Resource): 

	# corresponds to the GET request. 
	# this function is called whenever there 
	# is a GET request for this resource 
	def get(self): 

		return jsonify({'message': 'hello world'}) 

	# Corresponds to POST request 
	def post(self): 
		
		data = request.get_json()	 # status code 
		return jsonify({'data': data}), 201


# another resource to calculate the square of a number 
class Square(Resource): 

	def get(self, num): 

		return jsonify({'square': num**2}) 


# adding the defined resources along with their corresponding urls 
api.add_resource(Hello, '/') 
api.add_resource(Square, '/square/<int:num>') 


# driver function 
if __name__ == '__main__': 

	app.run(debug = True) 
=====================================================================
import json
from flask import Flask, jsonify, request
app = Flask(__name__)

employees = [
 { 'id': 1, 'name': 'Ashley' },
 { 'id': 2, 'name': 'Kate' },
 { 'id': 3, 'name': 'Joe' }
]


nextEmployeeId = 4
3
@app.route('/employees', methods=['GET'])
def get_employees():
 return jsonify(employees)

@app.route('/employees/<int:id>', methods=['GET'])
def get_employee_by_id(id: int):
 employee = get_employee(id)
 if employee is None:
   return jsonify({ 'error': 'Employee does not exist'}), 404
 return jsonify(employee)

def get_employee(id):
 return next((e for e in employees if e['id'] == id), None)

def employee_is_valid(employee):
 for key in employee.keys():
   if key != 'name':
 	return False
 return True

@app.route('/employees', methods=['POST'])
def create_employee():
 global nextEmployeeId
 employee = json.loads(request.data)
 if not employee_is_valid(employee):
   return jsonify({ 'error': 'Invalid employee properties.' }), 400

 employee['id'] = nextEmployeeId
 nextEmployeeId += 1
 employees.append(employee)

 return '', 201, { 'location': f'/employees/{employee["id"]}' }

@app.route('/employees/<int:id>', methods=['PUT'])
def update_employee(id: int):
 employee = get_employee(id)
 if employee is None:
   return jsonify({ 'error': 'Employee does not exist.' }), 404

 updated_employee = json.loads(request.data)
 if not employee_is_valid(updated_employee):
   return jsonify({ 'error': 'Invalid employee properties.' }), 400

 employee.update(updated_employee)

 return jsonify(employee)

@app.route('/employees/<int:id>', methods=['DELETE'])
def delete_employee(id: int):
 global employees
 employee = get_employee(id)
 if employee is None:
   return jsonify({ 'error': 'Employee does not exist.' }), 404

 employees = [e for e in employees if e['id'] != id]
 return jsonify(employee), 200

if __name__ == '__main__':
   app.run(port=5000)
=====================================================================
