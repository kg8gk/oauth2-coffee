https  = require "https"
url    = require "url"

class OAuth2

  _responseType : 'code'
  _state : ''
  _grantType: 'authorization_code'
  _code : ''
  _redirectUri : ''
  _accessUri : ''

  constructor: (@_appId, @_apiKey="") -> 
    @_scope = []
    @_validateAppId(@_appId)
    @_validateStrInput(@_apiKey)

  setAppId: (@_appId) ->
    @_validateAppId(@_appId)

  setApiKey: (@_apiKey) ->
    @_validateStrInput(@_apiKey)

  setRedirectUri: (@_redirectUri) ->
    @_validateStrInput(@_redirectUri) 

  getResponseType: () ->
    @_responseType

  changeResponseType: () ->
    return @_responseType = "token" if @_responseType is "code"
    @_responseType = "code"

  addToScope: (scope) ->
    return false unless scope.substring?
    @_scope.push(scope)

  removeFromScope: (index) ->
    return @_scope.splice(index) if 0 <= index <= @_scope.length
    false

  getScope: ->
    @_scope

  setState: (@_state) ->
    return false unless @_state.substring? 
    @_state

  getState: ->
    @_state

  # e.g., authorizedUrl => https://www.douban.com/service/auth2/auth
  getAuthorizedUri: (authorizedUrl) ->
    "#{authorizedUrl}?client_id=#{@_appId}&redirect_uri=#{@_redirectUri}&response_type=#{@_responseType}&state=#{@_state}&scope=#{@_scope.join ','}"

  getGrantType: -> 
    @_grantType

  changeGrantType: ->
    return @_grantType = "refresh_token" if @_grantType is "authorization_code"
    @_grantType = "authorization_code"

  setTokenUri : (@_accessUri) ->
    @_validateStrInput(@_accessUri) 

  getTokenUri : ->
    @_accessUri

  getAccessToken: (@_code, callback, errorHandler) =>
    responseData = ''
    req = https.request @_getTokenRequestOptions(), (res) ->
      res.setEncoding 'utf8'

      res.on 'data', (data) ->
        responseData += data

      res.on 'end', () ->
        callback JSON.parse(responseData)

    req.write(@_getTokenContent())
    req.end()

    req.on 'error', (err) ->
      if errorHandler?
        errorHandler(err)
      else
        console.error "Error => #{err.toString()}"

  
  # private helper functions
  _validateAppId: (appId) ->
    throw new ReferenceError("appId must not be empty") unless appId?
    throw new ReferenceError("appId must not be empty") if appId is ""
    throw new TypeError("appId must be string") unless (typeof appId is 'string')

  _validateStrInput: (strInput) ->
    throw new TypeError("input must be string") unless (typeof strInput is 'string')

  _getTokenContent: ->
    "client_id=#{@_appId}&client_secret=#{@_apiKey}&redirect_uri=#{@_redirectUri}&grant_type=#{@_grantType}&code=#{@_code}"

  _getTokenRequestOptions: ->
    obj = url.parse(@_accessUri)
    urlOptions =
      hostname: obj.hostname
      path: obj.path
      method: 'POST'
      headers:
        'Content-Type': 'application/x-www-form-urlencoded'
        'Content-Length': @_getTokenContent().length 
    urlOptions

exports.OAuth2 = OAuth2
