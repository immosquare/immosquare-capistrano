# Immosquare Capistrano

This gem provides a collection of Capistrano tasks for
 - puma

 - sidekiq

 - solid Queue

 - github Package

 - rvm



## Installation

```ruby
gem "immosquare-capistrano"
```

## Capfile

Add the modules that interest you.

For example, to include all modules, you can add:

```ruby
require "immosquare/capistrano/rvm"
require "immosquare/capistrano/github"
require "immosquare/capistrano/puma"
require "immosquare/capistrano/sidekiq"
require "immosquare/capistrano/solid_queue"
```

## RVM

To use RVM, configure Bundler in your `deploy.rb` file:

```ruby
set :rvm_ruby_version, "ruby-3.3.6@my-gemset"
```


## Github Package

To use private packages from GitHub, configure Bundler in your `deploy.rb` file:

```ruby
# deploy.rb
set :github_package_username,              "xxx"
set :github_package_personal_access_token, "yyy"
```

This will allow Bundler to authenticate and install private gems from GitHub Packages.


## Puma Integration

### Configuration

Configure your `deploy.rb` file to specify Puma settings tailored to your deployment:

```ruby
# deploy.rb
set :puma_user, "deploy"
set :puma_phased_restart, true
```

### Service Installation

Install the Puma service unit to `/etc/systemd/system` with the following Capistrano command:

```bash
cap production puma:install
```

### Deployment Automation

Incorporate Puma management into your deployment flow by requiring the Puma integration in your Capfile:

```ruby
# Capfile
require "immosquare/capistrano/puma"
```

This will automatically hook into Capistrano's deployment process with:

```ruby
after "deploy:finished", "puma:smart_restart"
```

### Capistrano Tasks

Manage your Puma application server with ease using the provided tasks:

- `cap puma:install` - Installs the Puma service unit, setting it up to run under systemd.

- `cap puma:uninstall` - Removes the Puma service unit from systemd, cleaning up related files.

- `cap puma:start` - Initiates the Puma service, starting your application.

- `cap puma:stop` - Halts the Puma service, stopping your application.

- `cap puma:restart` - Performs a full restart of the Puma service.

- `cap puma:reload` - Gracefully reloads the Puma service, ideal for zero-downtime deployments.

- `cap puma:smart_restart` - Chooses between a phased restart or a full restart based on the `puma_phased_restart` flag.

Utilize these tasks to ensure your Puma server is properly managed during each deploy, leveraging Capistrano's automation capabilities.


## Sidekiq Integration

### Configuration

Set up your `deploy.rb` file with the necessary Sidekiq configurations:

```ruby
# deploy.rb
set :sidekiq_user, "deploy"
```

### Service Installation

To install the Sidekiq service file into `/etc/systemd/system`, use the following command:

```bash
cap production sidekiq:install
```

### Deployment Automation

Add the Sidekiq tasks to the deploy process in your Capfile:

```ruby
# Capfile
require "immosquare/capistrano/sidekiq"
```

Sidekiq will be managed automatically during deployments with these hooks:

```ruby
# Capfile
# Sidekiq hooks
after "deploy:starting",  "sidekiq:stop"
after "deploy:published", "sidekiq:start"
after "deploy:failed",    "sidekiq:restart"
```

#### Available Tasks

- `cap sidekiq:install` - Installs the Sidekiq service unit.

- `cap sidekiq:uninstall` - Uninstalls the Sidekiq service unit.

- `cap sidekiq:start` - Starts the Sidekiq service.

- `cap sidekiq:stop` - Stops the Sidekiq service.

- `cap sidekiq:restart` - Restarts the Sidekiq service.

Simply run `sidekiq:install` or `sidekiq:uninstall` as needed; the rest of the Sidekiq-related tasks are called via deploy hooks.

## SolidQueue Integration

### Configuration

Just like with Sidekiq, configure your `deploy.rb` for SolidQueue settings:

```ruby
# deploy.rb
set :solid_queue_user, "deploy"
```

### Service Installation

Install the SolidQueue service file into `/etc/systemd/system` with the command:

```bash
cap production solid_queue:install
```

### Deployment Hooks

In your Capfile, add SolidQueue to the deployment process:

```ruby
# Capfile
require "immosquare/capistrano/solid_queue"
```

SolidQueue service will be handled automatically with these hooks:

```ruby
# Capfile
# SolidQueue hooks
after "deploy:starting",  "solid_queue:stop"
after "deploy:published", "solid_queue:start"
after "deploy:failed",    "solid_queue:restart"
```

#### Available Tasks

- `cap solid_queue:install` - Installs the SolidQueue service unit.

- `cap solid_queue:uninstall` - Uninstalls the SolidQueue service unit.

- `cap solid_queue:start` - Starts the SolidQueue service.

- `cap solid_queue:stop` - Stops the SolidQueue service.

- `cap solid_queue:restart` - Restarts the SolidQueue service.

Use `solid_queue:install` or `solid_queue:uninstall` for manual control. All other tasks are integrated into the deployment lifecycle via hooks.


## Contributing

Contributions are always welcome! Please feel free to submit pull requests or create issues on the project's [GitHub page](https://github.com/your-github-username/immosquare-capistrano).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
