Router.map () ->
  @route 'planningSessionEdit',
    path: "/plans/:_id/edit"
    controller: 'PlanningSessionsController'
    action: 'edit'
    waitOn: ->
      [
        Meteor.subscribe 'planningSession', @params._id
        Meteor.subscribe 'planProjects', @params._id
      ]
    data: ->
      session: PlanningSessions.findOne @params._id
      projects: Projects.find().fetch()

class @PlanningSessionsController extends RouteController
  edit: ->
    if !PlanningSessions.findOne @params._id
      Router.go '/404'
    else
      Meteor.call 'loadProjects', @params._id
      @render 'planningSessionEdit'
