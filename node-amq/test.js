var amqService = require('./amqService.js')

function timeout () {
  setTimeout(function () {
    amqService.getMessage()
      .then(function (msg) {
        console.error('Got msg:', msg)
      })
    timeout()
  }, 2000)
}

timeout()

// amqService.getMessage()
//   .then(function (msg) {
//     console.error('Yay!')
//   })
//   .catch(function (err) {
//     console.error(err)
//     console.error('Got an error.  See above')
//   })
