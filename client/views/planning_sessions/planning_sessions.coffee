Template.planningSessionEdit.events
  'change input[type=text]': (evt) ->
    name = evt.target.name
    modifier =
      $set: {}
    modifier.$set[name] = evt.target.value
    PlanningSessions.update this._id, modifier
