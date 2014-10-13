# Planning Poker
# @author: Paolo Castro <paolocastro.deb@gmail.com>

# Vote Results collection
@VoteResults = new Meteor.Collection 'voteResults'

if Meteor.isServer
  Meteor.methods
    createResult: (planId, storyId, voteIds) ->
      if !@userId
        throw new Meteor.Error 401, 'Unable to access'
      plan = PlanningSessions.findOne planId
      if !plan
        throw new Meteor.Error 404, 'Planning session not found'
      if plan.owner != @userId
        throw new Meteor.Error 403, 'Unauthorized operation'
      story = Stories.findOne storyId
      if !story
        throw new Meteor.Error 404, 'User story not found'
      if votes.length > 0
        votes = Votes.find $or: _.map(voteIds, (id) -> _id: id),
          sort: value: -1
        results = {}
        votes.forEach (vote) ->
          if !results[vote.value]
            results[vote.value].value = vote.value
            results[vote.value].count = 0
          results[vote.value].count += 1
          results[vote.value].users.push vote.owner
        VoteResults.insert
          planId: planId
          storyId: storyId
          votes: _.values results
          status: 'open'
          selected: false
