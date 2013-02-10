//= require_tree .

$(window).load(function(e){
  
  //
  // Turn any alt tags on an image into a caption
  // Crop our images to be a multiple of the baseline heigh
  //

  $("p > img").each(function(index){

    // Find our image alt title and wrap it in a caption
    var caption = $(this).attr('alt');
    $(this).after("<span class='caption'>"+caption+"</span>");

    var baselineHeight = 26; // TODO: this shouldn't be hardcoded...
    $(this).wrap("<div class='image_cropper'>");

    // get height of img
    var height = $(this).height();
    while(height % baselineHeight != 0){
      // find match on baseline height
      height--;
    }

    // specifically set height to be correct.
    $(this).parents("div.image_cropper").css({"height": height});
    // $(this).parents("div.image_cropper").css({"width": $(this).width()});

    // note that an image is in this p
    $(this).parents("p").addClass("image_container drop-shadow 1curved 1curved-vt-2 1curved-hz-2");

  });
})

$(document).ready(function(){

//   // if($("div.project div.meta ul")){
//   //   var links = $("div.project div.meta ul").html();
//   //   $("a.scroll_to_top").parents("ul").append(links);
//   // }

//   // $("body")
//   //   .on('click', "a", function(e){
//   //     var href = $(this).attr('href');
//   //     if(href.match(/https?\:\/\//)){
//   //       // external link, so regular load
//   //       return true;
//   //     }
//   //     var success = function(data){
//   //       history.pushState(null, null, href);
//   //       $("div.main").html($(data).filter("div.main").html());
//   //       $("body title").html($(data).filter("title").html());
//   //       $("html,body").animate({scrollTop: 0}, 100);
//   //       $("div.main").css({top: "-10px"}).animate({opacity: 1, top: "0px"});
//   //     };
//   //     $('div.main')
//   //       .animate(
//   //         {
//   //           opacity: 0,
//   //           position: "relative",
//   //           top: "+5px"
//   //         },
//   //         250,
//   //         function(){
//   //           $.get(href, success);
//   //         });
      
//   //   return false;
//   // });

  var articlesFilterOpacityLevel = 0.6;
  var publisherHasCategoryMap = {}
  var currentArticlesFilter = {
    publisher: null,
    category: null
  };

  // build publisher => [categories] map
  $("ul.articles li").each(function(){
    $this = $(this);
    // pull out the articles category and publisher
    var publisher = $this.data('publisher');
    var category = $this.data('category');

    // have we seen this publisher before?
    if(!publisherHasCategoryMap[publisher]){
      // no, create an array for it
      publisherHasCategoryMap[publisher] = []
    }

    // push category publishers category array
    publisherHasCategoryMap[publisher].push(category);
  });

  var filterArticles = function(publisher, category){

    // disable publisher filtering for now
    publisher = "everyone"; 

    // hide all articles
    $("ul.articles").fadeOut('fast', function(){
      $("ul.articles li.no_result").hide();
      articles = Array();
      $("ul.articles li.article").hide().each(function(a, b){
        if(($(this).data('category') == category || category == "all") &&
          ($(this).data('publisher') == publisher || publisher == "everyone")){
            articles.push(this);
        }
      });
      if(articles.length == 0){
        $("ul.articles li.no_result .title .placeholder").html(category);
        $("ul.articles li.no_result .published_for .placeholder").html(publisher);
        $("ul.articles li.no_result").show();
      }
      else{
        for (var i = articles.length - 1; i >= 0; i--) {
          $(articles[i]).show();
        };
      }
      $("ul.articles").fadeIn('fast');
    });

    
  }

  $(".articles_filter .category").on("click", function(e){
    // // reset the publisher filter to All
    // currentArticlesFilter.publisher = $(".articles_filter .publisher").first().data('filter');

    $(".articles_filter .category.current").removeClass('current');
    $(this).addClass('current');

    // set publisher filter to clicked value
    currentArticlesFilter.category = $(this).data('filter');

    filterArticles(currentArticlesFilter.publisher, currentArticlesFilter.category);
  });

  $(".articles_filter .publisher").on("click", function(e){
    // // reset the category filter to All
    // currentArticlesFilter.category = $(".articles_filter .category").first().data('filter');

    $(".articles_filter .publisher.current").removeClass('current');
    $(this).addClass('current');

    // set publisher filter to clicked value
    currentArticlesFilter.publisher = $(this).data('filter');

    filterArticles(currentArticlesFilter.publisher, currentArticlesFilter.category);
  });

  // $(".articles_filter .category").first().animate({opacity: 1.0});
  // $(".articles_filter .publisher").first().animate({opacity: 1.0});
  currentArticlesFilter.category = $(".articles_filter .category").first().data('filter');
  currentArticlesFilter.publisher = $(".articles_filter .publisher").first().data('filter');
  $("ul.articles li.no_result").hide();

  $("ul.page_navigation").css({left: $("div.main").offset().left - $("ul.page_navigation").width()});

  $("a.scroll_to_top").on("click", function(e){
    $('html,body').animate({
      scrollTop: 0
    }, 100);
    return false;
  });

  $("a.show_about").on("click", function(e){
    $("div.about").slideToggle();
    // $("div.about").fadeToggle();
    return false;
  });

  $(window).on('scroll', function(e){
    var $main = $("div.main h1");

    if ($(this).scrollTop() > $main.offset().top){
      $('ul.page_navigation:hidden').stop(true, true).fadeIn();
    }
    else{
      $('ul.page_navigation').stop(true, true).fadeOut();
    }
  });

});