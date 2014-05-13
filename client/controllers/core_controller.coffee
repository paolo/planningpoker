class @CoreController extends RouteController
  data:
    loggedUser: ->
      Meteor.users.findOne Meteor.userId()
  index: ->
    @render 'index'
  signUp: ->
    @render 'signUp'
  login: ->
    if Meteor.userId()
      Router.go 'index'
    else
      @render 'login'
  logout: ->
    Meteor.logout()
    Router.go 'index'
