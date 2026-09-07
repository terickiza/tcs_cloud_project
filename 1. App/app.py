import os

from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/DevOps', methods=['GET', 'POST', 'PUT', 'DELETE', 'PATCH'])
def devops():
    # Only allow POST method
    if request.method != 'POST':
        return jsonify({"error": "ERROR"}), 405
    
    # Get JSON data from request
    try:
        data = request.get_json()
    except:
        return jsonify({"error": "ERROR"}), 400
    
    # Validate that we have JSON data
    if data is None:
        return jsonify({"error": "ERROR"}), 400
    
    # Validate exact fields (must have exactly these 4 fields)
    required_fields = {"message", "to", "from", "timeToLifeSec"}
    
    if set(data.keys()) != required_fields:
        return jsonify({"error": "ERROR"}), 400
    
    # Validate field types
    if (not isinstance(data.get("message"), str) or
        not isinstance(data.get("to"), str) or
        not isinstance(data.get("from"), str) or
        not isinstance(data.get("timeToLifeSec"), int)):
        return jsonify({"error": "ERROR"}), 400
    
    # Extract the 'to' field for response
    to_name = data.get("to")
    
    # Return success response
    return jsonify({
        "message": f"Hello {to_name} your message will be sent"
    }), 200

if __name__ == '__main__':
    # Never enable debug in a deployed environment: the Werkzeug debugger allows
    # remote code execution. Serve with a real WSGI server (gunicorn) in production;
    # this block is only for local development.
    debug = os.environ.get("FLASK_DEBUG", "false").lower() == "true"
    port = int(os.environ.get("PORT", "5000"))
    app.run(debug=debug, host="0.0.0.0", port=port)
