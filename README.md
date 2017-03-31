# stubify

[![Twitter: @carlostify](https://img.shields.io/badge/contact-@carlostify-blue.svg?style=flat)](https://twitter.com/carlostify)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/nakiostudio/xcov/blob/master/LICENSE)
[![Gem](https://img.shields.io/gem/v/stubify.svg?style=flat)](http://rubygems.org/gems/stubify)

**stubify** allows you to stub real environments without really doing anything. It runs a [Sinatra](https://github.com/sinatra/sinatra)
application locally and, given a host, it forwards all the calls received caching the real responses, that way, next time the local
environment receives a request the cached response is returned.

## Example

By running the gem with the following command:
```bash
stubify server --host https://easy-peasy.io --directory fixtures
```

It will create a local environment with address `http://localhost:4567`. Every request received will be recreated against the host
provided, therefore a request to `http://localhost:4567/rest_api/user/32325` will return whatever `https://easy-peasy.io/rest_api/user/32325`
returns and, in addition, that response will be cached in the directory `fixtures`.

Next time a request to `http://localhost:4567/rest_api/user/32325` is made the cached payload will be returned.

## Features

* Accepts `GET`, `POST`, `PUT` and `DELETE` requests.
* HTTP headers, query parameters and request bodies are taken into account.

## Installation

```
sudo gem install stubify
```

## Usage

```
stubify server --host https://real-host.com --directory path_to_cached_response

ACTIONS:

    server [options]

OPTIONS:

    --host STRING
    Host the requests will be redirected to. i.e. https://easy-peasy.io

    --port STRING
    Port the local environment will listen to. Default is 4567

    --directory DIR
    Path where fixtures will be stored. i.e. fixtures/

    --whitelist DIR
    Path to the .yml file with the whitelisted paths

    --verbose
    Increases the amount of information logged
```

### Whitelisting endpoints

**stubify** allows you to skip the caching of some endpoints, to do so, provide the file path to
a `yaml` file with the url paths to exclude, i.e.:

```yaml
- /rest_api/oauth2/token/
- /rest_api/account/profile/
```

## Author

[Carlos Vidal](https://twitter.com/carlostify)

## License

This project is licensed under the terms of the MIT license. See the LICENSE file.
