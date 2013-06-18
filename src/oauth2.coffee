https  = require "https"
url    = require "url"
qs     = require "querystring"

class OAuth2

  responseType : 'code'
  state : ''
  grantType: 'authorization_code'
  code : ''
  redirectUri : ''
  responseData: ''

  constructor: (@appId, @apiKey="") -> 
    @scope = []
    @validateAppId(@appId)
    @validateStrInput(@apiKey)

  setAppId: (@appId) ->
    @validateAppId(appId)

  setApiKey: (@apiKey) ->
    @validateStrInput(apiKey)

  setRedirectUri: (@redirectUri) ->
    @validateStrInput(redirectUri) 

  getResponseType: () ->
    @responseType

  changeResponseType: () ->
    return @responseType = "token" if @responseType is "code"
    @responseType = "code"

  addToScope: (scope) ->
    return false unless scope.substring?
    @scope.push(scope)

  removeFromScope: (index) ->
    return @scope.splice(index) if 0 <= index <= @scope.length
    false

  getScope: ->
    @scope

  setState: (@state) ->
    return false unless @state.substring? 
    @state

  getState: ->
    @state

  # e.g., authorizedUrl => https://www.douban.com/service/auth2/auth
  getAuthorizedUri: (authorizedUrl) ->
    "#{authorizedUrl}?client_id=#{@appId}&redirect_uri=#{@redirectUri}&response_type=#{@responseType}&state=#{@state}&scope=#{@scope.join ','}"

  getGrantType: -> 
    @grantType

  changeGrantType: ->
    return @grantType = "refresh_token" if @grantType is "authorization_code"
    @grantType = "authorization_code"

  getAccessToken: (@accessUri, @code) ->
    req = https.request getTokenRequestOptions(), (res) ->
      res.setEncoding 'utf8'

      res.on 'data', receieveData

      res.on 'end', parseCompleteData

    req.write(getTokenContent())
    req.end()

    req.on 'error', handleRequestError


  getResponseData: ->
    until @isDataComplete
      false  
    @responseData 
  
  # private helper functions
  validateAppId: (appId) ->
    throw new ReferenceError("appId must not be empty") unless appId?
    throw new ReferenceError("appId must not be empty") if appId is ""
    throw new TypeError("appId must be string") unless appId.substring?

  validateStrInput: (strInput) ->
    throw new TypeError("input must be string") unless strInput.substring?

  receieveData: (data) ->
    @requestData += data

  parseCompleteData: ->
    @requestData = JSON.parse(@requestData)
    @isDataComplete = true

  handleRequestError: (err) ->
    console.error err

  getTokenContent: ->
    "client_id=#{@appId}&client_secret=#{@apiKey}&redirect_uri=#{@redirectUri}&grant_type=#{@grantType}&code=#{@code}"

  getTokenRequestOptions: ->
    # TODO 
    obj =
      hostname: 'www.douban.com'
      path: '/service/auth2/token'
      method: 'POST'
      headers:
        'Content-Type': 'application/x-www-form-urlencoded'
        'Content-Length': @getTokenContent().length

