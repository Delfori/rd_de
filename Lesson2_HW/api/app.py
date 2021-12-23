import requests
import json
from requests.exceptions import HTTPError
import datetime
import os


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
        content = json.dumps(r1)

        if not os.path.exists(os.path.dirname(f'{api_date}')):
            try:
                os.makedirs(f'{api_date}')
            except OSError as exc:
                pass

        with open(f'{api_date}/{api_date}+txt', "w") as f:
            f.write(content)

    except HTTPError:
        print('HTTPError')


if __name__ == '__main__':
    base = datetime.datetime.today()
    dates = [(base - datetime.timedelta(days=x)).strftime('%Y-%m-%d') for x in range(30)]
    for date in dates:
        app(date)

