# Planning Poker
# @author Paolo Castro <paolo.castro@jalasoft.com>

# Votes collection
@Votes = new Meteor.Collection 'votes'

if Meteor.isServer
  # Publications

  # Publish votes without the actual vote value.
  Meteor.publish 'votes', (planId, storyId) ->
    Votes.find planId: planId, storyId: storyId, closed: false,
      fields: planId: 1, storyId: 1, userId: 1, status: 1
