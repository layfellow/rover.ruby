# A solution to the Mars Rover programming problem

Implemented in Ruby 2.

Table of contents

1. [The problem](#the-problem)
2. [The solution](#the-solution)

## The problem

A squad of robotic rovers are to be landed by NASA on a plateau on Mars. This plateau, which is curiously rectangular, must be navigated by the rovers so that their on-board cameras can get a complete view of the surrounding terrain to send back to Earth.

A rover’s position and location is represented by a combination of `x` and `y` coordinates and a letter representing one of the four cardinal compass points. The plateau is divided up into a grid to simplify navigation. An example position might be `0, 0, N`, which means the rover is in the bottom left corner and facing North.

In order to control a rover, NASA sends a simple string of letters. The possible letters are ‘L’, ‘R’ and ‘M’. ‘L’ and ‘R’ makes the rover spin 90 degrees left or right respectively, without moving from its current spot. 
‘M’ means move forward one grid point, and maintain the same heading.

Assume that the square directly North from `(x, y)` is `(x, y + 1)`.

### Input

The first line of input is the upper-right coordinates of the plateau, the lower-left coordinates are assumed to be `0,0`.

The rest of the input is information pertaining to the rovers that have been deployed. Each rover has two lines of input. The first line gives the rover’s position, and the second line is a series of instructions telling the rover how to explore the plateau.

The position is made up of two integers and a letter separated by spaces, corresponding to the `x` and `y` coordinates and the rover’s orientation.

Each rover will be finished sequentially, which means that the second rover won’t start to move until the first one has finished moving.

### Output

The output for each rover should be its final coordinates and heading.

### Input and Output

Test Input:

```
5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM
```

Expected Output:

```
1 3 N
5 1 E
```

## The solution

This solution requires Ruby 2.7 or higher; no dependencies other than the standard library and bundled gems. To install Ruby:

- On Ubuntu run: `sudo apt install ruby-full`
- On Fedora run: `sudo dnf install ruby`
- On macOS install [Homebrew](https://brew.sh/) then run: `brew install ruby`
- On Windows 10 install [Chocolatey](https://chocolatey.org/) then run: `choco install ruby`

To execute the solution, run:

    ruby rover.rb INPUT

To execute unit tests, run:

    ruby test.rb

### Design and assumptions

I created a `MarsRover` class which is an abstraction of the rover. The constructor initializes an instance with three basic properties `x`, `y` and `heading`, containing the initial coordinates and the heading. The constructor also takes `rightmost` and `uppermost` properties, which tell the upper-right coordinates of the Martian plateau. For example, a pair `3,6` for these properties would indicate a rectangular plateau of 4x7 in size. The reason I'm providing the grid size is to make the rover ‘aware’ of the borders — it will ignore movement instructions to go beyond a border.

A rover instance has methods `left` and `right` to spin the rover in place, as well as a `move` method to move forward one grid point. Notice `move` has an optional `others` parameter: this is an *array of `MarsRover` objects*, containing references to *all the other rovers roaming on the plateau*. This data is necessary to implement (optional) collision detection — i.e., a rover won’t move to a position occupied by another rover.

I designed `MarsRover` around the assumption the rover will try to preserve its own integrity, and therefore will try to avoid falling off a cliff (go beyond a border) or crash head-on onto another rover (move to an already occupied position). The methods that implement these checks are `inside?` and `crash?` respectively.

I also assumed all rovers have successfully landed on the plateau, and therefore no rover crash-landed onto another one. This is why the `MarsRover` constructor doesn’t check whether the initial coordinates are already occupied by another rover.

The `houston` method is an abstraction to communicate error conditions uplink to Earth.

The input text parser was implemented in the main section. It has some defensive features to account for common errors. The grid and coordinate initialization text lines require integers and  valid case-insensitive heading directives, otherwise an error is signaled to Houston and processing stops (i.e., a fatal error). The movement lines simply ignore any non-valid directive and continue without signaling errors.

Invalid initialization directives are signaled as fatal errors because I assumed these are known values, predefined by Mission Control. They’re critical for a correct operation, without which the rover cannot safely operate. Movement directives, however, are probably sent as a continuously changing string downlink from Earth, and some basic error correction capabilities are desirable.

Unit tests are implemented in `test.rb`. These cover all common operations, as well as a couple of boundary conditions.
