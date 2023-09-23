from decouple import config
from igdb.wrapper import IGDBWrapper

CLIENT_ID = config("CLIENT_ID")
ACCESS_TOKEN = config("ACCESS_TOKEN")

wrapper = IGDBWrapper(CLIENT_ID, ACCESS_TOKEN)