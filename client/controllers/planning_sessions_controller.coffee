Router.map () ->
  @route 'planningSessionEdit',
    path: "/plan/:_id/edit"
    controller: 'PlanningSessionsController'
    action: 'edit'

class @PlanningSessionsController extends RouteController
  waitOn: ->
    Meteor.subscribe 'planningSession', @params._id
  data: ->
    PlanningSessions.findOne @params._id
  edit: ->
    if !PlanningSessions.findOne @params._id
      Router.go '/404'
    else
      @render 'planningSessionEdit'
