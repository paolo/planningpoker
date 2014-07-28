# Planning Poker
# @author: Paolo Castro <paolocastro.deb@gmail.com>

# Notifier wrapper
@Notifier =
  notify: (title, text, type) ->
    new PNotify
      title: title
      text: text
      type: type ? type : 'notice'
      styling: 'bootstrap3'
      buttons:
        sticker: false
      delay: 4000

  notice: (title, text) ->
    @notify title, text, 'notice'

  info: (title, text) ->
    @notify title, text, 'info'

  success: (title, text) ->
    @notify title, text, 'success'

  error: (title, text) ->
    @notify title, text, 'error'
