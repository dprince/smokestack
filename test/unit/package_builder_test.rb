require 'test_helper'

class PackageBuilderTest < ActiveSupport::TestCase

  fixtures :smoke_tests

  test "create" do
    builder = PackageBuilder.create(
        :url => "lp:nova",
        :merge_trunk => true,
		:smoke_test => smoke_tests(:trunk)
    )
    assert_equal "lp:nova", builder.url
    assert_equal false, builder.merge_trunk
  end

  test "create fails without url" do
    smoke_test = PackageBuilder.create(
        :merge_trunk => true,
		:smoke_test => smoke_tests(:trunk)
    )
    assert_equal false, smoke_test.valid?
  end

end
