require 'minitest/autorun'
require_relative 'rover'

class TestMarsRover < MiniTest::Unit::TestCase

	def assert_coordinates(rover, x, y, heading)
		assert_equal(rover.x, x)
		assert_equal(rover.y, y)
		assert_equal(rover.heading, heading)
	end

	def test_full_rotation
		spirit = MarsRover.new(2, 3, 'S', 5, 5)
		spirit.right.right.right.right.left.left.left.left
		assert_coordinates(spirit, 2, 3, 'S')
	end

	def test_trips
		curiosity = MarsRover.new(1, 2, 'N', 5, 5)
		perseverance = MarsRover.new(3, 3, 'E', 5, 5)

		curiosity.left.move.left.move.left.move.left.move.move
		assert_coordinates(curiosity, 1, 3, 'N')

		perseverance.move([curiosity]).move([curiosity]).right
		perseverance.move([curiosity]).move([curiosity]).right
		perseverance.move([curiosity]).right.right.move([curiosity])
		assert_coordinates(perseverance, 5, 1, 'E')
	end

	def test_do_not_fall_off_cliff
		zhurong = MarsRover.new(2, 2, 'W', 5, 5)
		zhurong.move.move.move
		self.assert_coordinates(zhurong, 0, 2, 'W')
	end

	def test_do_not_crash
		perseverance = MarsRover.new(5, 3, 'S', 5, 5)
		zhurong = MarsRover.new(5, 1, 'N', 5, 5)

		perseverance.move([zhurong]).move([zhurong])
		assert_coordinates(perseverance, 5, 2, 'S')
	end
end
	
