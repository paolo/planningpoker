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
    if @session.name.trim() == ''
      Notifier.error 'Missing name', 'Add a name to your planning session'
    else if @session.owner != Meteor.userId()
      Notifier.error 'Action Unauthorized', 'Your not the owner of this planning session'
    else
      PlanningSessions.update @session._id,
        $set:
          started: true
          closed: false
      Notifier.success 'Planning Session started', 'Your planning session has successfully started and is live now!'
      Router.go 'planningSessionLive',
        _id: @session._id
