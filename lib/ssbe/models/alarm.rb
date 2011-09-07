base = File.join(File.dirname(__FILE__), 'alarm')

Dir[File.join(base, "/*.rb")].map do |f|
  File.basename(f, '.rb')
end.each do |name|
  autoload name.camelize.intern, File.join(base, name)
end.each do |name|
  require File.join(base, name)
end
