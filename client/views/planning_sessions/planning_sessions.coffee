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
  'click a.story-item': () ->
    planId = Session.get '__planId'
    plan = PlanningSessions.findOne planId
    if plan && plan.owner == Meteor.userId()
      PlanningSessions.update planId,
        $set:
          selectedStory: @_id
      , (error) ->
        if !error && Session.get('planningSessionLiveView') == 'stories'
          Router.go 'planningSessionLive',
            _id: planId
  'click .pp-start': (evt) ->
    evt.preventDefault()
    storyId = $(evt.target).data('storyId')
    plan = PlanningSessions.findOne(Session.get('__planId'))
    if plan && plan.owner == Meteor.userId()
      Meteor.call "openVoting", plan._id, storyId

Template.planningSessionLive.helpers
  'selectedStory': ->
    storyId = @session.selectedStory
    Stories.findOne storyId
  'sessionOwner': ->
    planId = Session.get '__planId'
    plan = PlanningSessions.findOne planId
    plan && plan.owner == Meteor.userId()
  'votingOpen': ->
    planId = Session.get '__planId'
    plan = PlanningSessions.findOne planId
    plan.votingOn == @_id
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
      "active"
    else
      ""
  'currentView': (view) ->
    Session.get('planningSessionLiveView') == view
  'activeView': (view) ->
    if Session.get('planningSessionLiveView') == view
      return 'active'

Template.memberItem.helpers
  onlineStatus: ->
    if @member.status && @member.status.idle
      "member-idle"
    else
      "member-online"
  isMe: ->
    @member._id == Meteor.userId()

Template.memberItem.events
  'click a.make-organizer': (evt) ->
    evt.preventDefault();
    Meteor.call "giveOwnership", Session.get('__planId'), $(evt.currentTarget).data('userId'), (err) ->
      unless err
        Notifier.info "Ownership delivered", "You're no longer the organizer of this session"
