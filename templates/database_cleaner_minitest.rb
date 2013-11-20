class Minitest::Unit::TestCase
  def self.prepare
    DatabaseCleaner.clean_with(:deletion)
  end
  prepare

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
