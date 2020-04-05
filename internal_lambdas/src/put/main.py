import os
import boto3
import json
from boto3.dynamodb.conditions import Key, Attr

def put(table, artist, song):
    try:
        r = table.put_item(
            Item={
                'artist': artist,
                'song': song
            }
        )
        print("PutItem succeeded:")
        print(json.dumps(r, indent=4))
        return {"message": "added song {} by {} to table".format(song, artist) }
    except Exception as e:
        return {"message": "adding song {} by {} to table failed {}".format(song, artist, e) }

def lambda_handler(event, context):
    table_name = os.environ['TABLE']
    dynamodb_client = boto3.client('dynamodb')
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)
    try:
        artist=event['artist']
        song=event['song']
    except KeyError:
        print('an artist and a song must be provided')
        return {"message": "an artist and song must be provided {}".format(event) }
        raise
    data = put(table, artist, song)
    return data
