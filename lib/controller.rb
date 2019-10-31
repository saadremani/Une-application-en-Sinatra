require 'gossip'

class ApplicationController < Sinatra::Base

  get '/' do
    erb :index, locals: {gossips: Gossip.all}
  end

  get '/gossips/new/' do #la page pour créer un gossip
    erb :new_gossip
  end

  post '/gossips/new/' do #un return des params si un submit est fait
    Gossip.new(params["gossip_author"],params["gossip_content"]).save
    redirect '/' #retourne à la page principale
  end

  get '/gossips/:id' do #la page de chasue gossip
    erb :show, locals: {gossip: Gossip.find(params['id'])}
  end
  
  get '/gossips/:id/edit' do
		erb :edit, locals: {gossip: Gossip.all[params[:id].to_i], id: params[:id].to_i}
  end
  
  #traitement des données du formulaire de modification de gossip
	post '/gossips/:id/edit' do
		Gossip.update(params["gossip_author"], params["gossip_content"],params[:id].to_i)
		redirect '/'
  end
  
  # ajout d'un commentaire lié a un gossip
	post '/gossips/:id' do
		Comment.new(params[:id], params["gossip_comment"]).save
		#reload de la page
		erb :gossip, locals: {gossip: Gossip.all[params[:id].to_i], id: params[:id].to_i, comments:Comment.all_with_id(params[:id].to_i)}
	end

end