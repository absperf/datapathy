
base = File.join(File.dirname(__FILE__), 'core')

Dir[File.join(base, "/*.rb")].map do |f|
  File.basename(f, '.rb')
end.each do |name|
  autoload name.camelize.intern, File.join(base, name)
end.each do |name|  # Gotta do these in separate steps
  require File.join(base, name)
end

