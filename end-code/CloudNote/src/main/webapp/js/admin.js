//设置侧边栏的隐藏和展开效果
$(function () {
    // nav收缩展开
    $('.nav-item>a').on('click', function () {
        if (!$('.nav').hasClass('nav-mini')) {
            if ($(this).next().css('display') == "none") {
                //展开未展开
                // $('.nav-item').children('ul').slideUp(300);
                $(this).next('ul').slideDown(300);
                // $(this).parent('li').addClass('nav-show').siblings('li').removeClass('nav-show');
            } else {
                //收缩已展开
                // $(this).next('ul').slideUp(300);
                $('.nav-item.nav-show').removeClass('nav-show');
            }
        }
    });
    //nav-mini切换
    $('#mini').on('click', function () {
        if (!$('.nav').hasClass('nav-mini')) {     //略图
            $('.nav-item.nav-show').removeClass('nav-show');
            $('.nav-item').children('ul').removeAttr('style');
            $('.nav').addClass('nav-mini');
        } else {
            $('.nav').removeClass('nav-mini');
        }
    });
});

$(window).resize(function() {
    var Width = $(window).width();
    if (Width < 1300) {
        if (!$('.nav').hasClass('nav-mini')) {     //略图
            $('.nav-item.nav-show').removeClass('nav-show');
            $('.nav-item').children('ul').removeAttr('style');
            $('.nav').addClass('nav-mini');

        }
    }
    else {
        if(!$('.nav').hasClass('nav-show')) {
            $('.nav').removeClass('nav-mini');

        }
    }
    if (Width<1000) {

    }
});
