import json


def handler(event, context):
    message = "Hello, World!"
    response = {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps(message)
    }
    return response
