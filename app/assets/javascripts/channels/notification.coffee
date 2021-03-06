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
            if obj.type == 'customer_updated' && JSON.stringify(@last_obj) != JSON.stringify(obj)
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

class CurrentRequestHandler extends SagnWsHandler
  @selector: '#current-request-details'

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
            if obj.type == 'service_requests_assignment_updated' && JSON.stringify(@last_obj) != JSON.stringify(obj)
              @last_obj = obj
              $(".current-status-#{obj.service_request_assignment.service_request_id}").html(obj.latest_activity_status)
              if $(".current-request-wrapper#current-request-details-#{obj.service_request_assignment.service_request_id}").hasClass('selected')
                loadServiceRequestDetails(obj.service_request_assignment.service_request_id)

$(document).on 'turbolinks:load', ->
  # initialize ws client
  new ProfileHandler()
  new CurrentRequestHandler()
