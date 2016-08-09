////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// jQuery
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

var $ = jQuery.noConflict();

$(document).ready(function($) {

    
    //Search page hidden content
    $('#toggle-link').on('click',function(e) {
        var $message = $('#hidden_content');
        if ($message.css('display') != 'block') {
            $message.show();
            var firstClick = true;
            $(document).bind('click.myEvent', function(e) {
                if (!firstClick && $(e.target).closest('#hidden_content').length == 0) {
                    $message.hide();
                    $(document).unbind('click.myEvent');
                }
                firstClick = false;
            });
        }
        e.preventDefault();
    });


    
    // Show rating form
    $(function showRatingForm() {
        $('#leave-reply').hide();
        $("#show-reply-form").click(function () {
            $('#leave-reply').show();
            $('#leave-reply').css('height','380');
        }); 
    });

    //  Rating stars
    var ratingUser = $('.rating-user');
    if (ratingUser.length > 0) {
        $('.rating-user .inner').raty({
            path: 'assets/img',
            starOff : 'big-star-off.png',
            starOn  : 'big-star-on.png',
            width: 150,
            targetType : 'number',
            targetFormat : 'Rating: {score}',
        });
    }
        
    // Property page tabs
    $('.tabs .tab-links a').on('click', function(e)  {
        var currentAttrValue = $(this).attr('href');
        var priceSlider = $('.jslider').detach();
        $('.tabs ' + currentAttrValue).slideDown(400).siblings().slideUp(400);
        $(this).parent('li').addClass('active').siblings().removeClass('active');
        
        priceSlider.appendTo($('.tabs ' + currentAttrValue).find('.price-range-wrapper'));
        priceSlider = null;
        e.preventDefault();
    });

    //  Price slider search page 
    if( $(".price-input").length > 0) {
        $(".price-input").each(function() {
            var vSLider = $(this).slider({
                from: 0,
                to: 9000000,
                smooth: true, 
                round: 0,       
                dimension: ',00&nbsp;$',
            }); 
        });
    }

    //Magnific popup init
    if ($('.image-popup').length > 0 ) {
        $('.image-popup').magnificPopup({type:'image'});
    }
    
    //  Pricing Tables in Submit page
    if ($('.submit-pricing').length > 0 ){
        $('.but-sel').click(function() {
            $('.submit-pricing .buttons td').each(function () {
                $(this).removeClass('package-selected');
            });
            $(this).parent().css('opacity','1');
            $(this).parent().addClass('package-selected');
        }
        );
    }
    //  iCheck
    if ($('.switch').length > 0) {
        $('.switch input').iCheck();
    }

    if ($('.radio').length > 0) {
        $('input').iCheck();
    }
    if ($('.checkbox').length > 0) {
        $('input:not(.no-icheck)').iCheck();
    }

    var touchHover = function() {
    $('[data-hover]').click(function(e){
        e.preventDefault();
        var $this = $(this);
        var onHover = $this.attr('data-hover');
        var linkHref = $this.attr('href');
        if (linkHref && $this.hasClass(onHover)) {
            location.href = linkHref;
            return false;
        }
        $this.toggleClass(onHover);
    });
};
 
    // Video Wrapping with container preserves width and height
    $( 'embed, iframe' ).wrap( "<div class='video-container'></div>" );
    
    // Set Bookmark button attribute
    $( ".bookmark" ).each(function(index) {
        $(this).on("click", function(){

            if ($(this).data('bookmark-state') == 'empty') {
                $(this).removeClass('bookmark-added');
            } else if ($(this).data('bookmark-state') == 'added') {
                $(this).addClass('bookmark-added');
            }

            var is_choose = 0;
            var property_id = $(this).data('propertyid');

            if ($(this).data('bookmark-state') == 'empty') {
                $(this).data('bookmark-state', 'added');
                $(this).addClass('bookmark-added');
                is_choose = 1;
            } else if ($(this).data('bookmark-state') == 'added') {
                $(this).data('bookmark-state', 'empty');
                $(this).removeClass('bookmark-added');
                is_choose = 0;
            }
            
            var data = { action: 'add_user_bookmark', property_id : property_id, is_choose : is_choose };

            return false;
        });
    });
    
    // Set Compare button attribute
    $( ".compare" ).each(function(index) {
        $(this).on("click", function(){
            if ($(this).data('compare-state') == 'empty') {
                $(this).removeClass('compare-added');
            } else if ($(this).data('compare-state') == 'added') {
                $(this).addClass('compare-added');
            }
            var is_choose = 0;
            var property_id = $(this).data('propertyid');
            if ($(this).data('compare-state') == 'empty') {
                $(this).data('compare-state', 'added');
                $(this).addClass('compare-added');
                is_choose = 1;
            } else if ($(this).data('compare-state') == 'added') {
                $(this).data('compare-state', 'empty');
                $(this).removeClass('compare-added');
                is_choose = 0;
            }
            var data = { action: 'add_user_bookmark', property_id : property_id, is_choose : is_choose };
            return false;
        });
    });

    function sliderpoint() {
        var slider_width = parseInt($(".jslider").css('width'), 10);
        var right_point = parseInt($(".jslider-pointer.jslider-pointer-to").css('left'), 10);
        var left_point = parseInt($(".firstpoint").css('left'), 10);
        left_point = 100*left_point/slider_width;
        right_point = 100*right_point/slider_width;
        if (right_point > 97) { $('.jslider-pointer.jslider-pointer-to').addClass('slide-right'); } 
        if (right_point <= 97){ $('.jslider-pointer.jslider-pointer-to').removeClass('slide-right'); } 
        if (left_point > 97) { $('.firstpoint').addClass('slide-right'); } 
        if (left_point <= 97){ $('.firstpoint').removeClass('slide-right'); } 
    }

    $('.jslider-pointer').addClass('firstpoint'); 
    $('.jslider-pointer.jslider-pointer-to').removeClass('firstpoint'); 

    $(".price-range-wrapper").mousemove(sliderpoint);
});

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// On RESIZE
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

