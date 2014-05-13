Template.loginButtons.events
  'click button': (event) ->
    event.preventDefault()
    Router.go 'login'
