### 
# Compass
###

require 'grid-coordinates'
require 'date'
require 'time'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
# 
# With no layout
# page "/path/to/file.html", :layout => false
# 
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
# 
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# projects use their own layout (wrapped inside the normal layout)
with_layout :article do
  page "/articles/*"
end
# projects index should use raw layout.
page "/articles/index.html", :layout => :layout

# proxy about page
page "/about.html", proxy: "/meta/about.html"

###
# Helpers
###

# Automatic image dimensions on image_tag helper
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# TURN THIS ON? Test it out.
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
helpers do
  
  def parameterize(str)
    str.downcase.gsub(/[^a-z0-9\-]/,'-')
  end

  def all_articles
    articles = sitemap.resources.select do |r|
      # ignore index page, ignore filters (articles/for/*publisher)
      r.path.match(/^articles\/.+?\.html/) && r.path != "articles/index.html" &&
      !r.path.match(/^articles\/for\/.+?\.html/)
    end
    articles
  end

  def article_categories
    all_articles.map do |a|
      a.metadata[:page]["category"]
    end.uniq
  end

  def article_publishers
    all_articles.map do |a|
      a.metadata[:page]["published"]["for"]
    end.uniq
  end

end

# dont try to generate our page helpers as actual pages
ignore "/page_helpers/*"

ready do

  # #
  # # Generate /articles/for/*publisher*.html
  # #

  # # grab all articles that are published for someone
  # # and group those up
  # publish_groups = sitemap.resources.group_by do |r|
  #   if r.metadata[:page] && r.metadata[:page]["published"] && r.metadata[:page]["published"]["for"]
  #     # has page metadata and has published meta data
  #     r.metadata[:page]["published"]["for"]
  #   end
  # end

  # # create pages for each publisher
  # publish_groups.each do |published_for, articles|
    
  #   if published_for.nil?
  #     # skip blanks
  #     next
  #   end

  #   # sanitize names
  #   safe_for = parameterize(published_for)
  #   page "/articles/for/#{safe_for}.html", :proxy => "/page_helpers/articles_for.html" do
  #     # create page
  #     @published_for = published_for
  #     @articles = articles
  #   end

  #   # we want to be able to know the full name of a publisher inside other templates
  #   # so associate we define our custom metadata generator
  #   # and save some bits.
  #   sitemap.provides_metadata_for_path("/articles/for/#{safe_for}.html", :publisher_meta) do |url|
  #     {
  #       page: {
  #         "title" => "Articles written for #{published_for}",
  #         "published" => {
  #           "for" => published_for,
  #           "count" => articles.count
  #         }
  #       }
  #     }
  #   end

  # end

  #
  # Generate /articles/index.html
  #

  page "/articles/index.html", :proxy => "/page_helpers/articles.html" do

    # grab all resources in the /articles/* path
    @articles = sitemap.resources.select do |r|
      # ignore index page, ignore filters (articles/for/*publisher)
      r.path.match(/^articles\/.+?\.html/) && r.path != "articles/index.html" &&
      !r.path.match(/^articles\/for\/.+?\.html/)
    end

    @articles = @articles.sort_by{|a|Date.parse(a.data.published.date)}.reverse
    
    @publisher_filters = sitemap.resources.select do |r|
      # ignore index page, ignore filters (articles/for/*publisher)
      r.path.match(/^articles\/for\/.+?\.html/)
    end
  end

end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'


#
# Markdown config
#

class OMHTML < Redcarpet::Render::HTML
  def image(link, title, alt_text)

    if alt_text
      container_classes = $1 if alt_text.match(/#(left|right)$/)
      alt_text.gsub!(/(#left$|#right$)/, "")
    end

    # if alt_text.nil? || alt_text.empty?

    # end    

    "<span class='image-container #{container_classes}'>" +
    "<img src='#{link}' alt='#{alt_text}'/>" +
    "<span class='caption'>#{alt_text.nil? || alt_text.empty? ? "&nbsp;" : alt_text}</span>" +
    "</span>"

  end

  # def postprocess(doc)
  #   # find anything that has <p>[!lorem]</p>
  #   # replace it with <p class="fixie"></p>
  #   doc.gsub!("<p>[!lorem]</p>", "<p class='fixie'></p>")        
  #   doc
  # end
end

set :markdown, strikethrough: true, fenced_code_blocks: true, renderer: OMHTML
set :markdown_engine, :redcarpet


# Build-specific configuration
configure :build do
  
  activate :directory_indexes

  # For example, change the Compass output style for deployment
  # activate :minify_css
  
  # Minify Javascript on build
  # activate :minify_javascript
  
  # Enable cache buster
  # activate :cache_buster
  
  # Use relative URLs
  # activate :relative_assets
  
  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher
  
  # Or use a different image path
  # set :http_path, "/Content/images/"
end