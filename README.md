# advent-2020
Advent of Code 2020 solutions

In my time zone, Advent of Code problems were released at 10:00 PM. That's usually about when I go
to bed, but this year I ended up solving a coding problem first on most nights. Sometimes I was
in bed by 10:30, sometimes not until after midnight. I'm telling myself now that I will not bother
with the leaderboard next year, because it's not worth the lost sleep. But there were interesting
puzzles! My favorites are:

## Day 10

Determining how many different arrangements there can be sounds hard, but the data set in the game
is constrained enough that you can actually solve it on paper. All the gaps are 1 or 3 jolts. That
means you just need to look at all the groups of three or more consecutive adapters. The first
and last adapters are necessary to cover the 3-jolt gaps on either side. You just need to count,
for each group, the number of ways you can cover the range without any gaps that are too large.

I will list these ranges as binary strings, where 1 means include the adapter and 0 means exclude it.
 * For three adapters, there are two possibilities: 111, 101
 * For four adapters, there are four: 1111, 1011, 1101, 1001
 * For five adapters, there are seven: 11111, 10111, 11011, 11101, 10011, 11001, 10101
 
I thought I was going to have to write code to figure these out, but it turns out there are no runs
longer than five in the input, so I just worked out the above runs by hand and then multiplied out each run
by 2, 4, or 7, and got the correct answer.
 
## Day 13

I was the first in my circle to solve this one, but I'll confess I ~cheated~ thought outside the box.
My program just came up with an equation that I pasted into Wolfram Alpha. And it worked!

## Day 17

I solved part 1 of this with three-dimensional ASCII art, and when it came to part 2, I just extended
the ASCII art. The tricky part was padding out the hypercube so there's enough space to contain the 
growth. When I was doing this, I realized it would probably be much better to just keep track of a 
set of active cells, but I couldn't quite think of how to spring dead cells with the right number of
living neighbors to life. A solution occurred to me later, and I was able to employ it on the 24th!

## Day 18

It'd been years since I'd written a parser, and it took me a few tries to come up with an approach
that associated left-to-right. I was tired and frustrated by the time I had solved part 1, and when
I saw part 2, where addition and multiplication have backward operator precedence, I realized it was
again time to think outside the box.

My Ruby program simply generated a C++ program that defines a class that wraps an integer and overloads
the `+` and `*` operators to do the opposite action. Then it takes the expressions in the input and
changes the numeric literals to anonymous instances of this class, while swapping `+` and `*` symbols.
So the C++ compiler did the parsing work for me. The only headache was dealing with integer overflow.
I switched the class to wrap a `long long`, which is big enough, but missed the argument to the
constructor, so everything broke anyway until I found that.

I don't do my best debugging after 11:00 PM.

When I told a friend about this hack, he asked why I didn't just generate Ruby code instead. Because even
though I've been writing Ruby professionally for the last 8 years, I had apparently forgotten that Ruby
can overload mathematical operators too. I wrote a much cleaner Ruby implementation of this hack
after I got the gold star for this one. It's in this repo as 18c.rb.

## Day 19

I struggled with this one at first, at one point trying to wrangle several mutually recursive functions,
some of which expect a total match, and others of which accept a partial match and return unused symbols.
I think this approach could have worked, but not so late at night. I attempted to pivot to making `yacc`
solve it for me, but it was too late at night for me to figure out how to use it. I went to bed frustrated.

The solution came to me as soon as my head hit the pillow: just write a single function that always matches
its entire input, but performs a substitution of a possible match at the beginning.

For part two, my code just worked even with the recursive rules. I expect this is because my code takes the
possible rule definitions (separated by `|`) in the order they appear, and since the non-recursive definitions
appear first, they'll be tried first before recursing infinitely.

## Day 20

This was my absolute favorite puzzle in the batch, and I had part 1 solved well before my friends. My key insight
was constructing a canonical edge I could use to see which tiles can connect to which other tiles. I just take
all the characters along an edge, put them in a string, and take `[edge, edge.reverse].min`, which should be 
invariant to the orientation of the provided tile. Then I see which tiles share edges, and use this to figure out
which tiles can connect to which other tiles. I figured this was going to be just the starting point of a heuristic,
but it turned out that no more than two tiles ever shared an edge! This made it possible to build a graph showing
which nodes were connected to which others.

I got the answer to Part 1 very quickly: the four edges that have only two neighbors are corners.

For part 2, I started with a corner piece, then chose connecting edge pieces (with three neighbors) until I reached
the other corner. Then I repeated this on the left edge, and finally filled in the middle by picking pieces that
connected to the neighbors to the left and above. So I knew the position of all 144 tiles of my input before I even
implemented any rotation or flipping. I then rotated/flipped the tiles into place one by one.

## Day 23

Part 1 was solved with brute force. Part 2 looked like it _might_ complete in about 20 hours. So I rewrote it in C++
using a circular linked list, and hoping it'd be fast enough (but fearing the solution would require fancy math).
It was not fast enough. The problem was finding the destination node by traversing a circular linked list with
a million items is too slow.

But it occurred to me that my nodes aren't moving around in memory. I'm just swapping prev/next pointers on each to
define the order. I could make a map that lets me find the number I'm looking for efficiently. In fact, that map
only needs 9 entries because I can shove _all_ the nodes into a single array and find the sequential ones by index.
See 23b.cpp.

This solved the problem in about 0.8 s.  A friend discovered that you can solve this with a single array of integers:
the entry at index i gives the index of the next entry in the circle. I rewrote my solution to use this approach
and that cut the execution time to about 0.2 s. (This is 23c.cpp.)

## Day 24

https://www.redblobgames.com/grids/hexagons/ is an invaluable resource for reasoning about hexagonal grid systems.

And I got to implement the Life solution I thought of after the 17th! My data structure is simply a set of coordinates
containing black hexes. How do I turn white hexes with the right number of neighbors black? When I iterate over the
black hexes, I check each set of neighboring coordinates to see whether a cell exists there. If not, I create or
increment a counter associated with those coordinates. When I'm through iterating over the black cells, I have
a list of all white cells that could possibly be flipped over, along with the number of adjacent black cells for each!
I wish I'd thought of this when I wrote 4D life, because it's _much_ simpler than what I went with, and it'd be a heck of
a lot more efficient too, since it's not counting zeroes in vast uninhabited hyperspaces.

