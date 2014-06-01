Template.loginButtons.events
  'click button': (event) ->
    event.preventDefault()
    Router.go 'login'

Template.loginButtons.helpers
  loggedUser: ->
    Meteor.users.findOne Meteor.userId()