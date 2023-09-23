import json, datetime, requests, time
from wrapper import wrapper
from decouple import config


def getAutenticacion():
    res = requests.post(
        f"https://id.twitch.tv/oauth2/token?client_id={config('CLIENT_ID')}&client_secret={config('CLIENT_SECRET')}&grant_type=client_credentials",
    )

    return res.json()["access_token"]


def getDelayBetweenRequests(requests_per_second=3.5):
    delay_between_requests = 1 / requests_per_second
    return delay_between_requests


def getObject(byte_array):
    decoded_item = byte_array.decode("utf-8")
    data = json.loads(decoded_item)
    return data
