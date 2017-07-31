$ ->

  class SagnWsHandler
    channel_id = null
    last_obj = null

    constructor: (selector) ->
      @channel_id = $(selector).data('messenger-channel-id')

      return false unless @channel_id
      @bindWsClient()


  class ProfileHandler extends SagnWsHandler
    @selector: '#profile-details'

    constructor: () ->
      super(@constructor.selector)

    bindWsClient: () =>
      if @channel_id
        App.global_chat = App.cable.subscriptions.create {
            channel: 'NotificationsChannel'
            channel_id: @channel_id
          },
          received: (data) ->
            console.log('Received: ', data)
            if data.length
              obj = JSON.parse(data)
              if JSON.stringify(@last_obj) != JSON.stringify(obj)
                dispatchFromLocalStorage(false)
                @last_obj = obj
                $.ajax
                  type: 'GET'
                  dataType: 'script'
                  url: $(ProfileHandler.selector).data('profile-url')
                  beforeSend: (xhr, settings) ->
                    $("#{ProfileHandler.selector}").addClass 'loading'
                  success: (data) ->
                    eval data
                    $("#{ProfileHandler.selector}").removeClass 'loading'

  # initialize ws client
  new ProfileHandler()
