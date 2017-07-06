document.addEventListener('turbolinks:load', function () {
  var  products_awaiting_fulfilment = document.querySelectorAll('table.orders tr[data-fulfiled=false]')
  products_awaiting_fulfilment.forEach(function (product) {
    App.cable.subscriptions.create(
      {
        channel: "OrderFulfilmentChannel", order_id: product.dataset.orderId
      },
      {
        received: function (data) {
          this.updateProduct(data)
          if (data['max'] === data['value']) this.unsubscribeWithExtras()
        },
        updateProduct: function (data) {
          var lastUpdate = new Date(parseFloat(product.dataset.lastUpdate || 0)*1000)
          var dataTimestamp = new Date(parseFloat(data['timestamp'])*1000)
          if (lastUpdate < dataTimestamp) {
            this.updateProgress(data)
            this.updateStatus(data['status_text'])
            product.dataset.lastUpdate = dataTimestamp.valueOf()/1000
          }
        },
        updateProgress: function (data) {
          var progress = product.querySelector('progress')
          progress.max = data['max']
          progress.value = data['value']
          if (data['max'] === data['value']) {
            var span = document.createElement('span')
            span.innerText = 'Complete'
            progress.replaceWith(span)
          }
        },
        updateStatus: function (status) {
          if (status) {
            var span = product.querySelector('.order__status--unfulfiled')
            span.innerText = status
          }
        },
        unsubscribeWithExtras: function () {
          // how can the original unsubscribe() be called if this were to have the same name?
          var orderStatus = product.querySelector('[class^="order__status"]')
          orderStatus.innerText = 'Fulfilled'
          orderStatus.classList.remove('order__status--unfulfiled')
          orderStatus.classList.add('order__status--fulfiled')
          this.unsubscribe()
        }
      }
    )
  })
})
