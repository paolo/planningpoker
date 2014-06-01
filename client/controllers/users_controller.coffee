Router.map () ->
  @route 'settings',
    path: '/me/settings'
    controller: 'UsersController'
    action: 'settings'

class @UsersController extends RouteController
  data: ->
    user: Meteor.users.findOne Meteor.userId()
  settings: ->
    @render 'userSettings'
  
