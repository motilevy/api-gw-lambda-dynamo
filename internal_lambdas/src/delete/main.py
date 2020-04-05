import os
import boto3
import json
from boto3.dynamodb.conditions import Key, Attr


def delete(table, artist, song):
    try:
        r = table.delete_item(
            Key={
                'artist': artist,
                'song': song
            },
            ConditionExpression="song = :val",
            ExpressionAttributeValues= {
                ":val": song
            }
        )
        return {"message": "deleted song {} by {} from table".format(song, artist) }
    except Exception as e:
        return {"message": "deleting song {} by {} from table failed {}".format(song, artist, e) }


def lambda_handler(event, context):
    table_name = os.environ['TABLE']
    dynamodb_client = boto3.client('dynamodb')
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)
    print(json.dumps(event))
    try:
        artist=event['artist']
        song=event['song']
    except KeyError:
        print('an artist and current song must be provided')
        return {"message": "an artist and song must be provided {}".format(event) }
        raise
    data = delete(table, artist, song)
    return data
