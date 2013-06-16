https  = require "https"
url    = require "url"
qs     = require "querystring"

class @OAuth2

  responseType : "code"
  state : ""
  grant_type: "authorization_code"

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

  getState: () ->
    @state

  # e.g., authorizedUrl => https://www.douban.com/service/auth2/auth
  getAuthorizedUri: (authorizedUrl) ->
    "#{authorizedUrl}?client_id=#{@appId}&redirect_uri=#{@redirectUri}&response_type=#{@responseType}&state=#{@state}&scope=#{@scope.join ','}"


  # private helper functions
  validateAppId: (appId) ->
    throw new ReferenceError("appId must not be empty") unless appId?
    throw new ReferenceError("appId must not be empty") if appId is ""
    throw new TypeError("appId msut be string") unless appId.substring?

  validateStrInput: (strInput) ->
    throw new TypeError("input must be string") unless strInput.substring?