$(window).on('resize', function(){
    equalHeight('.equal-height');
    // Set Owl Carousel width on resize window
    $('.carousel-full-width').css('width', $(window).width());   
});

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// On LOAD
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

$(window).load(function(){

    //  Show counter after appear
    var $number = $('.number');
    var $grid;
    
    if ($number.length > 0 ) {
        $number.waypoint(function() {
            initCounter();
        }, { offset: '100%' });
    }


    function disableClick(){
        $('.owl-carousel .property').css('pointer-events', 'none');
    }
    // Enable click after dragging
    function enableClick(){
        $('.owl-carousel .property').css('pointer-events', 'auto');
    }

    if ($('.owl-carousel').length > 0) {
        if ($('.carousel-full-width').length > 0) {
            setCarouselWidth();
        }
        if ( parseInt( $('.testimonials-carousel').find('.item').length ) <= 1 ) {
            t_f_test = false;
        } else {
            t_f_test = true;
        }
        $(".testimonials-carousel").owlCarousel({
            items: 1,
            responsiveBaseWidth: ".testimonial",
            pagination: true,
            nav:t_f_test,
            slideSpeed : 700,
            loop:t_f_test,
            touchDrag:t_f_test,
            mouseDrag:t_f_test,
            navText: [
            "<i class='fa fa-chevron-left'></i>",
            "<i class='fa fa-chevron-right'></i>"
            ],
        });
    }
    function sliderLoaded(){
        $('#slider').removeClass('loading');
        document.getElementById("loading-icon").remove();
        centerSlider();
    }
    function animateDescription(){
        var $description = $(".slide .overlay .info");
        $description.addClass('animate-description-out');
        $description.removeClass('animate-description-in');
        setTimeout(function() {
            $description.addClass('animate-description-in');
        }, 400);
    }

    //Preloader
    var $preloader = $('#page-preloader');
    $preloader.fadeOut('slow');
    $spinner = $preloader.find('.gps_ring');
    $spinner2 = $preloader.find('.gps_ring2');
    $spinner.fadeOut();
    $spinner2.fadeOut();
});

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//  Equal heights
function equalHeight(container) {
    var currentTallest = 0,
    currentRowStart = 0,
    rowDivs = new Array(),
    $el,
    topPosition = 0;
    $(container).each(function() {

        $el = $(this);
        $($el).height('auto');
        topPostion = $el.position().top;

        if (currentRowStart != topPostion) {
            for (currentDiv = 0 ; currentDiv < rowDivs.length ; currentDiv++) {
                rowDivs[currentDiv].height(currentTallest);
            }
            rowDivs.length = 0; // empty the array
            currentRowStart = topPostion;
            currentTallest = $el.height();
            rowDivs.push($el);
        } else {
            rowDivs.push($el);
            currentTallest = (currentTallest < $el.height()) ? ($el.height()) : (currentTallest);
        }
        for (currentDiv = 0 ; currentDiv < rowDivs.length ; currentDiv++) {
            rowDivs[currentDiv].height(currentTallest);
        }
    });
}

//funny numbers counter
function initCounter(){
    $('.number').countTo({
        speed: 3000,
        refreshInterval: 50,
        onComplete: function (value) {
            window.initCounter=function(){return false;};
        }
    });
}

// Set Owl Carousel width
function setCarouselWidth(){
    $('.carousel-full-width').css('width', $(window).width());
}