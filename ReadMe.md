TestML
======

An Acmeist Software Testing Language

# Status

TestML ideas started back in 2005. The Perl module Test::Base, used the same
data definition syntax that is still used today.

In 2009, an imperative assertion syntax was added, that could be run in any
programming language. It was called TestML and ported to a few languages.

In 2017, the assertion syntax was reinvented, and a TestML compiler was added.
This made the runtime be much cleaner and easier to port to any language. The
full stack was implemented at OpenResty Inc for internal use only.

Now, in 2018, this work is being rewitten as open source, with the goal of
quickly adding support for all popular programming languges.

One example of a fairly big TestML suite is
https://github.com/yaml/yaml-test-suite

To see a lot of TestML CLI invocations being run, try this command:
```
test/test-cli.sh
```

## The TestML Compiler

To use TestML you will need to install the TestML Compiler, which is currently
written in NodeJS. You can install it like this:
```
npm install -g testml-compiler
```

## Current Implementation Level

To implement TestML, 2 things need to happen:

* Implement all the language features into the TestML Compiler
* Implement the Runtime in each programming language / test framework

To date, the basic data language and the minimal assertion syntax can compile.
Runtime support is as follows:

* Perl(5) - Complete. Runs all features presented by the compiler.
* Perl 6 - Complete.
* CoffeeScript (JavaScript) - Started. In progress.

# Synopsis

An example TestML file, `math.tml`:
```
#!/usr/bin/env testml

*a.add(*a) == *c
*c.sub(*a) == *a
*a.mul(2) == *c
*c.div(2) == *a
*a.mul(*b) == *d

=== Test block 1
--- a: 3
--- c: 6

=== Test block 2
--- a: -5
--- b: 7
--- c: -10
--- d: -35
```

could be run to test a math software library written in any language. This
particular test makes 9 assertions.

To run the test, let's say in Perl 6, use any of these:
```
testml -l perl6 math.tml
testml-perl6 math.tml
TESTML_LANG=perl6 prove -v math.tml
```

The output would look something like this:
```
foo.tml ..
ok 1 - Test block 1
ok 2 - Test block 2
ok 3 - Test block 1
ok 4 - Test block 2
ok 5 - Test block 1
ok 6 - Test block 2
ok 7 - Test block 1
ok 8 - Test block 2
ok 9 - Test block 2
1..9
ok
All tests successful.
Files=1, Tests=9,  1 wallclock secs ( 0.02 usr  0.00 sys +  0.60 cusr  0.06 csys =  0.68 CPU)
Result: PASS
```

# Description

TestML is a language for writing data driven tests for software written in most
modern programming languages.

You define sections of data called blocks, that define pieces of data called
points. A data point is either an input or an expected output, or sometimes
both.

You also define assertions that are run against the data blocks. For example,
this assertion:
```
*in.transform == *out
```

does the following steps:

* For each block
* If the block has an `in` point and an `out` point
* Call a "bridge" method named `transform` passing the `in` data
* Compare the output of `transform` to the `out` point's data
* Tell the test framework to report a "pass" or "fail"

The bridge code is written in the language of the software you are testing. It
acts as a connection between the language agnostic TestML and the software you
are testing.

It is common for a data block to define many related data points, and then use
different input/output pairs of points for different test assertions.

# Installation

```
git clone git@github.com:testml-lang/testml
source testml/.rc
```