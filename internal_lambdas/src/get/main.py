import os
import boto3
import json
from boto3.dynamodb.conditions import Key, Attr


def get(table, artist):
    if artist is None:
        r = table.scan()
    else:
        r = table.query(
            KeyConditionExpression=Key('artist').eq(artist)
        )
    return r['Items']

def lambda_handler(event, context):
    table_name = os.environ['TABLE']
    dynamodb_client = boto3.client('dynamodb')
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)
    print(json.dumps(event))
    try:
        artist=event['artist']
    except KeyError:
        artist = None
    data = get(table, artist)
    return data
