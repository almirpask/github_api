require './lib/commits.rb'

REPOSITORY = 'Dinda-com-br'.freeze
PROJECT = 'braspag-rest'.freeze

repository = Commits.new(REPOSITORY, PROJECT)
repository.handle_commit