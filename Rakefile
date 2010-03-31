require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/fap'

Hoe.plugin :newgem
$hoe = Hoe.spec 'fap' do
  self.developer 'Arnaud Berthomier', 'oz@cyprio.net'
  self.rubyforge_name       = self.name
  self.extra_deps         = [['nokogiri','>= 1.4.1']]
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }
