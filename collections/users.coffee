Meteor.users._transform = (user) ->
  if user.profile.fullName
    user.displayName = user.profile.fullName
  else
    user.displayName = user.username
  user