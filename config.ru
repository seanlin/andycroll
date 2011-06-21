require 'bundler'
Bundler.setup

# require 'rack/rewrite'
# use Rack::Rewrite do
#   # r301 '/code_buddy', '/2010/12/13/codebuddy-see-your-ruby-stack-come-alive'
# end

require 'rdiscount'
require 'toto'
require 'haml'

# Rack config
use Rack::Static, :urls => ['/stylesheets', '/javascripts', '/images', '/favicon.ico', '/humans.txt', '/apple-touch-icon.png'], :root => 'public'
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

#
# Create and configure a toto instance
#
toto = Toto::Server.new do
  set :author,    "Andy Croll"                                # blog author
  set :title,     "Andy Croll"                                # site title
  set :url,       "http://blog.andycroll.com"
  set :root,      "index"                                     # page to load on /
  # set :date,      lambda {|now| now.strftime("%d/%m/%Y") }  # date format for articles
  set :markdown,  :smart                                    # use markdown + smart-mode
  # set :disqus,    false                                     # disqus id, or false
  # set :summary,   :max => 150, :delim => /~/                # length of article summary and delimiter
  set :ext,       'txt'                                     # file extension for articles
  set :cache,      28800                                    # cache duration, in seconds

  set :date, lambda { |now| now.strftime("%B #{now.day.ordinal} %Y") }
  set :to_html, lambda { |path, page, ctx|
    ::Haml::Engine.new(File.read("#{path}/#{page}.haml"), :format => :html5, :ugly => true).render(ctx)
  }
  set :error do |code|
    ::Haml::Engine.new(File.read("templates/pages/#{code}.haml"), :format => :html5, :ugly => true).render(@context)
  end
end

run toto


