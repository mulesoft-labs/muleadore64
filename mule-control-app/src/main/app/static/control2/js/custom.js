$("#showMainScreenButton").click(function() {
  setScreen('d');
});

$("#showLogoScreenButton").click(function() {
  setScreen('a');
});

$("#showTweetScreenButton").click(function() {
  setScreen('c');
});

$("#showLightsScreenButton").click(function() {
  setScreen('d');
});

$("#showArchitectureScreenButton").click(function() {
  setScreen('b');
});

$("#sendTweetButton").click(function() {

  var tweetContent = $("#tweetInput").val();

  var data = { tweet: tweetContent };

  $.ajax({
    type: 'POST',
    url: baseUrl + '/api/tweet',
    data: data,
    success: function(data, textStatus, jqXHR) {
      $("#tweetInput").val('')
      toastr.clear();
      toastr.success('Success');
    },
    error: function (jqXHR, textStatus, e) {
      toastr.remove();
      var $toast = toastr.error(e);
    }
  });
});

function setScreen(screenId) {
  $.ajax({
    method: 'POST',
    contentType: 'application/json',
    url: baseUrl + '/api/raw',
    data: {
      type: 'raw',
      c64command: screenId
    },
    success: function(data, textStatus, jqXHR) {
      toastr.success('Success');
    },
    error: function (jqXHR, textStatus, e) {
      var $toast = toastr.error(e.message);
    }
  });
}

