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
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require cocoon
//= require zoom
//= require turbolinks

//jQuery is required to run this code
$( document ).ready(function() {


    $('.datepicker').datepicker({
        format: 'yyyy/mm/dd',
        startDate: '3d'
    });

    $('#shares').on('cocoon:after-insert', function(e, insertedItem) {
        $('.datepicker').datepicker({
            format: 'yyyy/mm/dd',
            startDate: '3d'
        });
    });

    get_slider();

    scaleVideoContainer();

    initBannerVideoSize('.video-container .poster img');
    initBannerVideoSize('.video-container .filter');
    initBannerVideoSize('.video-container video');

    $(window).on('resize', function() {
        scaleVideoContainer();
        scaleBannerVideoSize('.video-container .poster img');
        scaleBannerVideoSize('.video-container .filter');
        scaleBannerVideoSize('.video-container video');
    });

});

function scaleVideoContainer() {

    var height = $(window).height() + 5;
    var unitHeight = parseInt(height) + 'px';
    $('.homepage-hero-module').css('height',unitHeight);

}

function initBannerVideoSize(element){

    $(element).each(function(){
        $(this).data('height', $(this).height());
        $(this).data('width', $(this).width());
    });

    scaleBannerVideoSize(element);

}

function scaleBannerVideoSize(element){

    var windowWidth = $(window).width(),
        windowHeight = $(window).height() + 5,
        videoWidth,
        videoHeight;

    console.log(windowHeight);

    $(element).each(function(){
        var videoAspectRatio = $(this).data('height')/$(this).data('width');

        $(this).width(windowWidth);

        if(windowWidth < 1000){
            videoHeight = windowHeight;
            videoWidth = videoHeight / videoAspectRatio;
            $(this).css({'margin-top' : 0, 'margin-left' : -(videoWidth - windowWidth) / 2 + 'px'});

            $(this).width(videoWidth).height(videoHeight);
        }

        $('.homepage-hero-module .video-container video').addClass('fadeIn animated');

    });
}

function get_slider() {
    $("#the_slider").slider({
        range: true,
        min: 100,
        max: 700,
        values: [200, 500],
        slide: function(event, ui) {
            $('#amount').val( "$" + ui.values[0] + " - $" + ui.values[1] );
            $('#shares_price_gteq').val(ui.values[0]);
            $('#shares_price_lteq').val(ui.values[1]);
        }
    });

    $('#amount').val("$" + $('#the_slider').slider("values", 0) + " - $" + $('#the_slider').slider("values", 1));
    $( "#the_slider" ).css('background', '#319f52');
    $("#the_slider .ui-slider-range" ).css('background', '#319f52');
    $("#the_slider .ui-slider-handle").css('background', 'white');
    $("#the_slider .ui-slider-handle").css('border', '1px solid gray');
}