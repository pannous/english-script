import urllib2
import json


def download(url):
    data = urllib2.urlopen(url).read()  # download
    return data
    # data = json.loads(data)

