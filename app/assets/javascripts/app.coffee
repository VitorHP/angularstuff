
app = angular.module('Bloghub', ['ui.bootstrap', 'ngRoute'])

app.config ($routeProvider, $locationProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'product-list.html'
      controller: 'ProductsController'
    .when '/products/:id',
      templateUrl: 'product-show.html'
      controller: 'ProductsShowController'
    .when '/checkout/cart',
      templateUrl: 'checkout-cart.html'
      controller: 'CartController'
    .otherwise
      redirectTo: '/'

app.factory 'ProductsService', ->
  products = [
    {
      id: 1
      name: 'iPhone'
      photo: 'https://desbloqueados-us-xlsol-com.s3.amazonaws.com/desbloqueados_test/product_images/0000/2950/large.jpg?1382968481'
      variants: [{
        sku: '123'
        color: 'White'
        photo: 'https://desbloqueados-us-xlsol-com.s3.amazonaws.com/desbloqueados_test/product_images/0000/2950/large.jpg?1382968481'
        prices: [{
          priceGroupId: 1
          price: 50.0
        }]
      },{
        sku: '222'
        color: 'Black'
        photo: 'https://desbloqueados-us-xlsol-com.s3.amazonaws.com/desbloqueados_test/product_images/0000/2953/large.jpg?1382968493'
        prices: [{
          priceGroupId: 1
          price: 500.0
        }]
      }]
    },
    {
      id: 2
      name: 'Nexus 4'
      photo: 'https://desbloqueados-us-xlsol-com.s3.amazonaws.com/desbloqueados_test/product_images/0000/2950/large.jpg?1382968481'
      variants: [{
        sku: '555'
        color: 'White'
        photo: 'https://desbloqueados-us-xlsol-com.s3.amazonaws.com/desbloqueados_test/product_images/0000/2950/large.jpg?1382968481'
        prices: [{
          priceGroupId: 1
          price: 50.0
        }]
      },{
        sku: '789'
        color: 'Black'
        photo: 'https://desbloqueados-us-xlsol-com.s3.amazonaws.com/desbloqueados_test/product_images/0000/2953/large.jpg?1382968493'
        prices: [{
          priceGroupId: 1
          price: 500.0
        }]
      }]
    },
  ]

  return {
    all: ->
      products
    find: (id) ->
      filtered = products.filter (item) ->
        item.id == parseInt(id)
      filtered[0]
  }

app.factory 'CartService', ->
  items = []

  findItem = (sku) ->
    filtered = items.filter (item) ->
      item.variant.sku == sku
    filtered[0]

  return {
    add: (variant) ->
      item = findItem(variant.sku)
      if item?
        item.qty += 1
      else
        items.push
          variant: variant
          qty: 1
    remove: (variant, removeAll = false) ->
      item = findItem(variant.sku)
      if item?
        if removeAll || item.qty == 1
          items.splice(items.indexOf(item), 1)
        else
          item.qty -= 1
    items: ->
      items
    count: ->
      items.reduce (memo, item, index, array) ->
        return memo + item.qty
      , 0
  }

app.directive 'productdetail', ->
  return {
    restrict: 'E'
    templateUrl: 'product-detail.html'
  }

app.directive 'productimage', ->
  return {
    restrict: 'E'
    templateUrl: 'product-image.html'
  }

app.directive 'cart', ->
  return {
    restrict: 'E'
    templateUrl: 'cart.html'
  }

app.controller 'ProductsController', ($scope, ProductsService) ->
  $scope.products = ProductsService.all()

app.controller 'ProductsShowController', ($scope, $routeParams, ProductsService, CartService) ->
  $scope.product = ProductsService.find($routeParams.id)
  $scope.sku     = $scope.product.variants[0].sku

  $scope.findVariant = (sku) ->
    filtered = $scope.product.variants.filter (item) ->
      item.sku == sku
    filtered[0]

  $scope.$watch 'sku', (newValue, oldValue) ->
    $scope.selectedVariant = $scope.findVariant(newValue)

  $scope.addToCart = (variant) ->
    CartService.add(variant)

app.controller 'CartController', ($scope, CartService) ->
  $scope.count = ->
    CartService.count()

  $scope.items = ->
    CartService.items()

  $scope.add = (variant) ->
    CartService.add(variant)

  $scope.remove = (variant, removeAll = false) ->
    CartService.remove(variant, removeAll)

  $scope.empty = ->
    CartService.count() == 0
