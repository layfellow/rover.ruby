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

This solution uses Ruby 2.7 or higher. No additional libraries required.

To install Ruby:

- On Ubuntu Linux run: `sudo apt install ruby-full`
- On Fedora Linux run: `sudo dnf install ruby`
- On macOS install [Homebrew](https://brew.sh/), then run: `brew install ruby`
- On Windows 10 install [Chocolatey](https://chocolatey.org/), then run: `choco install ruby`

To execute the solution, run:

    ruby rover.rb INPUT

To execute unit tests, run:

    ruby test.rb

### Design and assumptions

I created a `MarsRover` class which is an abstraction of the rover. The constructor initializes an instance with three basic properties `x`, `y` and `heading`. These contain the initial coordinates and the initial heading. The constructor also takes `rightmost` and `uppermost` parameters, which tell the upper-right coordinates of the Martian plateau. For example, a pair `3,6` for these properties would tell the plateau is 4x7 in size. The grid size data allows the rover to be ‘aware’ of the borders.

A rover instance has `left` and `right` methods to spin the rover in place. The `move` method moves the rover forward one grid point. `move` has an optional `others` parameter: this is an array of `MarsRover` objects, referencing all the other rovers roaming on the plateau. This is necessary to implement (optional) collision detection — i.e., a rover won’t move to a position occupied by another rover.

I assumed a `MarsRover` will try to preserve its integrity, i.e., it should avoid falling off a cliff or crash head-on onto another rover. The methods that implement these checks are `inside?` and `crash?` respectively.

I also assumed all rovers have landed on the plateau, and thus no rover crash-landed onto another one. This is why the `MarsRover` constructor doesn’t check if the initial coordinates are already occupied by another rover.

The `houston` method is an abstraction to communicate error conditions uplink to Earth.

The input text parser was implemented in the main section. It has some defensive features to account for common errors. The grid and coordinate text lines require integers and valid, case-insensitive heading directives. Otherwise an error is signaled to Houston and processing stops (i.e., a fatal error). The move directive lines simply ignore any invalid input, without signaling errors.

Invalid initialization directives signal fatal errors because I assumed these are critical values.  Move directives, on the other hand, are probably sent as a continuous string downlink from Earth and some basic error correction capabilities are desirable.

Unit tests are implemented in `test.rb`. These cover all common operations, as well as a couple of boundary conditions.
