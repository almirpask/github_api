require 'spec_helper'
require 'commits'

REPOSITORY = 'Dinda-com-br'.freeze
PROJECT = 'braspag-rest'.freeze

describe Commits do 
    commits = Commits.new(REPOSITORY, PROJECT)
    context 'use the Github API to' do 
        it 'get a array of commits from API' do
            expect(commits.commits).to be_a Array
            expect(commits.commits.first).to be_a Hash
        end

        it 'try to map commits' do
            expect(commits.map_commits.first).to include(:name)
            expect(commits.map_commits.first).to include(:email)
            expect(commits.map_commits.first).to include(:login)
            expect(commits.map_commits.first).to include(:avatar_url)
        end

        it 'try to count commits' do
            expect(commits.count_commits).to be_a Hash
        end

        it 'try to order commits' do
            expect(commits.order_commits).to be_a Array
            expect(commits.commits.first).to be_a Hash
        end

        it 'should write a file' do
            file = File.open(commits.write_commits)
            expect(File.exists?(file)).to be true
        end
    end
end