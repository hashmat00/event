// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require rvslider.min
//= require rangeslider.min

//= require jquery_nested_form
//= require custom
//= require moment
//= require bootstrap-datetimepicker
//= require country
//= require select2
//= require jquery.remotipart


    $(document).ajaxStart(function() {       
      $(".ajax-loading").show();
      $('.titleHeader').css('z-index','-99999999');
       $('.mapTextField').css('z-index','-999999999999999');
    });

    $(document).ajaxStop(function() {   
      $(".ajax-loading").hide();
      $('.titleHeader').css('z-index','99999999');
      $('.mapTextField').css('z-index','999999999999999');

    });


  window.fbAsyncInit = function() {
    FB.init({
      appId      : '<%= ENV["FACEBOOK_APP_ID"] %>',
      xfbml      : true,
      version    : 'v2.6'
    });
  };

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));