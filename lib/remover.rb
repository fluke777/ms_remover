require "remover/version"
require 'pry'
require 'fileutils'
require 'pathname'
require 'pp'
require 'digest/md5'

module GDC
  
  class Remover
    
    attr_accessor :pattern
    
    def self.remove(options={})
      a = GDC::Remover.new(options)
      a.execute
    end

    def initialize(options={})
      @pattern      = options[:pattern] || "**/*"
      
      @index_dir   = Pathname.new(options[:index_dir] || ".").expand_path
      
      fail "You have to define target directory" if options[:target_dir].nil?
      @target_dir   = Pathname.new(options[:target_dir]).expand_path
    end

    def execute
      FileUtils::cd(@index_dir) do
        files = Dir.glob(@pattern)  
        files.each do |file|
          File.delete(@target_dir + file) if (File.exist?(@target_dir + file) && (!Pathname.new(file).directory?) && (Digest::MD5.file(Pathname.new(file).expand_path) == Digest::MD5.file(@target_dir + file)))
        end  
      end
    end
  
  end
end

