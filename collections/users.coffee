Meteor.users._transform = (user) ->
  if user.profile && user.profile.name
    user.displayName = user.profile.name
  else
    user.displayName = user.username
  user