$(document).ready(function() {

  var ws; // Our websocket selector
  var regexs = {};

  var generate_string = function(user, message) {
    return '<div class="tweet">' +
      '<div class="author">' + user + '</div>' +
      '<div class="msg">' + message + '</div>' +
      '</div>';
  }

  var append_message = function(evt) {
    var record = $.parseJSON(evt.data);
    var user = record.name;
    var rx = regexs[record.search];
    var txt = record.tweet;
    var msg = txt.replace( rx, "<span class='highlight'>$1</span>");
    $('#tweets').prepend(generate_string(user, msg));
    if ( txt =~ /ruby/ ) {
      $('body').addClass('roll');
    }
  }

  $('#go').click(function() {
    var search_term = $('#search').val();
    console.log("About to launch search on " + search_term);
    regexs[search_term] = new RegExp("(" + search_term + ")", "gi");

    ws.send( 'search ' + search_term);
  });

  // Connect to server
  ws = new WebSocket('ws://localhost:9000/ws');
  ws.onopen = function() { console.log("WebSocket opened");};
  ws.onmessage = append_message;

});

