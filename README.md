# Function Grapher

A graphical playground for mathematical functions writen in Ruby and
[TkComponent](https://github.com/josepegea/tk_component).

![GIF demo](https://i.ibb.co/FVmNdCV/Teaser.gif)

## Visualizing functions

You can input any valid Ruby expression and it will be evaluated after
pressing the `Graph!` button.

The evaluator expects your expression to refer to `x` as the function
argument. You don't need to type the `y=` part.

Examples

``` ruby
x ** 2 + 3 * x - 5
```

``` ruby
Math.sin(x)
```

``` ruby
Math.exp(x)
```

## Panning and Zooming

You pan across the function space by clicking and drawing with the
mouse at any point in the drawing area.

You can zoom in and out by using the scrollwheel.


## Adding parameters

If you reference any other variable apart from `x` in your expression
it will be considered an editable parameter.

Example

``` ruby
a * x ** 2 + b * x + c
```

Typing this expression and clicking on the `Update params` button will
give you three editable fields where you can tweak the values for `a`,
`b` and `c`.

You can tweak these values by moving an slider or by direct input.

You can also change the range used by the slider.

In every case, the function should update in real time with every
change.

## Running it

After cloning the repo, get all the gems installed.

    $ bundle install

After that, you can launch the app with

    $ bundle exec main_app.rb

**NOTE** You need Tk installed in your system. See more information
about that in
[TkComponent](https://github.com/josepegea/tk_component).

## Previous versions

In addition to the current version, there are two other simpler
versions that you can check here:

- [graph.rb](graph.rb) A simple version that doesn't use TkComponent, just plain
  Tk and Ruby.

- [new_graph.rb](new_graph.rb) A version that does the same as `graph.rb` but using
  TkComponent. Good to check simple TkComponent concepts.

## Author

Josep Egea
  - <https://github.com/josepegea>
  - <https://www.josepegea.com/>

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
