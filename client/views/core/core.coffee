Template.signUp.events
  'submit': (event) ->
    event.preventDefault()
    username = $(event.target).find("[type=text]")
    email = $(event.target).find("[type=email]")
    password = $(event.target).find("[type=password]")
    Accounts.createUser
      username: username.val()
      email: email.val()
      password: password.val()
    ,
      (error) ->
        if error
          username.parent().addClass("has-error")
          email.parent().addClass("has-error")
          password.parent().addClass("has-error")
          Notifier.error "Sign up failed", "Verify your username, email and/or password"
          username.focus()
        else
          Notifier.success "Success!", "Welcome!"
          Router.go 'index'

Template.login.events
  'submit': (event) ->
    event.preventDefault()
    username = $(event.target).find("[name=username]")
    password = $(event.target).find("[type=password]")
    Meteor.loginWithPassword username.val(), password.val(), (error) ->
      if error
        username.parent().addClass("has-error")
        password.parent().addClass("has-error")
        username.focus()
        Notifier.error "Login failed", "Invalid login information"
      else
        Notifier.success "Success!", "Welcome back!"
      username.val ""
      password.val ""

Template.index.events
  'click .host': ->
    id = PlanningSessions.insert
      name: moment().format 'L'
      owner: Meteor.userId()
      started: false
    , (error) ->
        console.log error.reason if error
    if id
      Router.go 'planningSessionEdit', _id: id
