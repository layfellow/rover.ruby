class MarsRover

	# Map <current heading>:<new heading> for left and right spins
	@@spin_left =  { 'N' => 'W', 'E' => 'N', 'S' => 'E', 'W' => 'S' }
	@@spin_right = { 'N' => 'E', 'E' => 'S', 'S' => 'W', 'W' => 'N' }

	# Map <heading>:<coordinate offset> along x-axis and y-axis for a move
	@@delta_x = { 'N' =>  0, 'E' => +1, 'S' =>  0, 'W' => -1 }
	@@delta_y = { 'N' => +1, 'E' =>  0, 'S' => -1, 'W' =>  0 }

	attr_reader :x, :y, :heading
	
	def initialize(x = 0, y = 0, heading = 'N', rightmost = 0, uppermost = 0)
		@x, @y  = x, y
		@heading = heading
		# Upper-right grid corner
		@rightmost, @uppermost = rightmost, uppermost
	end

	## Spin left, 90 degrees counter-clockwise.
	def left
		@heading = @@spin_left[@heading]
		return self
	end

	## Spin right, 90 degrees clockwise.
	def right
		@heading = @@spin_right[@heading]
		return self
	end

	## true if (x, y) is inside the valid rectangle.
	def inside?(x, y)
		x >= 0 and x <= @rightmost and y >=0 and y <= @uppermost
	end

	## true if (x, y) is already occupied by another rover.
	def crash?(rover, x, y)
		x == rover.x and y == rover.y
	end

	## Move forward, check possible collision with others (array of other rovers).
	def move(others = nil)
		x = @x + @@delta_x[@heading]
		y = @y + @@delta_y[@heading]

		if not inside?(x, y)
			houston("ignoring move, I would fall off a cliff!")
		elsif others and others.map { |rover| crash?(rover, x, y) }.reduce(false) { |me, other| me or other }
			houston("ignoring move, another rover is blocking the way")
		else
			@x, @y = x, y
		end
		return self
	end
end


def houston(error)
	STDERR.puts("rover says \"#{error}\"")
end

def land(line, rightmost, uppermost)
	x, y, heading = line.split
	x, y = Integer(x), Integer(y)
	if x > rightmost or y > uppermost or not 'NESW'.include?(heading)
		raise "Invalid landing coordinates or heading"
	end
	return x, y, heading
end


if __FILE__ == $0

	if ARGV.size > 0 and File.file?(ARGV[0])
		File.open(ARGV[0]) do |input|
			begin
				if line = input.gets  # Upper-right grid corner: X Y
					rightmost, uppermost = line.split.map { |v| Integer(v) }
				end
				others = []
				while line = input.gets  # Rover landing point: X Y HEADING
					line.upcase!
					rover = MarsRover.new(*land(line, rightmost, uppermost), rightmost, uppermost)
					if line = input.gets  # Move directives: LRM...
						line.upcase!
						line.each_char do |c|
							if c == 'M'
								rover.move(others)
							elsif c == 'L'
								rover.left
							elsif c == 'R'
								rover.right
							end
						end
						print(rover.x, " ", rover.y, " ", rover.heading, "\n")
						others.append(rover)
					end
				end
			rescue => e
				houston("Error on input line: #{line.chomp}, #{e.message}")
			end
		end
	end
end
