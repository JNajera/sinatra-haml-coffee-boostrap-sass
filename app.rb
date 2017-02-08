require 'sinatra'
require 'hamlit'
require 'sinatra/asset_pipeline'
require 'sass'
require 'bootstrap-sass'

# require 'bundler'
# Bundler.require

class App < Sinatra::Base
  set :haml, {format: :html5, escape_html: false}

  set :sass, { :load_paths => [ "#{App.root}/assets/stylesheets" ] }
  set :scss, { :load_paths => [ "#{App.root}/assets/stylesheets" ] }

  set :sprockets, Sprockets::Environment.new(root)
  set :assets_public_path, -> { File.join(public_folder, "assets") }
  set :assets_prefix, '/assets'
  set :digest_assets, false

  configure do
    # Setup Sprockets
    sprockets.append_path File.join(root, 'assets', 'stylesheets')
    sprockets.append_path File.join(root, 'assets', 'javascripts')
    sprockets.append_path File.join(root, 'assets', 'images')

    # Configure Sprockets::Helpers (if necessary)
    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix      = assets_prefix
      config.digest      = digest_assets
      config.public_path = public_folder

      # Force to debug mode in development mode
      # Debug mode automatically sets
      # expand = true, digest = false, manifest = false
      config.debug       = true if development?
    end
  end

  register Sinatra::AssetPipeline

  get "/" do
    haml :index
  end
end
