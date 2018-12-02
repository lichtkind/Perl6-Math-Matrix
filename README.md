[![Build Status](https://travis-ci.org/lichtkind/Perl6-Math-Matrix-Bundle.svg?branch=master)](https://travis-ci.org/lichtkind/Perl6-Math-Matrix-Bundle)
[![Build status](https://ci.appveyor.com/api/projects/status/github/lichtkind/Perl6-Math-Matrix-Bundle?svg=true)](https://ci.appveyor.com/project/lichtkind/Perl6-Math-Matrix-Bundle/branch/master)

NAME
====

Math::Matrix::Bundle - vectors, matrices, decompositions and more

VERSION
=======

0.3.8

!LATER!
=======

This repo will be the new home and successor of [this project](https://github.com/pierre-vigier/Perl6-Math-Matrix).

SYNOPSIS
========

Matrices are tables with rows and columns (index counting from 0) of numbers (Numeric type - Bool or Int or Num or Rat or FatRat or Complex): 

    transpose, invert, negate, add, multiply, dot product, tensor product, 22 ops, determinant, rank, norm
    14 numerical properties, 23 boolean properties, 3 decompositions, submatrix, splice, map, reduce and more

Table of Content:

  * [Methods](#methods)

  * [Operators](#operators)

  * [Export Tags](#export-tags)

  * [Authors](#authors)

  * [License](#license)

DESCRIPTION
===========

Because the list based, functional toolbox of Perl 6 is not enough to calculate matrices comfortably, there is a need for a dedicated data type. The aim is to provide a full featured set of structural and mathematical operations that integrate fully with the Perl 6 conventions. This module is pure perl and we plan to use native shaped arrays one day.

Matrices are readonly - operations and functions do create new matrix objects. All methods return readonly data or deep clones - also the constructor does a deep clone of provided data. In that sense the library is thread safe.

All computation heavy properties will be calculated lazily and cached.

[METHODS](#synopsis)
====================

  * **[constructors](#constructors)**: [new []](#new--), [new ()](#new---1), [new ""](#new---2), [new-zero](#new-zero), [new-identity](#new-identity), [new-diagonal](#new-diagonal), [new-vector-product](#new-vector-product)

  * **[accessors](#accessors)**: [element](#element), [AT-POS](#at-pos), [row](#row), [column](#column), [diagonal](#diagonal), [skew-diagonal](#skew-diagonal), [submatrix](#submatrix)

  * **[converter](#converter)**: [Bool](#bool), [Str](#str), [Numeric](#numeric), [Range](#range), [Array](#array), [list](#list), [list-rows](#list-rows), [list-columns](#list-columns), [Hash](#hash), [gist](#gist), [perl](#perl)

  * **[boolean properties](#boolean-properties)**: [square](#is-square), [zero](#is-zero), [identity](#identity), [triangular](#is-triangular), [diagonal](#is-diagonal), [-dominant](#is-diagonally-dominant), [-constant](#is-diagonal-constant), [catalecticant](#is-catalecticant), [anti-](#is-antisymmetric), [symmetric](#is-symmetric), [unitary](#is-unitary), [self-adjoint](#is-self-adjoint), [invertible](#is-invertible), [orthogonal](#is-orthogonal), [positive-definite](#is-positive-definite), [positive-semidefinite](#is-positive-semidefinite)

  * **[numeric properties](#numeric-properties)**: [size](#size), [density](#density), [bandwith](#bandwith), [trace](#trace), [rank](#rank), [nullity](#nullity), [determinant](#determinant), [minor](#minor), [norm](#norm), [condition](#condition), [element-type](#element-type)

  * **[derived matrices](#derived-matrices)**: [transposed](#transposed), [negated](#negated), [conjugated](#conjugated), [adjugated](#adjugated), [inverted](#inverted), [reduced-row-echelon-form](#reduced-row-echelon-form)

  * **[decompositions](#decompositions)**: [LUCrout](#decompositionlucrout), [LU](#decompositionlu), [Cholesky](#decompositioncholesky)

  * **[math ops](#mathematical-operations)**: [equal](#equal), [add](#add), [multiply](#multiply), [dot-product](#dot-product), [tensor-product](#tensor-product)

  * **[list like ops](#list-like-operations)**: [elems](#elems), [elem](#elem), [cont](#cont), [map](#map), [map-with-index](#map-with-index), [reduce](#reduce), [reduce-rows](#reduce-rows), [reduce-columns](#reduce-columns)

  * **[structural ops](#structural-operations)**: [move-row](#move-row), [move-column](#move-column), [swap-rows](#swap-rows), [swap-columns](#swap-columns), [splice-rows](#splice-rows), [splice-columns](#splice-columns)

  * **[shortcuts](#shortcuts)**: [T](#transposed), [conj](#conjugated), [det](#determinant), [rref](#reduced-row-echelon-form)

  * **[operators](#operator-methods)**: MM, ?, ~, |, @, %, +, -, *, **, dot, ⋅, ÷, X*, ⊗, ==, ~~, ❘ ❘, ‖ ‖, [ ]

[Constructors](#methods)
------------------------

Methods that create a new Math::Matrix object. The default is of course .new, which can take array of array of values (fastest) or one string. Additional constructers: [new-zero](#new-zero), [new-identity](#new-identity), [new-diagonal](#new-diagonal) and [new-vector-product](#new-vector-product) are there for convenience and to optimize property calculation.

### [new( [[...],...,[...]] )](#constructors)

The default constructor, takes arrays of arrays of numbers as the only required parameter. Each second level array represents a row in the matrix. That is why their length has to be the same. Empty rows or columns we not be accepted. 

    say Math::Matrix.new( [[1,2],[3,4]] ) :

    1 2
    3 4

    Math::Matrix.new([<1 2>,<3 4>]); # does the same, WARNING: doesn't work with complex numbers
    Math::Matrix.new( [[1]] );       # one element 1*1 matrix (exception where you don't have to mind comma)
    Math::Matrix.new( [[1,2,3],] );  # one row 1*3 matrix, mind the trailing comma
    Math::Matrix.new( [$[1,2,3]] );  # does the same, if you don't like trailing comma
    Math::Matrix.new( [[1],[2]] );   # one column 2*1 matrix

    use Math::Matrix :MM;            # tag :ALL works too
    MM [[1,2],[3,4]];                # shortcut

### [new( ((...),...,(...)) )](#constructors)

Instead of square brackets you can use round ones too and use a list of lists as argument too.

    say Math::Matrix.new( ((1,2),(3,4)) );
    say MM ((1,2),(3,4)) :

    1 2
    3 4

### [new( "..." )](#constructors)

Alternatively you can define the matrix from a string, which makes most sense while using heredocs.

    Math::Matrix.new("1 2 \n 3 4"); # our demo matrix as string
    Math::Matrix.new: q:to/END/;    # indent as you wish
        1 2
        3 4
      END

    use Math::Matrix :ALL;          # 
    MM '1';                         # 1 * 1 matrix, this case begs for a shortcut

### [new-zero](#constructors)

This method is a constructor, that returns a zero matrix (sometimes called empty), as checked by [is-zero](#is-zero). It has the [size](#size) as given by arguments. If only one argument is given, the matrix is [quadratic](#is-square). All the [element](#element)s are set to 0.

    say Math::Matrix.new-zero( 3, 4 ) :

    0 0 0 0
    0 0 0 0
    0 0 0 0

    say Math::Matrix.new-zero( 2 ) :

    0 0
    0 0

### [new-identity](#constructors)

This method is a constructor that returns an identity matrix (as checked by [is-identity](#is-identity)) of the size given in the only and required parameter. All the [element](#element)s are set to 0 except the top/left to bottom/right diagonale is set to 1.

    say Math::Matrix.new-identity( 3 ) :
      
    1 0 0
    0 1 0
    0 0 1

### [new-diagonal](#constructors)

This method is a constructor that returns an diagonal matrix (as checked by [is-diagonal](#is-diagonal)) of the size given by count of the parameter. All the [element](#element)s are set to 0 except the top/left to bottom/right diagonal, set to given values.

    say Math::Matrix.new-diagonal( 2, 4, 5 ) :

    2 0 0
    0 4 0
    0 0 5

### [new-vector-product](#constructors)

This method is a constructor that returns a matrix which is a result of the matrix product (method [dot-product](#dot-product), or operator dot) of a column vector (first argument) and a row vector (second argument). It can also be understood as a tensor product of row and column.

    say Math::Matrix.new-vector-product([1,2,3],[2,3,4]) :

    *    2    3    4
    1  1*2  1*3  1*4     2  3  4
    2  2*2  2*3  2*4  =  4  6  8
    3  3*2  3*3  3*4     6  9 12

[Accessors](#methods)
---------------------

Methods that return the content of selected elements.

[element](#element), [AT-POS](#at-pos), [row](#row), [column](#column), [diagonal](#diagonal), [skew-diagonal](#skew-diagonal), [submatrix](#submatrix)

### [element](#accessors)

Gets value of one element in row (first parameter) and column (second parameter - counting always from 0). Sometimes its called matrix cell, to ditinct from other type of elements. See: [elems](#elems), [elem](#elem), [element-type](#element-type)

    my $matrix = Math::Matrix.new([[1,2],[3,4]]);
    say $matrix.element(0,1)            : 2
    say $matrix[0][1]                   # array syntax alias

### [AT-POS](#accessors)

Gets row as array to enable direct postcircumfix syntax as shown in last example.

    say $matrix.AT-POS(0)     : [1,2]
    say $matrix[0]            # operator alias
    say $matrix.Array[0]      # long alias with converter method Array

### [row](#accessors)

Gets values of specified row (first required parameter) as a list.

    say Math::Matrix.new([[1,2],[3,4]]).row(0) : (1, 2)

### [column](#accessors)

Gets values of specified column (first required parameter) as a list.

    say Math::Matrix.new([[1,2],[3,4]]).column(0) : (1, 3)

### [diagonal](#accessors)

Without an argument it returns values of main diagonal elements as a list. Use the optional parameter to get any other parallel diagonal. Positive value for the ones above - negative below and 0 for the main diagonal. The matrix does not have to be a quadratic ([square](#is-square)).

    say Math::Matrix.new([[1,2],[3,4]]      ).diagonal    : (1, 4)
    say Math::Matrix.new([[1,2],[3,4]]      ).diagonal(1) : (2)
    say Math::Matrix.new([[1,2],[3,4],[5,6]]).diagonal(-1): (3, 6)

### [skew-diagonal](#accessors)

Unlike a *diagonal*, a skew diagonal is only defined for [square](#is-square) matrixes. It runs from $matrix[n][0] to $matrix[0][n], n being row or column size - 1. Use the optional parameter to get any other parallel skew diagonal. Positive value for the ones below - negative above.

    say $matrix.skew-diagonal    : (2, 3)
    say $matrix.skew-diagonal(0) : (2, 3)
    say $matrix.skew-diagonal(-1) : (1)
    say $matrix.skew-diagonal(1): (4)

### [submatrix](#accessors)

Returns a matrix that might miss certain rows and columns of the original. This method accepts arguments in three different formats. The first follows the strict mathematical definition of a submatrix, the second supports a rather visual understanding of the term and the third is a way to get almost any combination rows and columns you might wish for. To properly present these functions, we base the next examples upon this matrix:

    say $m:    1 2 3 4
               2 3 4 5
               3 4 5 6
               4 5 6 7

#### [leaving out one](#submatrix)

In mathematics, a submatrix is built by leaving out one row and one column. In the two argument format you name these by their index ($row, $column).

    say $m.submatrix(1,2) :    1 2 4
                               3 4 6
                               4 5 7

#### [leaving out more](#submatrix)

If you provide two ranges (row-min .. row-max, col-min .. col-max - both optional) to the appropriately named arguments, you get the excerpt of the matrix, that contains only the requested rows and columns - still in the original order.

    say $m.submatrix( rows => 1..1, columns => 1..*) :      4 5        
    say $m.submatrix( rows => 1..1 )                 :    3 4 5

#### [reordering](#submatrix)

Alternatively each (as previously) named argument can also take a list (or array) of values, as created my the sequence operator (...). The result will be a matrix with that selection of rows and columns. Please note, you may pick rows/columns in any order and as many times you prefer.

    $m.submatrix(rows => (1,2), columns => (3,2)):    5 4
                                                      6 5
                                                      
    $m.submatrix(rows => (1...2), columns => (3,2))  # same thing

Arguments with ranges and lists can be mixed and are in both cases optional. If you provide none of them, the result will be the original matrix.

    say $m.submatrix( rows => (1,) )              :   3 4 5        

    $m.submatrix(rows => (1..*), columns => (3,2)):   5 4
                                                      6 5

Even more powerful or explicit in syntax are the [structural ops](#structural-operations).

[Converter](#methods)
---------------------

Methods that convert a matrix into other types: [Bool](#bool), [Str](#str), [Numeric](#numeric), [Range](#range), [Array](#array), [Hash](#hash), [list](#list), [list-rows](#list-rows), [list-columns](#list-columns) or allow different views on the overall content (output formats): [gist](#gist), [perl](#perl).

### [Bool](#converter)

Conversion into Bool context. Returns False if matrix is zero (all elements equal zero as in [is-zero](#is-zero)), otherwise True.

    $matrix.Bool
    ? $matrix           # alias op
    if $matrix          # matrix in Bool context too

### [Str](#converter)

Returns values of all [element](#element)s, separated by one whitespace, rows by new line. This is the same format as expected by [new("")](#new---2). Str is called implicitly by put and print. A shortened version is provided by [gist](#gist)

    say Math::Matrix.new([[1,2],[3,4]]).Str:

    1 2                 # meaning: "1 2\n3 4"
    3 4                

    ~$matrix            # alias op

### [Numeric](#converter)

Conversion into Numeric context. Returns Euclidean [norm](#norm). Please note, only a prefix operator + (as in: + $matrix) will call this Method. An infix (as in $matrix + $number) calls $matrix.add($number).

    $matrix.Numeric
    + $matrix           # alias op

### [Range](#converter)

Returns an range object that reflects the content of all [element](#element)s. Please note that complex number can not be endpoints of ranges.

    say $matrix.Range: 1..4

To get single endpoints you could write:

    say $matrix.Range.min: 1
    say $matrix.list.max:  4

### [Array](#converter)

Content of all [element](#element)s as an array of arrays (same format that was put into [new([...])](#new--)).

    say Math::Matrix.new([[1,2],[3,4]]).Array : [[1 2] [3 4]]
    say @ $matrix       # alias op, space between @ and $ needed

### [list](#converter)

Returns a flat list with all [element](#element)s (same as .list-rows.flat.list).

    say $matrix.list    : (1 2 3 4)
    say |$matrix        # alias op

### [list-rows](#converter)

Returns a list of lists, reflecting the row-wise content of the matrix. Same format as [new ()](#new---1) takes in.

    say Math::Matrix.new( [[1,2],[3,4]] ).list-rows      : ((1 2) (3 4))
    say Math::Matrix.new( [[1,2],[3,4]] ).list-rows.flat : (1 2 3 4)

### [list-columns](#converter)

Returns a list of lists, reflecting the row-wise content of the matrix.

    say Math::Matrix.new( [[1,2],[3,4]] ).list-columns : ((1 3) (2 4))
    say Math::Matrix.new( [[1,2],[3,4]] ).list-columns.flat : (1 3 2 4)

### [Hash](#converter)

Gets you a nested key - value hash.

    say $matrix.Hash : { 0 => { 0 => 1, 1 => 2}, 1 => {0 => 3, 1 => 4} } 
    say % $matrix       # alias op, space between % and $ still needed

### [gist](#converter)

Limited tabular view, optimized for shell output. Just cuts off excessive columns that do not fit into standard terminal and also stops after 20 rows. If you call it explicitly, you can add width and height (char count) as optional arguments. Might even not show all decimals. Several dots will hint that something is missing. It is implicitly called by say. For a full view use [Str](#str).

    say $matrix;      # output of a matrix with more than 100 elements

    1 2 3 4 5 ..
    3 4 5 6 7 ..
    ...

    say $matrix.gist(max-chars => 100, max-rows => 5 );

max-chars is the maximum amount of characters in any row of output (default is 80). max-rows is the maximum amount of rows gist will put out (default is 20). After gist ist called once (with or without arguments) the output will be cached. So next time you call:

    say $matrix       # 100 x 5 is still the max

You change the cache by calling gist with arguments again.

### [perl](#converter)

Conversion into String that can reevaluated into the same object later using default constructor.

    my $clone = eval $matrix.perl;       # same as: $matrix.clone

[Boolean Properties](#methods)
------------------------------

These are mathematical properties, a given matrix has or not. Thus, the return value is a always of boolean type. Arguments, like in case of [is-diagonally-dominant](#is-diagonally-dominant), are only necessary when a method can tell you about a group of closely related properties.

[square](#is-square), [zero](#is-zero), [identity](#identity), [triangular](#is-triangular), [upper-triangular](#is-upper-triangular), [lower-triangular](#is-lower-triangular), [diagonal](#is-diagonal), [diagonally-dominant](#is-diagonally-dominant), [diagonal-constant](#is-diagonal-constant), [catalecticant](#is-catalecticant), [symmetric](#is-symmetric), [anti-symmetric](#is-antisymmetric), [unitary](#is-unitary), [self-adjoint](#is-self-adjoint), [invertible](#is-invertible), [orthogonal](#is-orthogonal), [positive-definite](#is-positive-definite), [positive-semidefinite](#is-positive-semidefinite)

### [is-square](#boolean-properties)

True if number of rows and colums are the same (see [size](#size)).

### [is-zero](#boolean-properties)

True if every [element](#element) has value of 0 (as created by [new-zero](#new-zero)).

### [is-identity](#boolean-properties)

True if every [element](#element) on the main [diagonal](#diagonal) (where row index equals column index) is 1 and any other element is 0.

    Example:    1 0 0
                0 1 0
                0 0 1

### [is-triangular](#boolean-properties)

True if matrix *is-upper-triangular* or *is-lower-triangular* (none - strict).

#### [is-upper-triangular](#boolean-properties)

a.k.a *right triangular* matrix: every [element](#element) below the [diagonal](#diagonal) (where row index is greater than column index) is 0. In other words: the [lower-bandwith](#lower-bandwith) is zero.

    Example:    1 2 5
                0 3 8
                0 0 7

There is an optional, boolean argument named :strict.

    $matrix.is-upper-triangular(:!strict);   # asks for matrix is none strict triangular (default)
    $matrix.is-upper-triangular(:strict);    # search for strictly triangular matrix

    Example:    0 2 5
                0 0 8
                0 0 0

#### [is-lower-triangular](#boolean-properties)

a.k.a *left triangular* matrix: every [element](#element) above the [diagonal](#diagonal) (where row index is smaller than column index) is 0. In other words: the [upper-bandwith](#upper-bandwith) is zero.

    Example:    1 0 0
                2 3 0
                5 8 7

Has also an optional, boolean argument named :strict.

    $matrix.is-lower-triangular(:!strict);   # asks for matrix is none strict triangular (default)
    $matrix.is-lower-triangular(:strict);    # search for strictly triangular matrix

    Example:    0 0 0
                2 0 0
                5 8 0

### [is-diagonal](#boolean-properties)

True if matrix is [square](#is-square) and only elements on the [diagonal](#diagonal) differ from 0. In other words: if matrix is [upper-triangular](#is-upper-triangular) and [lower-triangular](#is-lower-triangular).

    Example:    1 0 0
                0 3 0
                0 0 7

### [is-diagonally-dominant](#boolean-properties)

True when [element](#element)s on the [diagonal](#diagonal) have a bigger (if strict) or at least equal (in none strict) absolute value than the sum of its row (sum of absolute values of the row except diagonal element).

    if $matrix.is-diagonally-dominant {
    $matrix.is-diagonally-dominant(:!strict)      # same thing (default)
    $matrix.is-diagonally-dominant(:strict)       # diagonal elements (DE) are stricly greater (>)
    $matrix.is-diagonally-dominant(:!strict, :along<column>) # default
    $matrix.is-diagonally-dominant(:strict,  :along<row>)    # DE > sum of rest row
    $matrix.is-diagonally-dominant(:!strict, :along<both>)   # DE >= sum of rest row and rest column

### [is-diagonal-constant](#boolean-properties)

Checks if caller is a *diagonal-constant* or *Töplitz matrix*. True if every [diagonal](#diagonal) is the a collection of [element](#element)s that hold the same value.

    Example:     0  1  2
                -1  0  1
                -2 -1  0

### [is-catalecticant](#boolean-properties)

Checks if caller is a *catalecticant* or *Hankel matrix*. True if every [skew diagonal](#skew-diagonal) is the a collection of elements that hold the same value. Catalecticant matrices are [symmetric](#is-symmetric).

    Example:     0  1  2
                 1  2  3
                 2  3  4

### [is-symmetric](#boolean-properties)

True if every [element](#element) with coordinates x y has same value as the element on y x. In other words: $matrix and $matrix.[transposed](#transposed) (alias T) are the same.

    Example:    1 2 3
                2 5 4
                3 4 7

### [is-antisymmetric](#boolean-properties)

Means the [transposed](#transposed) and [negated](#negated) matrix are the same.

    Example:    0  2  3
               -2  0  4
               -3 -4  0

### [is-self-adjoint](#boolean-properties)

A Hermitian or self-adjoint matrix is [equal](#equal) to its [transposed](#transposed) and complex [conjugated](#conjugated).

    Example:    1   2   3+i
                2   5   4
                3-i 4   7

### [is-invertible](#boolean-properties)

Also called *nonsingular* or *nondegenerate*. (To ask if matrix is degenerate or singular - simply negate the result with ! or *not*). Is True if matrix ([is-square](#is-square)) and [determinant](#determinant) is not zero. All rows or colums have to be independent vectors. Please check this before using $matrix.[inverted](#inverted), or you will get an exception, in case it was degenerate.

### [is-orthogonal](#boolean-properties)

An orthogonal matrix multiplied ([dot-product](#dot-product)) with its transposed derivative (T) is an [identity](#is-identity) matrix or in other words: [transposed](#transposed) and [inverted](#inverted) matrices are [equal](#equal).

### [is-unitary](#boolean-properties)

An unitery matrix multiplied ([dot-product](#dot-product)) with its concjugate transposed derivative (.conj.T) is an [identity](#is-identity) matrix, or said differently: the concjugate transposed matrix equals the [inverted](#inverted) matrix.

### [is-positive-definite](#boolean-properties)

True if all main [minors](#minor) or all Eigenvalues are strictly greater zero.

### [is-positive-semidefinite](#boolean-properties)

True if all main [minors](#minor) or all Eigenvalues are greater equal zero.

[Numeric Properties](#methods)
------------------------------

Matrix properties that are expressed with a single number, which will be calculated without further input.

[size](#size), [density](#density), **[bandwith](#bandwith)**: ([lower-bandwith](#lower-bandwith), [upper-bandwith](#upper-bandwith)), [trace](#trace), [rank](#rank), [nullity](#nullity), [determinant](#determinant), [minor](#minor), [norm](#norm), [condition](#condition), **[element-type](#element-type)**: ([narrowest-element-type](#narrowest-element-type), [widest-element-type](#widest-element-type))

### [size](#numeric-properties)

List of two values: number of rows and number of columns.

    say $matrix.size();
    my $dim = min $matrix.size;

### [density](#numeric-properties)

*Density* is the percentage of [element](#element)s which are not zero. *sparsity* = 1 - *density*.

    my $d = $matrix.density;

### [bandwith](#numeric-properties)

Is roughly the greatest distance of a none zero value from the main [diagonal](#diagonal). A matrix that [is-diagonal](#is-diagonal) has a bandwith of 0. If there is a none zero value on an diagonal above or below the main diagonal, tha bandwith would be one.

    my $bw = $matrix.bandwith;

#### [lower-bandwith](#bandwith)

In a matrix with the lower bandwith of k, every [element](#element) with row index m and column index n, for which holds m - k > n, the content has to be zero. Literally speaking: there are k [diagonal](#diagonal)s below the main diagonal, that contain none zero values.

#### [upper-bandwith](#bandwith)

Analogously, every [element](#element) with m + k < n is zero if matrix has an upper bandwith of k.

    Example:    1  0  0
                4  2  0
                0  5  3

The *bidiagonal* example matrix has an upper bandwith of zero and lower bandwith of one, so the overall bandwith is one.

### [trace](#numeric-properties)

The trace of a [square](#is-square) matrix is the sum of the [element](#element)s on the main diagonal. In other words: sum of elements which row and column value is identical.

    my $tr = $matrix.trace;

### [rank](#numeric-properties)

Rank is the number of independent row or column vectors or also called independent dimensions (thats why this command is sometimes calles dim)

    my $r = $matrix.rank;

### [nullity](#numeric-properties)

Nullity of a matrix is the number of dependent rows or columns (rank + nullity = dim). Or number of dimensions of the kernel (vector space mapped by the matrix into zero).

    my $n = $matrix.nullity;

### [determinant](#numeric-properties)

Only a [square](#is-square) matrice has a defined determinant, which tells the volume, spanned by the row or column vectors. So if the volume is just in one dimension flat, the determinant is zero, and has a kernel (not a full [rank](#rank) - thus is not [invertible](#is-invertable)).

    my $det = $matrix.determinant;
    my $d = $matrix.det;                # same thing
    my $d = ❘ $matrix ❘;                # unicode operator shortcut

### [minor](#numeric-properties)

A Minor is the determinant of a [submatrix](#leaving-out-one) (first variant with same 2 scalar arguments a minor method). The two required positional arguments are row and column indices of an existing [element](#element).

    my $m = $matrix.minor(1,2);

### [norm](#numeric-properties)

A norm is a single positive number, which is an abstraction to the concept of size. Most common form for matrices is the p-norm, where in step 1 the absolute value of every [element](#element) is taken to the power of p. The sum of these results is taken to the power of 1/p. The p-q-Norm extents this process. In his step 2 every column-sum is taken to the power of (p/q). In step 3 the sum of these are taken to the power of (1/q).

    my $norm = $matrix.norm( );           # euclidian norm aka L2 (p = 2, q = 2)
    my $norm = + $matrix;                 # context op shortcut
    my $norm = ‖ $matrix ‖;               # unicode op shortcut
    my $norm = $matrix.norm(1);           # p-norm aka L1 = sum of all elements absolute values (p = 1, q = 1)
    my $norm = $matrix.norm(p:<4>,q:<3>); # p,q - norm, p = 4, q = 3
    my $norm = $matrix.norm(p:<2>,q:<2>); # L2 aka Euclidean aka Frobenius norm
    my $norm = $matrix.norm('euclidean'); # same thing, more expressive to some
    my $norm = $matrix.norm('frobenius'); # same thing, more expressive to some
    my $norm = $matrix.norm('max');       # maximum norm - biggest absolute value of a element
    $matrix.norm('row-sum');              # row sum norm - biggest abs. value-sum of a row
    $matrix.norm('column-sum');           # column sum norm - same column wise

### [condition](#numeric-properties)

Condition number of a matrix is L2 norm * L2 of [inverted](#inverted) matrix.

    my $c = $matrix.condition( );

### [element-type](#numeric-properties)

#### [narrowest-element-type](#numeric-properties)

#### [widest-element-type](#numeric-properties)

Matrix [element](#element)s can be (from most narrow to widest), of type (Bool), (Int), (Num), (Rat), (FatRat) or (Complex). The widest type of any element will returned as type object.

In the next example the smartmatch returns true, because no element of our default example matrix has wider type than (Int). After such a test all elements can be safely treated as Int or Bool.

    if $matrix.widest-element-type ~~ Int { ...

You can also check if all elements have the same type:

    if $matrix.widest-element-type eqv $matrix.narrowest-element-type

[Derived Matrices](#methods)
----------------------------

Single matrices, that can be computed with only our original matrix as input.

[transposed](#transposed), [negated](#negated), [conjugated](#conjugated), [adjugated](#adjugated), [inverted](#inverted), [reduced-row-echelon-form](#reduced-row-echelon-form)

### [transposed](#derived-matrices)

Returns a new, transposed Matrix, where rows became colums and vice versa.

    Math::Matrix.new([[1,2,3],[3,4,6]]).transposed :

    [[1 2 3]     = [[1 4]
     [4 5 6]].T     [2 5]
                    [3 6]]

    Math::Matrix.new([[1,2,3],[3,4,6]]).T # same but shorter

### [negated](#derived-matrices)

Creates a matrix where every [element](#element) has the negated value of the original (invertion of sign).

    my $new = $matrix.negated();     # invert sign of all elements
    my $neg = - $matrix;             # operator alias

    say $neg:  -1 -2
               -3 -4

### [conjugated](#derived-matrices)

Creates a matrix where every [element](#element) is the complex conjugated of the original.

    my $c = $matrix.conjugated();    # change every value to its complex conjugated
    my $c = $matrix.conj();          # short alias (official Perl 6 name)

    say Math::Matrix.new([[1+i,2],[3,4-i]]).conj :

    1-1i  2   
    3     4+1i

### [adjugated](#derived-matrices)

Creates a matrix out of the properly signed [minors](#minor) of the original. It is called adjugate, classical adjoint or sometimes adjunct.

    $matrix.adjugated.say :

     4 -3
    -2  1

### [inverted](#derived-matrices)

Matrices that have a [square](#is-square) form and a full [rank](#rank) can be [inverted](#inverted) (see [is-invertible](#is-invertible)). Inverse matrix regarding to matrix multiplication (see [dot-product](#dot-product)). The dot product of a matrix with it's inverted results in a [identity](#is-identity) matrix (neutral element in this group).

    my $i = $matrix.inverted();      # invert matrix
    my $i = $matrix ** -1;           # operator alias

    say $i:

     -2    1
    1.5 -0.5

### [reduced-row-echelon-form](#derived-matrices)

Return the reduced row echelon form of a matrix, a.k.a. row canonical form

    my $rref = $matrix.reduced-row-echelon-form();
    my $rref = $matrix.rref();       # short alias

[Decompositions](#methods)
--------------------------

Methods that return lists of matrices, which in their product or otherwise can be recombined to the original matrix. In case of cholesky only one matrix is returned, because the other one is its transposed.

### [decompositionLU](#decompositions)

    my ($L, $U, $P) = $matrix.decompositionLU( );
    $L dot $U eq $matrix dot $P;         # True
    my ($L, $U) = $matrix.decompositionLUC(:!pivot);
    $L dot $U eq $matrix;                # True

$L is a left triangular matrix and $R is a right one Without pivotisation the marix has to be invertible ([square](#is-square) and full [rank](#rank)ed). In case you whant two unipotent triangular matrices and a diagonal (D): use the :diagonal option, which can be freely combined with :pivot.

    my ($L, $D, $U, $P) = $matrix.decompositionLU( :diagonal );
    $L dot $D dot $U eq $matrix dot $P;  # True

### [decompositionLUCrout](#decompositions)

    my ($L, $U) = $matrix.decompositionLUCrout( );
    $L dot $U eq $matrix;                # True

$L is a left triangular matrix and $R is a right one This decomposition works only on invertible matrices ([square](#is-square) and full [rank](#rank)ed).

### [decompositionCholesky](#decompositions)

This decomposition works only on symmetric and definite positive matrices.

    my $D = $matrix.decompositionCholesky( );  # $D is a left triangular matrix
    $D dot $D.T eq $matrix;                    # True

[Mathematical Operations](#methods)
-----------------------------------

Matrix math methods on full matrices and also parts (for gaussian table operations).

They are: [equal](#equal), [add](#add), [multiply](#multiply), [dot-product](#dot-product), [tensor-product](#tensor-product).

### [equal](#mathematical-operations)

Checks two matrices for equality. They have to be of same [size](#size) and every [element](#element) of the first matrix on a particular position has to be numerically equal (as checked by *==*) to the element (on the same position) of the second matrix.

    if $matrixa.equal( $matrixb ) {   # method variant
    if $matrixa == $matrixb {         # operator alias
    if $matrixa ~~ $matrixb {         # smart match redirects to ==

### [add](#mathematical-operations)

Adding a matrix, vector or scalar. Named arguments *:row* and *:column* have no fixed position.

#### [add matrix](#add)

When adding two matrices, they have to be of the same size. Instead of Math::matrix object you can also provide the element data as [new []](#new--), [new ()](#new---1) or [new ""](#new---2) would accept it.

    $matrix.add( $matrix2 );
    $matrix.add( [[2,3],[4,5]] ); # data alias
    $matrix + $matrix2            # operator alias

    Example:    1 2  +  2 3  =  3 5
                3 4     4 5     7 9

#### [add vector](#add)

To add a vector you have to specify to which row or column it should be added and give a list or array (which have to fit the matrix size).

    $matrix.add( row => 1, [2,3] );

    Example:    1 2  +       =  1 2
                3 4    2 3      5 7

    $matrix.add( column => 1, (2,3) );

    Example:    1 2  +   2   =  1 4
                3 4      3      3 7

#### [add scalar](#add)

When adding a single number to the matrix, it will be added to every [element](#element). If you provide a row or column number it will be only added to that row or column. In case you provide both, only a single element gets a different value in the result matrix.

    $matrix.add( $number );       # adds number from every element 
    $matrix + $number;            # works too

    Example:    1 2  +  5    =  6 7 
                3 4             8 9

                1 2  +  2 3  =  3 5
                3 4     4 5     7 9

    $matrix.add( row => 1, 3 ):             [[1,2],[6,7]]
    $matrix.add( row => 1, column=> 0, 2 ): [[1,2],[5,4]]

### [multiply](#mathematical-operations)

Unlike the [dot-product](#dot-product) and [tensor-product](#tensor-product), this operation is the simple, scalar multiplication applied to [element](#element)s. That is why this method works analogous to the scalar variant of [add](#add-scalar). However, when a matrix of same size is given, the result will be a matrix of that size again. Each element will be the product of two the two elements of the operands with the same indices (position).

    my $product = $matrix.multiply( $number );   # multiply every element with number
    my $p = $matrix * $number;                   # works too

    Example:    1 2  *  5    =   5 10 
                3 4             15 20

    my $product = $matrix.multiply( $matrix2 );  # element wise multiplication of same size matrices
    my $p = $matrix * $matrix2;                  # works too

    Example:    1 2  *  2 3  =   2  6
                3 4     4 5     12 20


    $matrix.multiply( row => 0, 2);

    Example:    1 2  * 2     =  2 4
                3 4             3 4

    $matrix.multiply(2, column => 0 );

    Example:    1 2   =  2 2
                3 4      6 4
            
               *2

    $matrix.multiply(row => 1, column => 1, 3) : [[1,2],[3,12]]

### [dot-product](#mathematical-operations)

Matrix multiplication of two fitting matrices (colums left == rows right).

    Math::Matrix.new( [[1,2],[3,4]] ).dot-product(  Math::Matrix.new([[2,3],[4,5]]) );

    Example:    2  3
                4  5
             *
         1 2   10 13  =  1*2+2*4  1*3+2*5
         3 4   22 29     3*2+4*4  3*3+4*5

    my $product = $matrix1.dot-product( $matrix2 )
    my $c = $a dot $b;              # works too as operator alias
    my $c = $a ⋅ $b;                # unicode operator alias

    A shortcut for multiplication is the power - operator **
    my $c = $a **  3;               # same as $a dot $a dot $a
    my $c = $a ** -3;               # same as ($a dot $a dot $a).inverted
    my $c = $a **  0;               # created an right sized identity matrix

### [tensor-product](#mathematical-operations)

The *tensor product* (a.k.a *Kronecker product*) between a matrix A of *size|#size* (m,n) and matrix B of size (p,q) is a matrix C of size (m*p,n*q). C is a concatination of matrices you get if you take every [element](#element) of A and do a [scalar multiplication](#multiply) with B as in $B.multiply($A.element(..,..)).

    Example:    1 2  X*  2 3   =  1*[2 3] 2*[2 3]  =  2  3  4  6
                3 4      4 5        [4 5]   [4 5]     4  5  8 10
                                  3*[2 3] 4*[2 3]     6  9  8 12
                                    [4 5]   [4 5]     8 15 16 20

    my $c = $matrixa.tensor-product( $matrixb );
    my $c = $a X* $b;               # works too as operator alias
    my $c = $a ⊗ $b;                # unicode operator alias

[List Like Operations](#methods)
--------------------------------

Methods that usually are provided by Lists and Arrays, but make also sense in context of matrices.

### [elems](#list-like-operations)

Number (count) of [element](#element)s = rows * columns (see [size](#size)).

    say $matrix.elems();

### [elem](#list-like-operations)

Asks if all [element](#element) of Matrix (cell) values are an element of the given set or range.

    Math::Matrix.new([[1,2],[3,4]]).elem(1..4) :   True
    Math::Matrix.new([[1,2],[3,4]]).elem(2..5) :   False, 1 is not in 2..5

### [cont](#list-like-operations)

Asks if the matrix contains a value equal to the only argument of the method. If a range is provided as argument, at least one value has to be within this range to make the result true.

    Math::Matrix.new([[1,2],[3,4]]).cont(1)   : True
    Math::Matrix.new([[1,2],[3,4]]).cont(5)   : False
    Math::Matrix.new([[1,2],[3,4]]).cont(3..7): True

    MM [[1,2],[3,4]] (cont) 1                 # True too

### [map](#list-like-operations)

Creates a new matrix of same size by iterating over all or some [element](#element)s. For every chosen element with the indices (m,n), a provided code block (required argument) will be run once. That block will be given the elements(m,n) value as an argument. The return value of the block will be the content of the element(m,n) of the resulting matrix.

    say $matrix.map(* + 1) :

    2 3
    4 5

By provding values (Ranges) to the named arguments *rows* and *columns* (no special order required), only a subset of rows or columns will be mapped - the rest will be just copied.

    say $matrix.map( rows => (0..0), {$_ * 2}) :

    2 4
    3 4

    say $matrix.map( rows => (1..*), columns => (1..1), {$_ ** 2}) :

    1  2
    3 16

### [map-with-index](#list-like-operations)

Works just like [map](#map) with the only difference that the given block can recieve one to three arguments: (row index, column index and cell value).

    say $matrix.map-with-index: {$^m == $^n ?? $^value !! 0 } :

    1 0
    0 4

### [reduce](#list-like-operations)

Like the built in reduce method, it iterates over all [element](#element)s and joins them into one value, by applying the given operator or method to the previous result and the next element. I starts with the element [0][0] and moving from left to right in the first row and continue with the first element of the next row.

    Math::Matrix.new([[1,2],[3,4]]).reduce(&[+]): 10 = 1 + 2 + 3 + 4
    Math::Matrix.new([[1,2],[3,4]]).reduce(&[*]): 10 = 1 * 2 * 3 * 4

### [reduce-rows](#list-like-operations)

Reduces (as described above) every row into one value, so the overall result will be a list. In this example we calculate the sum of all elements in a row:

    say Math::Matrix.new([[1,2],[3,4]]).reduce-rows(&[+]): (3, 7)

### [reduce-columns](#list-like-operations)

Similar to reduce-rows, this method reduces each column to one value in the resulting list:

    say Math::Matrix.new([[1,2],[3,4]]).reduce-columns(&[*]): (3, 8)

[Structural Operations](#methods)
---------------------------------

Methods that reorder rows and columns, delete some or even add new. The accessor [submatrix](#submatrix) is also useful for that purpose.

### [move-row](#structural-matrix-operations)

    Math::Matrix.new([[1,2,3],[4,5,6],[7,8,9]]).move-row(0,1);  # move row 0 to 1
    Math::Matrix.new([[1,2,3],[4,5,6],[7,8,9]]).move-row(0=>1); # same

    1 2 3           4 5 6
    4 5 6    ==>    1 2 3
    7 8 9           7 8 9

### [move-column](#structural-matrix-operations)

    Math::Matrix.new([[1,2,3],[4,5,6],[7,8,9]]).move-column(2,1);
    Math::Matrix.new([[1,2,3],[4,5,6],[7,8,9]]).move-column(2=>1); # same

    1 2 3           1 3 2
    4 5 6    ==>    4 6 5
    7 8 9           7 9 8

### [swap-rows](#structural-matrix-operations)

    Math::Matrix.new([[1,2,3],[4,5,6],[7,8,9]]).swap-rows(2,0);

    1 2 3           7 8 9
    4 5 6    ==>    4 5 6
    7 8 9           1 2 3

### [swap-columns](#structural-matrix-operations)

    Math::Matrix.new([[1,2,3],[4,5,6],[7,8,9]]).swap-columns(0,2);

    1 2 3           3 2 1
    4 5 6    ==>    6 5 4
    7 8 9           9 8 7

### [splice-rows](#structural-matrix-operations)

Like the splice for lists: the first two parameter are position and amount (optional) of rows to be deleted. The third and alos optional parameter will be an array of arrays (line .new would accept), that fitting row lengths. These rows will be inserted before the row with the number of first parameter. The third parameter can also be a fitting Math::Matrix.

    Math::Matrix.new([[1,2],[3,4]]).splice-rows(0,0, Math::Matrix.new([[5,6],[7,8]]) ); # aka prepend
    Math::Matrix.new([[1,2],[3,4]]).splice-rows(0,0,                  [[5,6],[7,8]]  ); # same result

    5 6
    7 8 
    1 2
    3 4

    Math::Matrix.new([[1,2],[3,4]]).splice-rows(1,0, Math::Matrix.new([[5,6],[7,8]]) ); # aka insert
    Math::Matrix.new([[1,2],[3,4]]).splice-rows(1,0,                  [[5,6],[7,8]]  ); # same result

    1 2
    5 6
    7 8
    3 4

    Math::Matrix.new([[1,2],[3,4]]).splice-rows(1,1, Math::Matrix.new([[5,6],[7,8]]) ); # aka replace
    Math::Matrix.new([[1,2],[3,4]]).splice-rows(1,1,                  [[5,6],[7,8]]  ); # same result

    1 2
    5 6 
    7 8

    Math::Matrix.new([[1,2],[3,4]]).splice-rows(2,0, Math::Matrix.new([[5,6],[7,8]]) ); # aka append
    Math::Matrix.new([[1,2],[3,4]]).splice-rows(2,0,                  [[5,6],[7,8]]  ); # same result
    Math::Matrix.new([[1,2],[3,4]]).splice-rows(-1,0,                 [[5,6],[7,8]]  ); # with negative index

    1 2 
    3 4     
    5 6
    7 8

### [splice-columns](#structural-matrix-operations)

Same as splice-rows, just horizontally.

    Math::Matrix.new([[1,2],[3,4]]).splice-columns(2,0, Math::Matrix.new([[5,6],[7,8]]) ); # aka append
    Math::Matrix.new([[1,2],[3,4]]).splice-columns(2,0,                  [[5,6],[7,8]]  ); # same result
    Math::Matrix.new([[1,2],[3,4]]).splice-columns(-1,0,                 [[5,6],[7,8]]  ); # with negative index

    1 2  ~  5 6  =  1 2 5 6
    3 4     7 8     3 4 7 8

[Shortcuts](#methods)
---------------------

Summary of all shortcut aliases (first) and their long form (second). 

  * T --> [transposed](#transposed)

  * conj --> [conjugated](#conjugated)

  * det --> [determinant](#determinant)

  * rref --> [reduced-row-echelon-form](#reduced-row-echelon-form)

[Operator Methods](#methods)
----------------------------

Operators with the methods they refer to. (Most ops are just aliases.) For more explanations of the ops with examples see naext chapter: [ops chapter](#operators):

  * prefix ? --> [Bool](#bool)

  * prefix + --> [Numeric](#numeric)

  * prefix - --> [negated](#negated)

  * prefix ~ --> [Str](#str)

  * prefix | --> [list](#list)

  * prefix @ --> [Array](#array)

  * prefix % --> [Hash](#hash)

  * prefix MM --> [new](#new--)

  * infix == --> [equal](#equal)

  * infix ~~ --> [equal](#equal) ACCEPTS

  * infix + --> [add](#add)

  * infix - --> [add](#add)

  * infix * --> [multiply](#multiply)

  * infix ⋅ dot --> [dot-product](#dot-product)

  * infix ÷ --> dot-product [inverted](#inverted)

  * infix ** --> dot-product inverted

  * infix ⊗ X* --> [tensor-product](#tensor-product)

  * circumfix ｜..｜ --> [determinant](#determinant)

  * circumfix ‖..‖ --> [norm](#norm)

  * postcircumfix [..] --> [AT-POS](#at-pos)

[Operators](#synopsis)
======================

The Module overloads or introduces a range of well and lesser known ops, which are almost all [aliases](#operator-methods).

==, +, * are commutative, -, ⋅, dot, ÷, x, ⊗ and ** are not. All ops have same precedence as its multi method siblings - unless stated otherwise.

They are exported when using no flag (same as :DEFAULT) or :ALL, but not under :MANDATORY or :MM). The only exception is MM operator, a shortcut to create a matrix. That has to be importet explicitly with the tag :MM or :ALL. The postcircumfix [] - op will always work.

    my $a   = +$matrix               # Num context, Euclidean norm
    my $b   = ?$matrix               # Bool context, True if any element has a none zero value
    my $str = ~$matrix               # String context, matrix content, space and new line separated as table
    my $l   = |$matrix               # list context, list of all elements, row-wise
    my $a   = @ $matrix              # same thing, but as Array
    my $h   = % $matrix              # hash context, similar to .kv, so that %$matrix{0}{0} is first element

    $matrixa == $matrixb             # check if both have same size and they are element wise equal
    $matrixa ~~ $matrixb             # same thing

    my $sum =  $matrixa + $matrixb;  # element wise sum of two same sized matrices
    my $sum =  $matrix  + $number;   # add number to every element

    my $dif =  $matrixa - $matrixb;  # element wise difference of two same sized matrices
    my $dif =  $matrix  - $number;   # subtract number from every element
    my $neg = -$matrix               # negate value of every element

    my $p   =  $matrixa * $matrixb;  # element wise product of two same sized matrices
    my $sp  =  $matrix  * $number;   # multiply number to every element

    my $dp  =  $a dot $b;            # dot product of two fitting matrices (cols a = rows b)
    my $dp  =  $a ⋅ $b;              # dot product, unicode (U+022C5)
    my $dp  =  $a ÷ $b;              # alias to $a dot $b.inverted, (U+000F7) 

    my $c   =  $a **  3;             # $a to the power of 3, same as $a dot $a dot $a
    my $c   =  $a ** -3;             # alias to ($a dot $a dot $a).inverted
    my $c   =  $a **  0;             # creats an right sized identity matrix

    my $tp  =  $a X* $b;             # tensor product, same precedence as infix: x (category Replication)
    my $tp  =  $a ⊗ $b;              # tensor product, unicode (U+02297)

     ｜$matrix ｜                     # determinant, unicode (U+0FF5C)
     ‖ $matrix ‖                     # L2 norm (euclidean p=2 to the square), (U+02016)

       $matrix[1][2]                 # 2nd row, 3rd column element - works even under :MANDATORY tag

    MM [[1]]                         # a new matrix, has higher precedence than postcircumfix:[]
    MM '1'                           # string alias

[Export Tags](#synopsis)
========================

  * :MANDATORY (nothing is exported)

  * :DEFAULT (same as no tag, most [ops](#operators) will be exported)

  * :MM (only [MM](#new--) op exported)

  * :ALL

[Authors](#synopsis)
====================

  * Pierre VIGIER

  * Herbert Breunung

[Contributors](#synopsis)
=========================

  * Patrick Spek

[License](#synopsis)
====================

Artistic License 2.0 (GPL and BSD at the same time)

