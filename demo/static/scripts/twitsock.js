$(document).ready(function() {

  var ws; // Our websocket selector
  var regexs = {};

  var generate_string = function(user, message) {
    return '<div class="tweet">' +
      '<div class="author">' + user + '</div>' +
      '<div class="msg">' + message + '</div>' +
      '</div>';
  }

  var get_regexp = function(search_term) {
    if (!regexs[search_term]) {
      regexs[search_term] = new RegExp("(" + search_term + ")", "gi");
    }

    return regexs[search_term];
  }

  var append_message = function(evt) {
    var record = $.parseJSON(evt.data);
    var user = record.name;
    var txt = record.tweet;
    var msg = txt.replace( get_regexp(record.search), "<span class='highlight'>$1</span>");
    $('#tweets').prepend(generate_string(user, msg));
    if ( txt.match(/ruby/) ) {
      $('body').addClass('roll');
    }
  }

  $('#go').click(function() {
    var search_term = $('#search').val();
    console.log("About to launch search on " + search_term);

    ws.send( 'search ' + search_term);
  });

  // Connect to server
  ws = new WebSocket('ws://localhost:9000/ws');
  ws.onopen = function() { console.log("WebSocket opened");};
  ws.onmessage = append_message;

});

