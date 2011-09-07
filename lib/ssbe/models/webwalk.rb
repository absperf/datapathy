base = File.join(File.dirname(__FILE__), 'webwalk')

Dir[File.join(base, '/*.rb')].map do |file|
  File.basename(file, '.rb')
end.each do |name|
  autoload name.camelize.intern, File.join(base, name)
end.each do |name|
  require File.join(base, name)
end
