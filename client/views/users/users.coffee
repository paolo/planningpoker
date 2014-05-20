Template.userSettings.events
  'change input': (event) ->
    name = event.target.name
    if name != 'username'
      name = 'profile.' + name
    modifier = {}
    modifier['$set'] = {}
    modifier['$set'][name] = event.target.value
    Meteor.users.update {_id: Meteor.userId()}, modifier
