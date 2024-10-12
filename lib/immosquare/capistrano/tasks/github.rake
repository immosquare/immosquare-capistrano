namespace :github do
  desc "Configure Bundler with GitHub Packages credentials"
  task :setup do
    on roles(:app) do
      ##============================================================##
      ## Fetch the GitHub Package username and PAT
      ##============================================================##
      github_package_username               = fetch(:github_package_username)
      github_package_personal_access_token  = fetch(:github_package_personal_access_token)

      ##============================================================##
      ## Check if the GitHub username is set
      ##============================================================##
      if github_package_username.nil?
        error "GitHub Package username is not set. Please set the :github_package_username"
        exit 1
      end

      ##============================================================##
      ## Check if the Personal Access Token is set
      ##============================================================##
      if github_package_personal_access_token.nil?
        error "GitHub Personal Access Token (PAT) is not set. Please set the :github_package_personal_access_token"
        exit 1
      end

      ##============================================================##
      ## Provide some feedback before setting the credentials
      ##============================================================##
      info "Setting Bundler credentials for GitHub Packages..."

      ##============================================================##
      ## Set the GitHub Package credentials with Bundler
      ##============================================================##
      execute :bundle, "config set --global rubygems.pkg.github.com #{github_package_username}:#{github_package_personal_access_token}"

      ##============================================================##
      ## Confirm that the credentials were set successfully
      ##============================================================##
      info "GitHub Packages credentials successfully set for Bundler."
    end
  end
end
