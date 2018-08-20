require './lib/commits.rb'

REPOSITORY = 'repository'.freeze
PROJECT = 'project'.freeze

repository = Commits.new(REPOSITORY, PROJECT)
repository.handle_commit