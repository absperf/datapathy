module RSpec::HaveErrorsMatcher

  RSpec::Matchers.define :have_errors_on do |attribute|
    match do |resource|
      !resource.errors[attribute].empty?
    end
  end

  RSpec::Matchers.define :have_errors do
    match do |resource|
      !resource.valid?
    end
  end

  RSpec.configure { |c| c.include self }
end

