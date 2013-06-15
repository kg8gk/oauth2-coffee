class OAuth2
  response_type : "code"

  constructor: (@appId, @apiKey="") -> 
    # @response_type = "code"
    @validateAppId(@appId)
    @validateStrInput(@apiKey)

  setAppId: (@appId) ->
    @validateAppId(appId)

  setApiKey: (@apiKey) ->
    @validateStrInput(apiKey)

  setRedirectUri: (@redirectUri) ->
    @validateStrInput(redirectUri) 

  getResponseType: () ->
    @response_type

  changeResponseType: () ->
    return @response_type = "token" if @response_type is "code"
    @response_type = "code"


  # private
  validateAppId: (appId) ->
    throw new ReferenceError("appId must not be empty") unless appId?
    throw new ReferenceError("appId must not be empty") if appId is ""
    throw new TypeError("appId msut be string") unless appId.substring?

  validateStrInput: (strInput) ->
    throw new TypeError("input must be string") unless strInput.substring? 