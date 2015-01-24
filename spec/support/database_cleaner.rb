require 'database_cleaner'

RSpec.configure do |c|
  c.before :suite do
    DatabaseCleaner.clean_with(:truncation)
  end

  c.before :each do
    DatabaseCleaner.strategy = :transaction
  end

  c.before :each, js:true do
    DatabaseCleaner.strategy = :truncation
  end

  c.before :each do
    DatabaseCleaner.start
  end

  c.after :each do
    DatabaseCleaner.clean
  end

end
