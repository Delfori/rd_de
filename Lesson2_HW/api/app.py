import requests
import json
from requests.exceptions import HTTPError


from config import Config

def app(api_date=None):
    try:
        config = Config('./config.yaml')
        config = config.get_config()
        url = config['API']['url']+config['AUTH']['endpoint']
        data_auth = json.dumps(config['AUTH']['payload'])
        token = requests.post(url, data=data_auth, headers={"content-type": "application/json"}).json()['access_token']
        headers = {'content-type': config['API']['content-type'],
                   'Authorization': f'JWT {token}'}
        data = json.dumps({"date": config['API']['payload']['date']})
        url = config['API']['url']+config['API']['endpoint']
        r1 = requests.get(url, data=data, headers=headers).json()
        print(r1)
    except HTTPError:
        print('HTTPError')
if __name__ == '__main__':
    dates = ['2021-12-12']
    for date in dates:
        app(date)

