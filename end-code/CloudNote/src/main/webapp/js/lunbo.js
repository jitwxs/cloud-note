//current position
var pos = 0;
//number of slides
var totalSlides = $('#slider-wrap ul li').length;
//get the slide width
var sliderWidth = $('#slider-wrap').width();


$(document).ready(function(){


    /*****************
     BUILD THE SLIDER
     *****************/
    //set width to be 'x' times the number of slides
    $('#slider-wrap ul#slider').width(sliderWidth*totalSlides);

    //next slide
    $('#next').click(function(){
        slideRight();
    });

    //previous slide
    $('#previous').click(function(){
        slideLeft();
    });
    /*************************
     //*> OPTIONAL SETTINGS
     ************************/
        //automatic slider
    var autoSlider = setInterval(slideRight, 3000);

    //for each slide
    $.each($('#slider-wrap ul li'), function() {
        //set its color
        var c = $(this).attr("data-color");
        $(this).css("background",c);

        //create a pagination
        var li = document.createElement('li');
        $('#pagination-wrap ul').append(li);
    });

    //counter
    countSlides();

    //pagination
    pagination();

    //hide/show controls/btns when hover
    //pause automatic slide when hover
    $('#slider-wrap').hover(
        function(){ $(this).addClass('active'); clearInterval(autoSlider); },
        function(){ $(this).removeClass('active'); autoSlider = setInterval(slideRight, 3000); }
    );



});//DOCUMENT READY



/***********
 SLIDE LEFT
 ************/
function slideLeft(){
    pos--;
    if(pos==-1){ pos = totalSlides-1; }
    $('#slider-wrap ul#slider').css('left', -(sliderWidth*pos));

    //*> optional
    countSlides();
    pagination();
}


/************
 SLIDE RIGHT
 *************/
function slideRight(){
    pos++;
    if(pos==totalSlides){ pos = 0; }
    $('#slider-wrap ul#slider').css('left', -(sliderWidth*pos));

    //*> optional
    countSlides();
    pagination();
}

/************************
 //*> OPTIONAL SETTINGS
 ************************/
function countSlides(){
    $('#counter').html(pos+1 + ' / ' + totalSlides);
}

function pagination(){
    $('#pagination-wrap ul li').removeClass('active');
    $('#pagination-wrap ul li:eq('+pos+')').addClass('active');
}

"use strict";
// 实现动态效果导航栏
(function () {

    var target = document.querySelector(".target");
    var links = document.querySelectorAll(".mynav a");
    var colors = ["deepskyblue", "orange", "firebrick", "gold", "magenta", "black", "darkblue"];

    function mouseenterFunc() {
        if (!this.parentNode.classList.contains("active")) {
            for (var i = 0; i < links.length; i++) {
                if (links[i].parentNode.classList.contains("active")) {
                    links[i].parentNode.classList.remove("active");
                }
                links[i].style.opacity = "0.25";
            }

            this.parentNode.classList.add("active");
            this.style.opacity = "1";

            var width = this.getBoundingClientRect().width;
            var height = this.getBoundingClientRect().height;
            var left = this.getBoundingClientRect().left + window.pageXOffset;
            var top = this.getBoundingClientRect().top + window.pageYOffset;
            var color = colors[Math.floor(Math.random() * colors.length)];

            target.style.width = width + "px";
            target.style.height = height + "px";
            target.style.left = left + "px";
            target.style.top = top + "px";
            target.style.borderColor = color;
            target.style.transform = "none";
        }
    }

    for (var i = 0; i < links.length; i++) {
        links[i].addEventListener("click", function (e) {
            return e.preventDefault();
        });
        links[i].addEventListener("mouseenter", mouseenterFunc);
    }

    function resizeFunc() {
        var active = document.querySelector(".mynav li.active");

        if (active) {
            var left = active.getBoundingClientRect().left + window.pageXOffset;
            var top = active.getBoundingClientRect().top + window.pageYOffset;

            target.style.left = left + "px";
            target.style.top = top + "px";
        }
    }

    window.addEventListener("resize", resizeFunc);
})();