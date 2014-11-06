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
      if voteIds.length > 0
        votes = Votes.find $or: _.map(voteIds, (id) -> _id: id)
        results = {}
        votes.forEach (vote) ->
          if !results[vote.value]
            results[vote.value] =
              value: vote.value
              count: 0
              users: []
          results[vote.value].count += 1
          results[vote.value].users.push vote.ownerName
        VoteResults.insert
          planId: planId
          storyId: storyId
          votes: _.values results
          status: 'open'
          selected: false

  Meteor.publish "votesResult", (planId, voteResultsId) ->
    check planId, String
    if !@userId
      throw new Meteor.Error 401, 'unauthorized access'
    plan = PlanningSessions.findOne planId
    if !plan
      throw new Meteor.Error 404, 'planning session not found'
    VoteResults.find _id: voteResultsId

if Meteor.isClient
  Tracker.autorun ->
    if Session.get('__planId')
      result = PlanningSessions.find Session.get('__planId')
      if result.count() == 1
        plan = result.fetch()[0]
        if plan.lastResultId
          Meteor.subscribe 'votesResult', plan._id, plan.lastResultId
