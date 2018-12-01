#!/bin/sh

echo "Generating README.md"

echo "[![Build Status](https://travis-ci.org/lichtkind/Perl6-Math-Matrix-Bundle.svg?branch=master)](https://travis-ci.org/lichtkind/Perl6-Math-Matrix-Bundle)" >README.md

#echo "[![Build status](https://ci.appveyor.com/api/projects/status/github/lichtkind/Perl6-Math-Matrix-Bundle?svg=true)](https://ci.appveyor.com/project/lichtkind/Perl6-Math-Matrix-Bundle/branch/master)\n" >>README.md

perl6 --doc=Markdown lib/Math/Matrix.pod >>README.md

