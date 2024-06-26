from flask import Flask, request, jsonify
import os

app = Flask(__name__)

# Defines the path for the counter file to store the data in Docker Volume.
src_dir = os.path.dirname(__file__)
counter_file = os.path.join(src_dir, '../data/counter.txt')


def read_counter():
    """
    Reads and returns the current counter value from the file.
    If the file doesn't exist, it returns 0.
    
    Returns:
        int: The current counter value.
    """
    if os.path.exists(counter_file):
        with open(counter_file, "r") as file:
            return int(file.read().strip())
    else:
        return 0


def update_counter(counter):
    """
    Updates the counter file with the new counter value.
    
    Args:
        counter (int): The new counter value to write to the file.
    """
    with open(counter_file, "w") as file:
        file.write(str(counter))


@app.route('/', methods=['GET', 'POST'])
def handle_request():
    """
    Handles GET and POST requests to the root endpoint.
    GET request returns the current count of POST requests.
    POST request increments the counter and returns the updated count.
    
    Returns:
        str: The response message with the current or updated counter.
    """
    counter = read_counter()
    if request.method == 'POST':
        # Increment the counter for each POST request and update the file.
        counter += 1
        update_counter(counter)
        return f'POST requests counter updated. Current count: {counter}'
    else:
        # For GET requests, just return the current count.
        return f'Current POST requests count: {counter}'


@app.route('/health', methods=['GET'])
def health_check():
    """
    Performs a simple health check of the application.
    It tries to read the counter file as a basic check.
    
    Returns:
        tuple: A JSON response indicating the health status and the HTTP status code.
    """
    try:
        # Basic health check: Ensures the counter file is accessible.
        read_counter()
        return jsonify({"status": "healthy"}), 200
    except Exception as e:
        # Returns an unhealthy status if any error occurs, e.g., file access issues.
        return jsonify({"status": "unhealthy", "reason": str(e)}), 500


if __name__ == '__main__':
    # Runs the Flask app with binding to all interfaces on port 8080.
    # Debug mode is turned off for production use.
    app.run(host='0.0.0.0', port=8080, debug=False)
