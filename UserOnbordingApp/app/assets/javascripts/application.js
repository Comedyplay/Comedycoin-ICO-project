// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker
//= require rails.validations
//= require clipboard
//= require custom


$(document).ready(function(){
  
  var clipboard = new Clipboard('.clipboard-btn');
  console.log(clipboard);

  $(".help-btn").click(function(){
    $(".message-box").show(); 
  });

  $("#cancel-btn").click(function(){
    $(".message-box").hide(); 
  });

  $(".attachment").click(function(){
    $(".fa-upload, .upload-text, .attachment br, .upload-image").hide();
    $("#myImg").css("opacity", "1");
  });

  $("#aggrement_checkbox").click(function(){
    $("#aggrement_button").toggleClass("button-color");
  });
});


$(document).on('ready page:load', function() {
  var path1 = window.location.pathname.split('/')[2]
  var path2 = window.location.pathname.split('/')[1]
  if(path1 == "agreement")
    $("#aggrement_link").addClass('active');
  else if(path2 == "payment"){
    $("#payment_link").addClass('active');
    $("#aggrement_link").css("color","green");
    $("#identity_link").css("color","green");
    $("#aggrement_span").css("background-color","green");
    $("#aggrement_span").css("display","none");
    $("#identity_span").css("background-color","green");
    $("#identity_span").css("display","none");
    $("#aggrement_check").css("background-color","green");
    $("#aggrement_check").addClass("active");
    $("#identity_check").css("background-color","green");
    $("#identity_check").addClass("active");
  }
  else if(path1 == "confirmation"){
    $("#confirmation_link").addClass('active');
    $("#aggrement_link").css("color","green");
    $("#identity_link").css("color","green");
    $("#payment_link").css("color","green");
    $("#aggrement_span").css("background-color","green");
    $("#aggrement_span").css("display","none");
    $("#identity_span").css("background-color","green");
    $("#identity_span").css("display","none");
    $("#identity_span").css("background-color","green");
    $("#aggrement_check").css("background-color","green");
    $("#aggrement_check").addClass("active");
    $("#identity_check").css("background-color","green");
    $("#identity_check").addClass("active");
    $("#payment_check").css("background-color","green");
    $("#payment_check").addClass("active");
    $("#payment_span").css("display","none");
  }
  else {
    $("#identity_link").addClass('active');
    $("#aggrement_link").css("color","green");
    $("#aggrement_span").css("background-color","green");
    $("#aggrement_span").css("display","none");
    $("#aggrement_check").css("background-color","green");
    $("#aggrement_check").addClass("active");
  }
});