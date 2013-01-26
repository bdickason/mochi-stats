AppRouter = Backbone.Router.extend 
  
  routes: 
    '': 'home',
    'customers': 'listCustomers'

  listCustomers: ->
    customerList = new CustomerCollection
    customerList.fetch 
      success: ->
        $('#content').html(new CustomerListView({model: customerList }).el)



Customer = Backbone.Model.extend 
  idAttribute: 'uid',
  urlRoot: '/customers'

customer = new Customer

CustomerCollection = Backbone.Collection.extend
  model: Customer,
  url: '/customers'
  
  
CustomerListView = Backbone.View.extend 
  initialize: ->
    @render()
  
  render: ->
    customers = @model.models
    len = customers.length
    $(@el).html "<ul class='customers'></ul>"

    for customer in customers
      console.log new CustomerView(model: customer).render().el
      $('.customers', @el).append new CustomerView(
        model: customer).render().el

CustomerView = Backbone.View.extend
  tagName: 'li',
  
  initialize: ->
    @model.bind 'change', @render, @
    @model.bind 'destroy', @close, @
  
  render: ->
    console.log @model.toJSON()
    $(@el).html(@model.toJSON().uid)
    return @
  

### Start the app ###

app = new AppRouter
Backbone.history.start()