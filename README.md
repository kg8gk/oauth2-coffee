This is an implementation of Oauth2 written in CoffeeScript

It's based on Node.JS

MIT license

# Usage

    OAuth2 = require 'src/oauth2'
    
    oauth2 = new OAuth2(client_id, client_secret)
    oauth2.setRedirectUri redirect_uri
    oauth2.setTokenUri token_uri
    authorizedUri = oauth2.getAuthorizedUri authorized_uri

After you get the _authorizedUri_, enter the _authorizedUri_ into the browser to get the authorized 
token, for example, token, then:

    oauth2.getAccessToken(token, cb, errorHandler)

`cb` must be a function that accepts the access token as its parameter.
