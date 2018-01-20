//设置侧边栏的隐藏和展开效果
var check = [false,false,false,false];
$(function(){
    var content=document.getElementById("sbwxs");
    var items=content.getElementsByTagName("ul");
    for(i=0;i<4;i++) {
        if(check[i]) {
            var itemss=items[i].getElementsByTagName("li");
            $(itemss).next('ul').slideDown(300);
        }
    }
    // nav收缩展开
    $('.nav-item>a').on('click',function(){
        alert(check[1]);
        if (!$('.nav').hasClass('nav-mini')) {
            if ($(this).next().css('display') == "none") {
                //展开未展开
                // $('.nav-item').children('ul').slideUp(300);
                $(this).next('ul').slideDown(300);
                check[1]=true;
                for(var j=0;j<4;j++) {
                    alert("j="+j);
                    console.log(j);
                    var itemss=items[j].getElementsByTagName("li");
                    if(this != itemss)
                        alert("hahah");
                }
                }
                // $(this).parent('li').addClass('nav-show').siblings('li').removeClass('nav-show');
            }else{
                //收缩已展开
                $(this).next('ul').slideUp(300);
                $('.nav-item.nav-show').removeClass('nav-show');
            }
    });
    //nav-mini切换
    $('#mini').on('click',function(){
        if (!$('.nav').hasClass('nav-mini')) {     //略图
            $('.nav-item.nav-show').removeClass('nav-show');
            $('.nav-item').children('ul').removeAttr('style');
            $('.nav').addClass('nav-mini');
        }else{
            $('.nav').removeClass('nav-mini');
        }
    });
});


function setCookie(c_name,value,expiredays) {
    var exdate=new Date();
    exdate.setDate(exdate.getDate()+expiredays);
    alert(exdate.getDate()+expiredays);
    document.cookie=c_name+ "=" +escape(value)+((expiredays==null) ? "" : ";expires="+exdate.toGMTString())+";path=/;domain=b.com";
}
window.onload=function(){
    setCookie("listallwjh","sfwjh");
    alert("Cookie设置成功！");
}





