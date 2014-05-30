Meteor.users._transform = (user) ->
  if user.profile.fullName
    user.displayName = user.profile.name
  else
    user.displayName = user.username
  user