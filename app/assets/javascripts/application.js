  //= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require alertify.min
//= require formValidation.min
//= require owl.carousel
//= require rvslider.min
//= require jquery_nested_form
//= require appfunction
//= require custom
//= require moment
//= require bootstrap-datetimepicker
//= require country
//= require select2
//= require jquery.remotipart
//= require ion.rangeSlider.min


  $(document).ajaxStart(function() {       
    $(".ajax-loading").show();
    $('.ajax-loading').css('z-index','9999999999');
  });

  $(document).ajaxStop(function() {   
    $(".ajax-loading").hide();
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