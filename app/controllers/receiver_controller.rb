class ReceiverController < ApplicationController

    # This ReceiverController#create endpoint accepts the webhook payload from GitHub
    def create
        # Since we'll be making outbound requests to the GitHub API, we want to perform this asyncrhonously with Sidekiq 
        # RepoWorker.perform_async(push_params)

        notified_repos = []

        if !notified_repos.include?(push_params["repository"]["full_name"])
            RepoWorker.perform_async(push_params)
            notified_repos.push(push_params["repository"]["full_name"])
        end

    end
    
    private 
    
    # Only grab the necessary payload keys for this service
    #def push_params
    #    params.permit(organization: [:login], repository: [:name], sender: [:login]).to_h # Convert to a Hash for ease-of-use
    #end

    def push_params
        params.permit(repository: [:full_name], pusher: [:name]).to_h # Convert to a Hash for ease-of-use
    end

end
