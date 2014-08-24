Template.planningSessionEdit.events
  'change input[type=text]': (evt) ->
    name = evt.target.name
    modifier =
      $set: {}
    modifier.$set[name] = evt.target.value
    PlanningSessions.update this._id, modifier

  # Start planning session
  'click .pp-start': (evt) ->
    evt.preventDefault()
    projectId = $("#pt-projects :selected").val()
    if @session.name.trim() == ''
      Notifier.error 'Missing name', 'Add a name to your planning session'
    else if @session.owner != Meteor.userId()
      Notifier.error 'Action Unauthorized', 'Your not the owner of this planning session'
    else if !Projects.findOne(projectId)
      Notifier.error 'Invalid Project', 'The project you selected is not a valid project'
    else
      PlanningSessions.update @session._id,
        $set:
          started: true
          closed: false
          projectId: projectId
      Meteor.call "loadStories", @session._id
      Notifier.success 'Planning Session started', 'Your planning session has successfully started and is live now!'
      Router.go 'planningSessionLive',
        _id: @session._id

Template.planningSessionLive.events
  'click a.list-group-item': () ->
    planId = Session.get '__planId'
    plan = PlanningSessions.findOne planId
    if plan && plan.owner == Meteor.userId()
      PlanningSessions.update planId,
        $set:
          selectedStory: @_id

Template.planningSessionLive.helpers
  'selectedStory': ->
    storyId = @session.selectedStory
    Stories.findOne storyId
  'sessionOwner': ->
    planId = Session.get '__planId'
    plan = PlanningSessions.findOne planId
    plan && plan.owner == Meteor.userId()
  'storiesClass': ->
    planId = Session.get '__planId'
    plan = PlanningSessions.findOne planId
    if plan && plan.owner == Meteor.userId()
      "panel-info"
    else
      "panel-default"
  'activeStoryClass': ->
    planId = Session.get '__planId'
    plan = PlanningSessions.findOne planId
    if plan && plan.selectedStory == @_id
      "list-group-item-info"
    else
      ""
