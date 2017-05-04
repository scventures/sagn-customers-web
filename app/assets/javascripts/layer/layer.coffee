getIdentityToken = (nonce, callback) ->
  layer.xhr {
    url: Routes.layer_identity_customers_path()
    headers:
      'Content-type': 'application/json'
      'Accept': 'application/json'
      'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')
    method: 'POST'
    data:
      nonce: nonce
  }, (result) ->
    if result.success
      callback result.data.token
    else
      if typeof console != 'undefined'
        console.error 'challenge error: ', result.data
    return
  return

window.setupLayerClient = (appId) ->
  if appId
    client = new (layer.Client)(appId: appId)

  if client
    client.on 'challenge', (evt) ->
      getIdentityToken evt.nonce, (identityToken) ->
        evt.callback identityToken
  client.connect()
  window.layerClient = client

# Handlers

class SagnLayerHandler
  channel_id: undefined
  query: undefined

  constructor: (selector) ->
    @channel_id = $(selector).data("layerChannelId")
    @query = layerClient.createQuery(
      model: layer.Query.Message
      predicate: "conversation.id = '#{ @channel_id }'"
    )
    @bindQueryChangeEvents()

  bindQueryChangeEvents: () ->
    if @query
      @query.on 'change', (evt) =>
        if evt.type == 'insert'
          @processEventData(obj = jQuery.parseJSON(evt.target.parts[0].body))

class CustomerUpdateHandler extends SagnLayerHandler

  constructor: (selector) ->
    super(selector)

  processEventData: (data) ->
    if data.type == 'customer_updated'
      if location.pathname == '/profile'
        $.ajax
          type: 'GET'
          dataType: 'script'
          url: Routes.profile_path()

$.onmount '#profile-details', ->
  $(this).data('layerHandler': new CustomerUpdateHandler(this)) unless $(this).data('layerHandler')
