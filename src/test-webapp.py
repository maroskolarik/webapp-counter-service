import pytest
import os
from webapp import app

# Defines the path for the counter file to store the data in Docker Volume.
src_dir = os.path.dirname(__file__)
counter_file = os.path.join(src_dir, '../data/counter.txt')


@pytest.fixture
def client():
    app.config['TESTING'] = True

    with app.test_client() as client:
        yield client


@pytest.fixture(autouse=True)
def zero_counter_file():
    # Zero the counter file before each test
    with open(counter_file, 'w') as file:
        file.write('0')


def test_counter_file_access():
    # Check if the counter file is accessible
    assert os.path.exists(counter_file)


def test_initial_counter_value(client):
    # Check if the initial counter value is 0
    response = client.get('/')
    assert response.status_code == 200
    assert b'Current POST requests count: 0' in response.data


def test_increment_counter(client):
    # Send a POST request to increment the counter
    response = client.post('/')
    assert response.status_code == 200
    assert b'POST requests counter updated.' in response.data

    # Check if the counter has been incremented
    response = client.get('/')
    assert response.status_code == 200
    assert b'Current POST requests count: 1' in response.data


def test_multiple_increments(client):
    # Send multiple POST requests to increment the counter
    for _ in range(8):
        client.post('/')

    # Check if the counter has been incremented correctly
    response = client.get('/')
    assert response.status_code == 200
    assert b'Current POST requests count: 8' in response.data


def test_health_check(client):
    response = client.get('/health')
    assert response.status_code == 200
    assert b'{"status":"healthy"}' in response.data


def test_invalid_endpoint(client):
    # Send a GET request to an invalid endpoint
    response = client.get('/invalid')
    assert response.status_code == 404
