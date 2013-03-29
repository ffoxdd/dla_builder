require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/unit/*.rb', 'test/integration/*.rb']
  t.verbose = true
end

Rake::TestTask.new("test:unit") do |t|
  t.libs << "test/unit"
  t.test_files = FileList['test/unit/*.rb']
  t.verbose = true
end

Rake::TestTask.new("test:integration") do |t|
  t.libs << "test/integration"
  t.test_files = FileList['test/integration/*.rb']
  t.verbose = true
end
