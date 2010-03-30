require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/fap'

Hoe.plugin :newgem
$hoe = Hoe.spec 'fap' do
  self.developer 'Arnaud Berthomier', 'oz@cyprio.net'
  self.rubyforge_name       = self.name # TODO this is default value
  # self.extra_deps         = [['activesupport','>= 2.0.2']]

end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }
