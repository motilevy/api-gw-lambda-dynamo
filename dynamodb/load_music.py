import sys
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
    except Exception as e:
        print(e)

if __name__ == '__main__':
    table_name = sys.argv[1]
    dynamodb_client = boto3.client('dynamodb')
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)
    put(table, "prince", "1999")
    put(table, "prince", "let\'s go crazy")
    put(table, "prince", "purple rain")
    put(table, "soft cell", "asleep")
    put(table, "the smiths", "frankly, mr. shankly")
    put(table, "the smiths", "girl afraid")
    put(table, "the smiths", "girlfriend in a come")
    put(table, "the smiths", "i know its over")

