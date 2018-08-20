require 'net/http'
require 'json'
require 'csv'

BASE_URL = 'https://api.github.com/repos'.freeze

class Commits
    attr_reader :commits
    
    def initialize(repository, project)
        @project = project
        @commits =  JSON.parse(
            Net::HTTP.get(URI.parse("#{BASE_URL}/#{repository}/#{project}/commits"))
        )
        @formated_commits = {}
    end
    
    def handle_commit
        map_commits
        count_commits
        order_commits
        write_commits
    end

    def map_commits
        @formatted_commits = @commits.map do |commit|
            { 
                name: commit.dig("commit", "author", "name"), 
                email: commit.dig("commit", "author", "email"),
                login: commit.dig("author", "login"),
                avatar_url: commit.dig("author", "avatar_url")
            }
        end
    end

    def count_commits
        @formatted_commits = @formatted_commits.each_with_object(Hash.new(0)) do |commiter, counter|
            counter[commiter] += 1
        end
    end

    def order_commits
        @formatted_commits = @formatted_commits.sort_by {|k, v| v}.map do |commiter, commiter_score|
            {
                commiter: commiter,
                score: commiter_score
            }
        end.reverse
    end

    def write_commits
        file_name = "#{@project}_#{Time.now.strftime("%Y_%m_%d_%H%M%S")}"
        file = File.new("./#{file_name}.txt", 'w')
        CSV.open("./#{file_name}.csv", 'wb') do |csv|
            csv << [
                'name',
                'email',
                'login',
                ':avatar_url',
                'score'
            ]
            @formatted_commits.each do |commit|
                file.puts commits_to_text(commit)
                csv << [
                    commit[:commiter][:name],
                    commit[:commiter][:email],
                    commit[:commiter][:login],
                    commit[:commiter][:avatar_url],
                    commit[:score]
                ]
            end
        end
        file.close
        file
    end

    private

    def commits_to_text(commit)
        "#{commit[:commiter][:name]};#{commit[:commiter][:email]};#{commit[:commiter][:login]};#{commit[:commiter][:avatar_url]};#{commit[:score]}"
    end
end